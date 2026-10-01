// Native Typst paths: no plotting package or browser runtime is required.
// https://typst.app/docs/reference/visualize/curve/
#let _finite(value) = type(value) in (int, float) and value == value and calc.abs(value) < calc.inf

#let _tick-step(span) = {
  let raw = span / 10
  let power = calc.pow(10, calc.floor(calc.log(raw, base: 10)))
  (1, 2, 5, 10).find(n => n * power >= raw) * power
}

#let _ticks(limits, step: none) = {
  let step = if step == none { _tick-step(limits.last() - limits.first()) } else { step }
  let first = int(calc.ceil(limits.first() / step))
  let last = int(calc.floor(limits.last() / step))
  range(first, last + 1).map(i => i * step)
}

// Clip each segment before mapping it to physical lengths. Discontinuities
// explicitly listed in breaks are never evaluated or connected across.
#let _plot-path(f, xs, ys, samples, breaks, w, h) = {
  let path = ()
  let previous = none
  let connected = false
  let (xmin, xmax) = xs
  let (ymin, ymax) = ys
  let point(p) = ((p.at(0) - xmin) / (xmax - xmin) * w,
    (ymax - p.at(1)) / (ymax - ymin) * h)
  for i in range(samples + 1) {
    let x = xmin + (xmax - xmin) * i / samples
    let y = if x in breaks { none } else { f(x) }
    assert(y == none or type(y) in (int, float),
      message: "function-plot: 函数必须返回数值或 none.")
    if not _finite(y) {
      previous = none
      connected = false
      continue
    }
    let current = (x, y)
    if previous != none and not breaks.any(b => previous.at(0) <= b and b <= x) {
      let (px, py) = previous
      let inside-a = ymin <= py and py <= ymax
      let inside-b = ymin <= y and y <= ymax
      // Do not draw a false diagonal between opposite sides of a pole.
      if inside-a or inside-b {
        let a = previous
        let b = current
        if not inside-a {
          let edge = calc.clamp(py, ymin, ymax)
          a = (px + (x - px) * (edge - py) / (y - py), edge)
        }
        if not inside-b {
          let edge = calc.clamp(y, ymin, ymax)
          b = (px + (x - px) * (edge - py) / (y - py), edge)
        }
        if not connected { path.push(curve.move(point(a))) }
        path.push(curve.line(point(b)))
        connected = inside-b
      } else { connected = false }
    } else { connected = false }
    previous = current
  }
  path
}

// Marching squares with interpolated edges and a center sample for saddles.
// https://scikit-image.org/docs/stable/api/skimage.measure.html#skimage.measure.find_contours
#let _implicit-path(f, xs, ys, samples, w, h) = {
  let evaluate(x, y) = {
    let value = f(x, y)
    assert(value == none or type(value) in (int, float),
      message: "implicit-plot: 请返回方程左边减右边的数值, 例如 (x, y) => x*x + y*y - 4, 不要返回布尔值.")
    value
  }
  let x-at(i) = xs.first() + (xs.last() - xs.first()) * i / samples
  let y-at(j) = ys.first() + (ys.last() - ys.first()) * j / samples
  let row(j) = range(samples + 1).map(i => evaluate(x-at(i), y-at(j)))
  let point(p) = (p.at(0) / samples * w, (1 - p.at(1) / samples) * h)
  let segment(a, b) = if a == b { () } else { (curve.move(point(a)), curve.line(point(b))) }
  let lower = row(0)
  let path = ()
  for j in range(samples) {
    let upper = row(j + 1)
    for i in range(samples) {
      let values = (lower.at(i), lower.at(i + 1), upper.at(i + 1), upper.at(i))
      if not values.all(_finite) { continue }
      if values.all(v => v == 0) { continue }
      let corners = ((i, j), (i + 1, j), (i + 1, j + 1), (i, j + 1))
      let crossings = ()
      let zero-edges = ()
      for a in range(4) {
        let b = calc.rem(a + 1, 4)
        let va = values.at(a)
        let vb = values.at(b)
        if va == 0 and vb == 0 { zero-edges += segment(corners.at(a), corners.at(b)) }
        if (va < 0) != (vb < 0) {
          let scale = calc.max(calc.abs(va), calc.abs(vb))
          let t = (va / scale) / (va / scale - vb / scale)
          let pa = corners.at(a)
          let pb = corners.at(b)
          crossings.push((pa.at(0) + t * (pb.at(0) - pa.at(0)), pa.at(1) + t * (pb.at(1) - pa.at(1))))
        }
      }
      path += zero-edges
      // Preserve roots exactly on grid edges, including the crossing xy = 0.
      if zero-edges.len() > 0 and not (values.any(v => v < 0) and values.any(v => v > 0)) { continue }
      if crossings.len() == 2 {
        path += segment(..crossings)
      } else if crossings.len() == 4 {
        let mid = evaluate(x-at(i + 0.5), y-at(j + 0.5))
        if not _finite(mid) { continue }
        if mid == 0 {
          for crossing in crossings { path += segment(crossing, (i + 0.5, j + 0.5)) }
        } else {
          let pairs = if (mid < 0) == (values.first() < 0) { ((0, 1), (2, 3)) } else { ((0, 3), (1, 2)) }
          for (a, b) in pairs { path += segment(crossings.at(a), crossings.at(b)) }
        }
      }
    }
    lower = upper
  }
  path
}

