// Shared writing template for notes and encyclopedia entries.
// All text and equations remain semantic HTML and native MathML.
#let _labelled(it) = if it.has("label") {
  html.elem("div", attrs: ("data-note-label": str(it.label)), it)
} else { it }

// Typst 0.15 omits these math elements from MathML. Keep the original
// elements in paged output (including html.frame). A styled MathML row avoids
// relying on stretchy bar glyphs, which the web math font does not provide.
#let _math-line(it, over: false) = context if target() == "html" {
  html.elem(
    "mrow",
    attrs: (class: if over { "math-overline" } else { "math-underline" }),
    html.elem("mrow", it.body),
  )
} else { it }

// SLATE typography and counters follow style/book.typ.
#let fonts = (body: "Libertinus Serif", math: "Libertinus Math", sans: "Noto Sans", mono: "Liberation Mono")
#let slate = (ink: rgb("29323b"), muted: rgb("687785"), rule: rgb("ccd5dd"), wash: rgb("f3f5f7"))
#let environment-kinds = (
  "slate-definition", "slate-theorem", "slate-remark", "slate-claim",
  "slate-question", "slate-answer", "slate-exercise", "slate-construction",
  "slate-example",
)
#let chapter-number(n) = numbering("1.1", counter(heading).get().first(), n)
#let frac = math.frac

#let note(doc) = {
  set document(title: sys.inputs.at("note-title", default: ""), author: "xiaou0")
  set text(font: (fonts.body, "Source Han Serif"), size: 11pt, fill: slate.ink, lang: "en")
  set par(justify: true, leading: 0.65em, spacing: 0.7em, first-line-indent: 0pt)
  set heading(numbering: "1.1", supplement: [Section])
  set math.equation(numbering: none, supplement: [Equation])
  show math.equation: set text(font: (fonts.math, "Source Han Serif"))
  show: content => context {
    let tagged = query(math.equation.where(block: true)).filter(eq => eq.has("label"))
    if tagged.len() > 0 {
      show selector.or(..tagged.map(eq => eq.label).dedup()): set math.equation(
        numbering: n => "(" + chapter-number(n) + ")",
      )
      content
    } else { content }
  }
  show heading: it => context {
    if it.level == 1 and it.numbering != none {
      for kind in environment-kinds { counter(figure.where(kind: kind)).update(0) }
      counter(math.equation).update(0)
    }
    let attrs = (:)
    if it.has("label") { attrs.insert("id", str(it.label)) }
    let number = if it.numbering == none { none } else { counter(heading).display(it.numbering) }
    html.elem("h" + str(calc.min(it.level + 1, 6)), attrs: attrs, [
      #if number != none {
        html.elem("span", attrs: (class: "heading-number"), number)
        [ ]
      }
      #html.elem("span", attrs: (class: "heading-body"), it.body)
    ])
  }
  // Keep labels even when only another document references them.
  show figure: _labelled
  // Typst exports equation counters and references but omits visible HTML
  // numbers. Keep native MathML and add its counter alongside it.
  show math.equation.where(block: true): it => context {
    if it.numbering == none { _labelled(it) } else {
      html.elem("div", attrs: (class: "numbered-equation"), [
        #_labelled(it)
        #html.elem("span", attrs: (class: "equation-number"), counter(math.equation).display(it.numbering))
      ])
    }
  }
  show math.underline: _math-line
  show math.overline: it => _math-line(it, over: true)
  [#metadata(none) <note>]
  html.elem("span", attrs: ("data-note-template": "", hidden: ""), [])
  doc
}

// Resolve after all notes compile, so mutual references never import each other.
#let note-ref(file, target: none, ..rest) = {
  assert(rest.pos().len() <= 1 and rest.named().len() == 0,
    message: "Write custom link text as note-ref(...)[text].")
  let body = rest.pos().at(0, default: none)
  assert(type(file) == str, message: "note-ref expects a filename string.")
  assert(target == none or type(target) in (str, label),
    message: "target must be a label or string.")
  html.elem("a", attrs: (
    "data-note": file,
    "data-note-target": if target == none { "" } else { str(target) },
    "data-note-auto": if body == none { "true" } else { "false" },
  ), if body == none { [] } else { body })
}

// GeoPedia links resolve by the globally unique title.
#let geopedia(title, target: none, ..rest) = {
  assert(type(title) == str, message: "geopedia expects a title string.")
  assert(rest.pos().len() <= 1 and rest.named().len() == 0,
    message: "Write custom link text as geopedia(...)[text].")
  assert(target == none or type(target) in (str, label),
    message: "target must be a label or string.")
  let body = rest.pos().at(0, default: none)
  html.elem("a", attrs: (
    "data-object": title,
    "data-note-target": if target == none { "" } else { str(target) },
    "data-note-auto": if body == none { "true" } else { "false" },
  ), if body == none { [] } else { body })
}

