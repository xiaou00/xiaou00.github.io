// Liber 777 · 普通 Typst / PDF 模板
// 用法见 print-example.typ。与网页共用数学缩写，不依赖 HTML 导出。
#import "abbrev.typ": *

#let palette = (
  paper: rgb("#ffffff"),
  ink: rgb("#242424"),
  muted: rgb("#706c68"),
  accent: rgb("#a33632"),
  line: rgb("#d8d3cd"),
  mist: rgb("#f5f3f0"),
)

// 正文与辅助环境共用间距尺度，随 note(size: ...) 一起缩放。
#let _rhythm = (
  leading: 0.62em,
  paragraph: 1.05em,
  block: 1em,
  label: 0.45em,
  inset: 1em,
  equation: 0.8em,
)

// 与网页相同：斜线分式保持横排，显式 frac(...) 使用上下分式。
#let frac = math.frac.with(style: "vertical")

#let _env-kinds = (
  "theorem", "lemma", "proposition", "corollary", "definition", "axiom",
  "exercise", "construction", "claim",
  "example", "remark", "question",
)
#let _quiet-kinds = ("example", "remark", "question")

#let _env(kind, name, body, title: "", numbered: true) = figure(
  body,
  kind: kind,
  supplement: name,
  numbering: if numbered { "1" } else { none },
  caption: if title == "" { [] } else { [#title] },
)

#let theorem(body, title: "") = _env("theorem", [定理], body, title: title)
#let lemma(body, title: "") = _env("lemma", [引理], body, title: title)
#let proposition(body, title: "") = _env("proposition", [命题], body, title: title)
#let corollary(body, title: "") = _env("corollary", [推论], body, title: title)
#let definition(body, title: "") = _env("definition", [定义], body, title: title)
#let axiom(body, title: "") = _env("axiom", [公理], body, title: title)
#let exercise(body, title: "") = _env("exercise", [练习], body, title: title)
#let construction(body, title: "") = _env("construction", [构造], body, title: title)
#let claim(body, title: "") = _env("claim", [断言], body, title: title)
#let example(body, title: "") = _env("example", [例], body, title: title, numbered: false)
#let remark(body, title: "") = _env("remark", [注], body, title: title, numbered: false)
#let question(body, title: "") = _env("question", [问题], body, title: title, numbered: false)

#let _proof(name, body) = block(
  width: 100%, breakable: true,
  inset: (left: _rhythm.inset), above: 0.55em, below: _rhythm.block,
  {
    set text(size: 0.96em)
    text(fill: palette.muted, weight: "medium", name)
    h(0.65em)
    body
    h(1fr)
    box(text(fill: palette.muted)[□])
  },
)
#let proof(body) = _proof([证明], body)
#let proofsketch(body) = _proof([证明思路], body)
#let answer(body) = _proof([解答], body)

// PDF 中完整展开折叠内容。
#let fold(body, title: "展开查看") = block(
  width: 100%, breakable: true,
  stroke: (top: 0.5pt + palette.line, bottom: 0.5pt + palette.line),
  inset: _rhythm.inset, above: _rhythm.block, below: _rhythm.block,
  [
    #block(above: 0pt, below: _rhythm.label, sticky: true,
      text(size: 0.96em, fill: palette.accent, weight: "medium", title))
    #body
  ],
)

// 保留网页的包裹方式，绘图直接以矢量内容进入 PDF。
#let web-diagram(body, caption: none) = figure(
  body, kind: "diagram", supplement: [图], caption: caption,
)
#let diagram-row(body) = block(width: 100%, above: _rhythm.block, below: _rhythm.block, body)

#let _running-head(title) = context {
  let chapters = query(heading.where(level: 1)).filter(h => h.numbering != none)
  let previous = chapters.filter(h => h.location().page() <= here().page())
  let chapter = if previous.len() > 0 { previous.last().body } else { [] }
  set text(size: 8pt, fill: palette.muted)
  set par(justify: false, leading: 0.4em, spacing: 0pt)
  block(width: 100%, below: 0pt)[
    #grid(columns: (1fr, 1fr), gutter: 12pt, title, align(right, chapter))
    #v(5pt)
    #line(length: 100%, stroke: 0.45pt + palette.line)
  ]
}

#let _folio(series, numbering: "1") = context {
  set text(size: 8pt, fill: palette.muted)
  grid(
    columns: (1fr, auto), align: horizon,
    series,
    [#box(line(length: 9pt, stroke: 0.7pt + palette.accent))#h(6pt)#text(fill: palette.ink, counter(page).display(numbering))],
  )
}

