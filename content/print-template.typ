// SLATE — a quiet, self-contained template for mathematical books.
// Edit these two dictionaries to change the typography or palette globally.
#let fonts = (
  body: "Libertinus Serif",
  math: "Libertinus Math",
  sans: "Noto Sans",
  mono: "Liberation Mono",
)

#let slate = (
  ink: rgb("29323b"),
  muted: rgb("687785"),
  rule: rgb("ccd5dd"),
  wash: rgb("f3f5f7"),
)

// The four theorem-like environments deliberately share one figure kind.
// Native figure counters preserve normal <labels> and @references.
#let environment-kinds = (
  "slate-definition", "slate-theorem", "slate-remark", "slate-claim",
  "slate-question", "slate-answer", "slate-exercise", "slate-construction",
  "slate-example",
)
#let environment-selector = environment-kinds.fold(
  selector(figure.where(kind: "slate-definition")),
  (a, kind) => a.or(figure.where(kind: kind)),
)

#let chapter-number(n) = {
  let chapter = counter(heading).get().first()
  numbering("1.1", chapter, n)
}

#let statement(
  kind, name, body,
  title: none,
  italic: false,
  style: "plain",
  ruled: true,
  to: none,
) = figure(
  kind: kind,
  supplement: name,
  numbering: chapter-number,
  outlined: false,
  block(
    width: 100%,
    breakable: true,
    above: 1.15em,
    below: 1.05em,
    inset: if ruled { (left: 11pt, y: 6pt) } else { 0pt },
    stroke: if ruled { (left: 0.7pt + slate.rule) } else { none },
  )[
    #set par(first-line-indent: 0pt)
    #block(above: 0pt, below: 0.55em, sticky: true)[
      #text(font: fonts.sans, size: 0.83em, weight: "semibold", fill: slate.ink)[
        #name #context counter(figure.where(kind: kind)).display(chapter-number)
      ]
      #if title != none {
        h(0.45em)
        text(size: 0.96em, fill: slate.muted, title)
      }
      #if to != none {
        h(0.45em)
        text(size: 0.9em, fill: slate.muted)[(to #ref(to))]
      }
    ]
    #text(
      style: if italic { "italic" } else { "normal" },
      fill: if style == "remark" { slate.muted } else { slate.ink },
      body,
    )
  ],
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

// An optional, unnumbered companion to the requested environments.
#let proof(body, title: [Proof]) = block(above: 0.7em, below: 1.05em, breakable: true)[
  #set par(first-line-indent: 0pt)
  #text(style: "italic", fill: slate.muted, title). #body
  #h(1fr) #box[$square$]
]

#let running-header(short-title) = context {
  let page = here().page()
  let chapters = query(heading.where(level: 1)).filter(it =>
    it.numbering != none and it.location().page() <= page
  )
  // Chapter openings already identify themselves; keep their top margin quiet.
  if chapters.len() > 0 and chapters.last().location().page() < page {
    let title = if calc.odd(page) { chapters.last().body } else { short-title }
    set text(font: fonts.sans, size: 7.5pt, fill: slate.muted)
    block(width: 100%, below: 0pt)[
      #title
      #v(5pt)
      #line(length: 100%, stroke: 0.4pt + slate.rule)
    ]
  }
}

#let folio(pattern: "1") = context {
  align(if calc.odd(here().page()) { right } else { left })[
    #text(font: fonts.sans, size: 8pt, fill: slate.muted)[
      #counter(page).display(pattern)
    ]
  ]
}