// Native figure counters preserve labels and references. The browser adapter
// moves this semantic caption above the statement body.
#let statement(kind, name, body, title: none, italic: false, style: "plain", ruled: true, to: none) = figure(
  kind: kind,
  supplement: name,
  numbering: chapter-number,
  outlined: false,
  html.elem("div", attrs: (
    "data-env": lower(name.text),
    "data-ruled": if ruled { "true" } else { "false" },
    "data-style": style,
  ), [
    #html.elem("figcaption", [
      #html.elem("span", attrs: (class: "env-label"), [#name #context counter(figure.where(kind: kind)).display(chapter-number)])
      #if title != none { html.elem("span", attrs: (class: "env-title"), title) }
      #if to != none { html.elem("span", attrs: (class: "env-target"), [(to #ref(to))]) }
    ])
    #html.elem("div", attrs: (class: "env-body"), if italic { emph(body) } else { body })
  ]),
)
#let definition = statement.with("slate-definition", [Definition])
#let theorem = statement.with("slate-theorem", [Theorem])
#let corollary = statement.with("slate-theorem", [Corollary])
#let lemma = statement.with("slate-theorem", [Lemma])
#let proposition = statement.with("slate-theorem", [Proposition])
#let remark = statement.with("slate-remark", [Remark], ruled: false)
#let claim = statement.with("slate-claim", [Claim])
#let question = statement.with("slate-question", [Question])
#let answer = statement.with("slate-answer", [Answer])
#let exercise = statement.with("slate-exercise", [Exercise])
#let construction = statement.with("slate-construction", [Construction], ruled: false)
#let example = statement.with("slate-example", [Example], ruled: false)
#let axiom = statement.with("slate-definition", [Axiom])

#let proof(body, title: [Proof]) = html.elem("div", attrs: (class: "proof"), [
  #html.elem("span", attrs: (class: "proof-label"), [#title.])
  #body
  #html.elem("span", attrs: (class: "qed", "aria-label": "End of proof"), [$square$])
])
#let proofsketch = proof.with(title: [Proof sketch])

// Native disclosure: closed initially, with keyboard and no-JavaScript support.
#let fold(body, title: "Show details") = html.elem("details", attrs: (class: "note-fold"), [
  #html.elem("summary", title)
  #html.elem("div", attrs: (class: "note-fold-body"), body)
])

// Resolve names during the site build, outside Typst's content/ root.
#let sticker(name, width: 120pt, alt: none) = {
  assert(type(name) == str and name != "", message: "sticker: provide an image name.")
  assert(type(width) == length and width > 0pt,
    message: "sticker: width must be a positive absolute length, such as 120pt.")
  assert(alt == none or type(alt) == str, message: "sticker: alt must be a text description.")
  html.elem("div", attrs: (class: "note-sticker"), html.elem("img", attrs: (
    "data-sticker": name,
    alt: if alt == none { name } else { alt },
    style: "width: " + str(width / 1pt) + "pt",
    loading: "lazy", decoding: "async",
  )))
}

#let assets-image(name, alt: none) = {
  assert(type(name) == str and name != "", message: "assets-image: provide an image name.")
  assert(alt == none or type(alt) == str, message: "assets-image: alt must be a text description.")
  html.elem("div", attrs: (class: "assets-image"), html.elem("img", attrs: (
    "data-assets-image": name,
    alt: if alt == none { name } else { alt },
    loading: "lazy", decoding: "async",
  )))
}

// Keep a distinct name so importing Fletcher's diagram never shadows this.
// Only the drawing becomes SVG; surrounding equations remain native MathML.
#let web-diagram(body, caption: none) = figure(
  html.elem("div", attrs: (
    class: "diagram-scroll",
    role: "region",
    "aria-label": "Diagram, scroll horizontally",
    tabindex: "0",
  ), html.frame({
    // SVG glyphs are fixed at compile time, so CSS cannot supply their fonts.
    set text(font: (fonts.body, "Source Han Serif"), fill: slate.ink)
    show math.equation: set text(font: ("Libertinus Math", "Source Han Serif"))
    body
  })),
  kind: "diagram",
  supplement: [Figure],
  caption: caption,
)