#let _cover(title, subtitle, author, date, series, description, edition) = page(
  header: none, footer: none, numbering: none,
  margin: (top: 27mm, bottom: 25mm, x: 26mm),
  {
    set par(justify: false, leading: 0.5em, spacing: 0pt)
    set block(above: 0pt, below: 0pt)
    grid(
      columns: (auto, 1fr), gutter: 10pt, align: horizon,
      line(start: (0pt, 0pt), end: (0pt, 14pt), stroke: 1.6pt + palette.accent),
      text(size: 10pt, tracking: 0.06em, series),
    )
    v(1fr)
    line(length: 26mm, stroke: 1pt + palette.accent)
    v(10mm)
    block(width: 100%)[
      #set par(leading: 0.3em)
      #text(size: 34pt, weight: "regular", tracking: 0.02em, title)
    ]
    if subtitle != none {
      v(4mm)
      block(text(size: 13pt, fill: palette.muted, subtitle))
    }
    if description != none {
      v(10mm)
      block(width: 78%, text(size: 10pt, fill: palette.muted, description))
    }
    v(1.4fr)
    line(length: 100%, stroke: 0.5pt + palette.line)
    v(6mm)
    grid(
      columns: (1fr, 1fr), gutter: 16pt,
      [
        #text(size: 8pt, fill: palette.muted)[著者]
        #v(4pt)
        #text(size: 11pt, author)
      ],
      if date != none { align(right)[
        #text(size: 8pt, fill: palette.muted)[日期]
        #v(4pt)
        #text(size: 11pt, date)
      ] } else { [] },
    )
    if edition != none {
      v(8mm)
      text(size: 8pt, fill: palette.muted, edition)
    }
  },
)