// Call in markup, e.g. #function-plot(x => x * x, y-range: (-1, 9)).
#let function-plot(
  functions,
  x-range: (-5, 5), y-range: (-5, 5),
  width: 264pt, height: 180pt,
  labels: none, x-label: none, y-label: none,
  colors: (rgb("#ff0000"), rgb("#242424"), rgb("#777777")),
  grid: true, samples: 400, breaks: (),
  implicit: false, equal: true,
  caption: none, alt: "函数图像",
) = {
  let fs = if type(functions) == function { (functions,) } else { functions }
  assert(type(fs) == array and fs.len() > 0 and fs.all(f => type(f) == function),
    message: "function-plot: 请传入函数或非空函数数组, 例如 x => x * x.")
  for limits in (x-range, y-range) {
    assert(type(limits) == array and limits.len() == 2 and limits.all(_finite)
      and limits.first() < limits.last() and _finite(limits.last() - limits.first()),
      message: "function-plot: 坐标范围必须是两个递增的有限数值.")
  }
  assert(type(width) == length and width >= 160pt and type(height) == length and height >= 120pt,
    message: "function-plot: width 和 height 须为绝对长度, 至少为 160pt 和 120pt.")
  assert(type(implicit) == bool and type(equal) == bool,
    message: "function-plot: implicit 和 equal 须为布尔值.")
  let max-samples = if implicit { 200 } else { 10000 }
  assert(type(samples) == int and 16 <= samples and samples <= max-samples,
    message: "function-plot: samples 必须是 16 到 " + str(max-samples) + " 之间的整数.")
  assert(type(breaks) == array and breaks.all(_finite),
    message: "function-plot: breaks 必须是有限数值数组.")
  assert(not implicit or breaks.len() == 0,
    message: "implicit-plot: 定义域外请返回 none, 不使用 breaks.")
  assert(labels == none or (type(labels) == array and labels.len() == fs.len()),
    message: "function-plot: labels 数量须与函数数量一致.")
  assert(type(colors) == array and colors.len() > 0 and colors.all(c => type(c) == color),
    message: "function-plot: colors 必须是非空颜色数组.")
  assert(type(grid) == bool and type(alt) == str,
    message: "function-plot: grid 须为布尔值, alt 须为文字说明.")

  let drawing = context {
    set text(font: "Source Han Serif", size: 9pt, fill: rgb("#666666"))
    show math.equation: set text(font: ("Libertinus Math", "Source Han Serif"))
    let left-pad = 24pt
    let top-pad = 18pt
    let w = width - 2 * left-pad
    let h = height - 2 * top-pad
    let (xmin, xmax) = x-range
    let (ymin, ymax) = y-range
    if equal {
      let unit = calc.min(w / (xmax - xmin), h / (ymax - ymin))
      let plot-width = unit * (xmax - xmin)
      let plot-height = unit * (ymax - ymin)
      left-pad += (w - plot-width) / 2
      top-pad += (h - plot-height) / 2
      w = plot-width
      h = plot-height
    }
    let px(x) = left-pad + (x - xmin) / (xmax - xmin) * w
    let py(y) = top-pad + (ymax - y) / (ymax - ymin) * h
    let x0 = px(calc.clamp(0, xmin, xmax))
    let y0 = py(calc.clamp(0, ymin, ymax))
    // Equal axis units also need one shared tick step for square grid cells.
    let step = if equal { _tick-step(calc.max(xmax - xmin, ymax - ymin)) } else { none }
    let xticks = _ticks(x-range, step: step)
    let yticks = _ticks(y-range, step: step)
    let axis-stroke = 0.55pt + rgb("#777777")
    let frame-stroke = 0.65pt + black
    let tick-stroke = 0.5pt + black
    let stroke-at(i) = (paint: colors.at(calc.rem(i, colors.len())), thickness: 1.15pt, cap: "round", join: "round")
    let segment(a, b, stroke: axis-stroke) = place(top + left, line(start: a, end: b, stroke: stroke))
    let label-at(x, y, body, horizontal: center, vertical: top) = {
      let size = measure(box(body))
      let dx = if horizontal == right { size.width } else if horizontal == center { size.width / 2 } else { 0pt }
      let dy = if vertical == bottom { size.height } else if vertical == horizon { size.height / 2 } else { 0pt }
      place(top + left, dx: x - dx, dy: y - dy, box(body))
    }
    block(width: width, above: 0pt, below: 0pt, {
      block(width: width, height: height, above: 0pt, below: 0pt, {
        if grid {
          for x in xticks.filter(x => xmin < x and x < xmax) {
            for y in yticks.filter(y => ymin < y and y < ymax) {
              place(top + left, dx: px(x) - 0.75pt, dy: py(y) - 0.75pt,
                circle(radius: 0.75pt, fill: rgb("#bbbbbb"), stroke: none))
            }
          }
        }
        segment((left-pad, y0), (left-pad + w, y0))
        segment((x0, top-pad + h), (x0, top-pad))
        if x-label != none { label-at(left-pad + w + 12pt, y0, x-label, vertical: horizon) }
        if y-label != none { label-at(x0, top-pad - 8pt, y-label, vertical: bottom) }
        for (i, f) in fs.enumerate() {
          let path = if implicit {
            _implicit-path(f, x-range, y-range, samples, w, h)
          } else { _plot-path(f, x-range, y-range, samples, breaks, w, h) }
          if path.len() > 0 {
            place(top + left, dx: left-pad, dy: top-pad,
              block(width: w, height: h, clip: true, curve(stroke: stroke-at(i), ..path)))
          }
        }
        // Frame and inward ticks bound the data area, without numeric labels.
        place(top + left, dx: left-pad, dy: top-pad,
          rect(width: w, height: h, inset: 0pt, fill: none, stroke: frame-stroke))
        for x in xticks.filter(x => xmin < x and x < xmax) {
          segment((px(x), top-pad), (px(x), top-pad + 2.5pt), stroke: tick-stroke)
          segment((px(x), top-pad + h), (px(x), top-pad + h - 2.5pt), stroke: tick-stroke)
        }
        for y in yticks.filter(y => ymin < y and y < ymax) {
          segment((left-pad, py(y)), (left-pad + 2.5pt, py(y)), stroke: tick-stroke)
          segment((left-pad + w, py(y)), (left-pad + w - 2.5pt, py(y)), stroke: tick-stroke)
        }
      })
      if labels != none {
        v(5pt)
        align(center, {
          for (i, label) in labels.enumerate() {
            box(inset: (x: 7pt, y: 3pt), [#box(width: 15pt, height: 6pt, place(top + left, dy: 3pt, line(length: 12pt, stroke: stroke-at(i))))#box(width: 3pt)#label])
            [ ]
          }
        })
      }
    })
  }
  figure(
    context if target() == "html" {
      html.elem("div", attrs: (
        class: "diagram-scroll function-plot" + if implicit { " implicit-plot" } else { "" },
        role: "img", "aria-label": alt,
        style: "width: " + str(width / 1pt) + "pt",
      ), html.frame(drawing))
    } else { drawing },
    kind: "diagram", supplement: [图], caption: caption,
  )
}

// Express F(x, y) = 0 as a numeric function. Equal axis units preserve circles.
#let implicit-plot = function-plot.with(implicit: true, equal: true, samples: 80, alt: "隐式方程图像")