// Keep related diagrams on one row, with horizontal scrolling on narrow screens.
#let diagram-row(body) = html.elem("div", attrs: (
  class: "diagram-row",
  role: "region",
  "aria-label": "Diagrams, scroll horizontally",
  tabindex: "0",
), body)

#import "@preview/fletcher:0.5.8" as _fletcher

// Like web-diagram, call these in markup: #simplex2($x$, $y$, $z$).
// Keep the HTML figure outside MathML; only its labels are math content.
#let simplex2(a, b, c, ab: none, bc: none, ac: none, edge-stroke: .65pt) = web-diagram(_fletcher.diagram(
  edge-stroke: edge-stroke,
  spacing: 20pt,
  cell-size: 0pt,
  node-inset: 5pt,
  {
    _fletcher.edge(
      (-0.18, 1.02), (1.18, 1.02),
      label: $#ac$, label-side: right, marks: "->",
    )
    _fletcher.edge(
      (0.5, -0.18), (1.18, 1.02),
      label: $#bc$, label-side: left, marks: "->",
    )
    _fletcher.edge(
      (-0.18, 1.02), (0.5, -0.18),
      label: $#ab$, label-side: left, marks: "->",
    )

    _fletcher.node((-0.18, 1.02), $#a$)
    _fletcher.node((1.18, 1.02), $#c$)
    _fletcher.node((0.5, -0.18), $#b$)
    _fletcher.node((0.5, 0.61), text(size: 10pt, "///"))
  },
))
#let simplex2hollow(a, b, c, ab: none, bc: none, ac: none) = web-diagram(_fletcher.diagram(
  spacing: 20pt,
  cell-size: 0pt,
  node-inset: 5pt,
  {
    _fletcher.edge(
      (-0.18, 1.02), (1.18, 1.02),
      label: $#ac$, label-side: right, marks: "->",
    )
    _fletcher.edge(
      (0.5, -0.18), (1.18, 1.02),
      label: $#bc$, label-side: left, marks: "->",
    )
    _fletcher.edge(
      (-0.18, 1.02), (0.5, -0.18),
      label: $#ab$, label-side: left, marks: "->",
    )

    _fletcher.node((-0.18, 1.02), $#a$)
    _fletcher.node((1.18, 1.02), $#c$)
    _fletcher.node((0.5, -0.18), $#b$)
  },
))


// Call in markup: #young(3, 2) or #young(3, 2, labels: (1, 2, 3, 4, 5)).
// web-diagram exports an SVG and reuses the existing compiler/layout cache.
#let young(labels: none, ..rows) = {
  assert(rows.named().len() == 0, message: "young: labels is the only optional named argument.")
  let partition = rows.pos()
  assert(partition.len() > 0, message: "young: provide row lengths, such as #young(3, 2).")
  assert(partition.all(part => type(part) == int and part > 0),
    message: "young: row lengths must be positive integers; call #young(3, 2) in text mode.")
  for i in range(1, partition.len()) {
    assert(partition.at(i - 1) >= partition.at(i),
      message: "young: row lengths must be nonincreasing from top to bottom.")
  }
  let n = partition.sum()
  if labels != none {
    assert(type(labels) == array, message: "young: labels must be an array, such as (1, 2, 3, 4, 5).")
    assert(labels.len() == n, message: "young: the label count must equal the cell count " + str(n) + ".")
  }

  web-diagram(context {
    // Measure unbroken labels with the SVG fonts, then keep all cells square.
    let labels = if labels == none { none } else { labels.map(value => box[#value]) }
    let cell-size = 18pt
    if labels != none {
      for label in labels {
        let size = measure(label)
        cell-size = calc.max(cell-size, size.width + 4pt, size.height + 4pt)
      }
    }
    let cell-stroke = 0.65pt + slate.ink
    let cells = ()
    let index = 0
    for (row, length) in partition.enumerate() {
      for column in range(length) {
        cells.push(grid.cell(
          x: column, y: row,
          stroke: (
            top: cell-stroke,
            left: cell-stroke,
            right: if column + 1 == length { cell-stroke } else { none },
            bottom: if column >= partition.at(row + 1, default: 0) { cell-stroke } else { none },
          ),
          if labels == none { [] } else { labels.at(index) },
        ))
        index += 1
      }
    }
    // Keep the outer stroke inside the SVG viewport.
    pad(0.5pt, grid(
      columns: (cell-size,) * partition.first(),
      rows: (cell-size,) * partition.len(),
      gutter: 0pt,
      inset: 0pt,
      align: center + horizon,
      stroke: none,
      fill: none,
      ..cells,
    ))
  })
}

#import "function-plot.typ": function-plot, implicit-plot
#import "abbrev.typ" : *