// = 章节；== 小节；=== 小小节；==== 小小小节。
// 正文从第 1 页开始；目录独立使用小写罗马页码。
#let note(
  body,
  title: "数学笔记",
  subtitle: none,
  author: "xiaou0",
  date: none,
  series: "Liber 777",
  description: none,
  edition: none,
  running-title: auto,
  cover: true,
  contents: true,
  toc-depth: 4,
  chapter-break: true,
  font: ("Source Han Serif", "Libertinus Serif"),
  math-font: ("Libertinus Math", "New Computer Modern Math", "Source Han Serif"),
  size: 11pt,
) = {
  set document(title: title, author: author)
  // 为汉字保留完整字面高度，避免沿用西文大写高度时标题、列表贴得过近。
  set text(font: font, size: size, fill: palette.ink, lang: "zh",
    top-edge: 0.88em, bottom-edge: 0.12em)
  set smartquote(enabled: false)
  set par(justify: true, leading: _rhythm.leading, spacing: _rhythm.paragraph, first-line-indent: 0pt)
  set page(
    paper: "a4", fill: palette.paper,
    margin: (top: 25mm, bottom: 24mm, x: 26mm),
    header-ascent: 8mm, footer-descent: 8mm,
    numbering: "1",
    header: _running-head(if running-title == auto { title } else { running-title }),
    footer: _folio(series),
  )
  set heading(numbering: "1.1", supplement: [节])
  set math.frac(style: "horizontal")
  set math.equation(supplement: [式])
  show math.equation: set text(font: math-font, size: 1.05em)
  show math.equation.where(block: true): set block(above: _rhythm.equation, below: _rhythm.equation)
  show emph: it => text(fill: palette.accent, it.body)
  show strong: set text(weight: "semibold")
  show link: set text(fill: palette.accent)
  show ref: set text(fill: palette.accent)

  show heading: it => context {
    set par(justify: false, leading: 0.3em, spacing: 0pt)
    set text(size: size, weight: "regular")
    let level = it.level
    if level == 1 and chapter-break { pagebreak(weak: true) }
    if level == 1 {
      block(
        width: 100%, above: if chapter-break { 0.5em } else { 1.8em },
        below: 1.2em, inset: (bottom: 0.9em),
        stroke: (bottom: 0.5pt + palette.line), sticky: true, breakable: false,
      )[
        #if it.numbering != none {
          block(above: 0pt, below: 0.55em,
            text(size: 0.78em, fill: palette.accent, tracking: 0.08em)[第 #counter(heading).display("1") 章])
        }
        #text(size: 2em, it.body)
      ]
    } else {
      let sizes = (1.35em, 1.12em, 1em)
      let spaces = (1.65em, 1.3em, 1.1em)
      let index = calc.min(level - 2, 2)
      block(above: spaces.at(index), below: 0.65em, sticky: true, breakable: false)[
        #set text(size: sizes.at(index), weight: if level >= 3 { "medium" } else { "regular" })
        #if it.numbering == none { it.body } else {
          grid(
            columns: (auto, 1fr), gutter: 0.6em,
            text(fill: palette.muted, counter(heading).display(it.numbering)),
            it.body,
          )
        }
      ]
    }
  }

  // 保留 figure 的原生计数与标签，长定理允许跨页。
  show figure: it => context {
    if it.kind in _env-kinds {
      let quiet = it.kind in _quiet-kinds
      block(
        width: 100%, breakable: true,
        inset: (left: _rhythm.inset, right: 0.3em, y: if quiet { 0.3em } else { 0.5em }),
        stroke: (left: 0.65pt + palette.line),
        above: _rhythm.block, below: _rhythm.block,
        [
          #set align(left)
          #set par(justify: true)
          #block(above: 0pt, below: _rhythm.label, sticky: true)[
            #set text(size: 0.96em, fill: if quiet { palette.muted } else { palette.ink })
            #text(weight: "semibold")[
              #it.supplement#if it.numbering != none { [ #counter(figure.where(kind: it.kind)).display(it.numbering)] }
            ]#if it.caption.body != [] { [#h(0.5em)#text(weight: "regular", fill: palette.muted)[（#it.caption.body）]] }
          ]
          #it.body
        ],
      )
    } else { it }
  }
  show figure.caption: set text(size: 9pt, fill: palette.muted)

  set list(indent: 0.3em, body-indent: 0.6em, spacing: 0.6em)
  set enum(indent: 0.3em, body-indent: 0.6em, spacing: 0.6em)
  show list: set block(above: 0.65em, below: _rhythm.block)
  show enum: set block(above: 0.65em, below: _rhythm.block)
  set list(marker: text(fill: palette.muted)[•])
  set raw(theme: none)
  // raw 默认还会缩小至 0.8 倍；抵消这一层缩放，保持代码可读。
  show raw: set text(font: "DejaVu Sans Mono", size: 0.86em / 0.8)
  show raw.where(block: true): it => block(
    width: 100%, breakable: true, fill: palette.mist,
    inset: _rhythm.inset, above: _rhythm.block, below: _rhythm.block,
    {
      set par(justify: false, leading: 0.55em)
      it
    },
  )
  show raw.where(block: false): it => box(fill: palette.mist, radius: 1.5pt, inset: (x: 0.22em, y: 0.08em), it)
  show quote.where(block: true): it => block(
    width: 100%, breakable: true, inset: (left: _rhythm.inset, y: 0.4em),
    stroke: (left: 0.65pt + palette.line), above: _rhythm.block, below: _rhythm.block,
    text(fill: palette.muted, size: 0.95em, it.body),
  )
  set table(
    stroke: none, inset: (x: 0.8em, y: 0.55em),
    fill: (_, y) => if calc.odd(y) { palette.mist } else { none },
  )
  show table: set text(size: 0.92em)
  show table: set par(justify: false, leading: 0.45em)
  show table: set block(above: _rhythm.block, below: _rhythm.block)
  show table.header: set text(weight: "medium", fill: palette.muted)
  show table.header: set table.cell(stroke: (bottom: 0.5pt + palette.line))
  show footnote.entry: set text(size: 0.78em)
  show footnote.entry: set par(leading: 0.45em, spacing: 0.5em)

  if cover { _cover(title, subtitle, author, date, series, description, edition) }

  if contents {
    // 块作用域防止目录的链接颜色与行距影响正文。
    [
      #set page(header: none, numbering: "i", footer: _folio(series, numbering: "i"))
      #counter(page).update(1)
      #heading(numbering: none, outlined: false)[目录]
      #set par(justify: false, leading: 0.45em, spacing: 0pt)
      #show link: set text(fill: palette.ink)
      #set outline.entry(fill: repeat(gap: 0.3em)[#text(fill: palette.line)[·]])
      #show outline.entry: it => {
        let chapter = it.level == 1
        block(above: if chapter { 0.9em } else { 0pt }, below: 0pt, inset: (y: 0.28em))[
          #set text(size: if chapter { size } else { size * 0.88 }, weight: if chapter { "medium" } else { "regular" })
          #link(it.element.location(), it.indented(
            text(fill: if chapter { palette.accent } else { palette.muted }, it.prefix()),
            it.inner(),
          ))
        ]
      }
      #outline(title: none, depth: toc-depth, indent: 1.4em)
      #pagebreak()
    ]
  }

  counter(page).update(1)
  body
}