#let book(
  title: [Untitled],
  subtitle: none,
  author: "Author Name",
  series: [MATHEMATICS],
  edition: [First edition],
  year: [2026],
  short-title: auto,
  toc: true,
  toc-depth: 2,
  page-width: 170mm,
  page-height: 240mm,
  font-size: 11pt,
  body,
) = {
  let running-title = if short-title == auto { title } else { short-title }
  set document(title: title, author: author)
  set text(font: fonts.body, size: font-size, fill: slate.ink, lang: "en")
  set par(justify: true, leading: 0.65em, spacing: 0.7em, first-line-indent: 0pt)
  // Allow content to flow across pages, including wrappers around long content.
  set block(breakable: true)
  show figure: set block(breakable: true)
  show math.equation.where(block: true): set block(breakable: true)
  show raw.where(block: true): set block(breakable: true)
  set page(
    width: page-width,
    height: page-height,
    margin: (inside: 23mm, outside: 21mm, top: 23mm, bottom: 22mm),
    header-ascent: 9mm,
    footer-descent: 10mm,
    header: running-header(running-title),
    footer: folio(),
    numbering: "1",
  )
  set heading(numbering: "1.1", supplement: [Section])
  show heading.where(level: 1): set heading(supplement: [Chapter])
  show math.equation: set text(font: fonts.math)
  set math.equation(
    numbering: none,
    supplement: [Equation],
  )
  // Style the original labeled equations so counters and references stay native.
  // Unlabeled display equations neither show nor consume a number.
  show: content => context {
    let tagged = query(math.equation.where(block: true)).filter(eq => eq.has("label"))
    if tagged.len() > 0 {
      let labels = tagged.map(eq => eq.label).dedup()
      show selector.or(..labels): set math.equation(
        numbering: n => "(" + chapter-number(n) + ")",
      )
      content
    } else {
      content
    }
  }
  show raw: set text(font: fonts.mono, size: 0.85em)
  show link: set text(fill: slate.muted)
  set list(indent: 1em, body-indent: 0.55em)
  set enum(indent: 1em, body-indent: 0.55em)

  // Keep environments in the text flow, and allow long statements to split.
  show environment-selector: set align(left)
  show environment-selector: it => it.body

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    if it.numbering != none {
      for kind in environment-kinds {
        counter(figure.where(kind: kind)).update(0)
      }
      counter(math.equation).update(0)
    }
    block(above: 8mm, below: 10mm)[
      #if it.numbering != none {
        text(font: fonts.sans, size: 8pt, tracking: 1.5pt, fill: slate.muted)[
          CHAPTER #context numbering("01", counter(heading).get().first())
        ]
        v(4mm)
      }
      #text(font: fonts.body, size: 29pt, weight: "regular", it.body)
      #v(5mm)
      #line(length: 100%, stroke: 0.5pt + slate.rule)
    ]
  }

  show heading.where(level: 2): it => block(above: 1.5em, below: 0.7em)[
    #set text(font: fonts.sans, size: 11.5pt, weight: "semibold")
    #if it.numbering != none {
      text(fill: slate.muted)[#context counter(heading).display(it.numbering)]
      h(0.7em)
    }
    #it.body
  ]

  show heading.where(level: 3): it => block(above: 1.1em, below: 0.5em)[
    #set text(font: fonts.sans, size: 10pt, weight: "semibold")
    #if it.numbering != none {
      text(fill: slate.muted)[#context counter(heading).display(it.numbering)]
      h(0.6em)
    }
    #it.body
  ]

  page(header: none, footer: none, numbering: none)[
    #set par(justify: false)
    #v(6mm)
    #text(font: fonts.sans, size: 8pt, tracking: 1.8pt, fill: slate.muted, series)
    #v(31mm)
    #block(width: 100%)[
      #set par(leading: 0.3em)
      #text(size: 38pt, weight: "regular", title)
    ]
    #if subtitle != none {
      v(6mm)
      text(font: fonts.sans, size: 10pt, fill: slate.muted, subtitle)
    }
    #v(11mm)
    #line(length: 22mm, stroke: 0.7pt + slate.rule)
    #v(7mm)
    #text(size: 13pt, author)
    #v(1fr)
    #line(length: 100%, stroke: 0.5pt + slate.rule)
    #v(4mm)
    #text(font: fonts.sans, size: 8pt, fill: slate.muted)[
      #edition #h(1fr) #year
    ]
  ]

  if toc {
    page(header: none, footer: folio(pattern: "i"), numbering: "i")[
      #counter(page).update(1)
      #v(8mm)
      #text(size: 29pt)[Contents]
      #v(5mm)
      #line(length: 100%, stroke: 0.5pt + slate.rule)
      #v(11mm)
      #set par(leading: 0.8em)
      #set outline.entry(fill: none)
      #show outline.entry.where(level: 1): set text(weight: "semibold")
      #outline(title: none, depth: toc-depth, indent: 1.3em)
    ]
  }

  counter(page).update(1)
  body
}

#import "abbrev.typ" : *
// style/refs.typ was not supplied; bibliography shortcuts are not imported.
#import "function-plot.typ": function-plot, implicit-plot

// The website uses the name `note`; the SLATE options are unchanged.
#let note = book
#let axiom = statement.with("slate-definition", [Axiom])
#let proofsketch = proof.with(title: [Proof sketch])
#let frac = math.frac
#let fold(body, title: "Show details") = block(above: 1.15em, below: 1.05em)[
  #text(font: fonts.sans, size: 0.83em, weight: "semibold", fill: slate.muted, title)
  #parbreak()
  #body
]
#let web-diagram(body, caption: none) = figure(body, kind: "diagram", supplement: [Figure], caption: caption)
#let diagram-row(body) = block(width: 100%, above: 1.15em, below: 1.05em, body)
