# SLATE · Typst / PDF template

`print-template.typ` adopts the layout in `style/book.typ`: 170 × 240 mm pages, 11pt Libertinus Serif, Libertinus Math, Noto Sans headings, Liberation Mono code, and the original SLATE gray-blue palette. Chapter titles, statement spacing, running headers, folios, title page, and contents follow the supplied reference. `print-example.pdf` is a generated preview.

The reference imports `refs.typ`, which was not supplied. That import is omitted; the `HTT`, `HA`, `Kerodon`, and `Stacks` bibliography shortcuts are therefore unavailable. The supplied `style/abbrev.typ` is copied to `content/abbrev.typ` for both web and print.

## Usage

```typst
#import "print-template.typ": *

#show: note.with(
  title: "My mathematical notes",
  subtitle: "An optional subtitle",
  author: "Your name",
  series: [MATHEMATICS],
  edition: [First edition],
  year: [2026],
)

= A chapter
== A section

#definition(title: [An example])[
  Write your definition here.
] <definition>

#theorem[Write a result here.] <result>
#proof[Explain why @result holds.]

$ a^2 + b^2 = c^2 $ <equation>

Refer to @definition and @equation.
```

`note` is an alias of the reference template's `book` function. Adjust the relative import when writing from another folder. Keep `abbrev.typ` and `function-plot.typ` alongside the template if you move it to another project.

## Options

| Option | Default | Purpose |
| --- | --- | --- |
| `toc` | `true` | Include a table of contents |
| `toc-depth` | `2` | Maximum outline depth |
| `short-title` | Document title | Short title in the running header |
| `font-size` | `11pt` | Body text size |
| `page-width` | `170mm` | Page width |
| `page-height` | `240mm` | Page height |
| `series` | `MATHEMATICS` | Series on the title page |
| `edition` | `First edition` | Edition on the title page |
| `year` | `2026` | Year on the title page |

These replace the previous `contents`, `running-title`, `size`, `date`, and `chapter-break` options. Numbered chapters start on a new page.

Theorem, lemma, proposition, and corollary share a counter. Each other statement type has its own counter; `axiom` is a compatibility helper sharing the definition counter. All statements, including examples, remarks, questions, and answers, use chapter-prefixed numbering. Counters reset at numbered level-one headings. Remarks, constructions, and examples omit the left rule. Proofs are unnumbered, with an italic label and an end-of-proof square.

Statements accept `title`, `italic`, `style`, `ruled`, and `to`, matching the reference. For example, `#answer(to: <question>)[A response.]` links to a labeled question. Only labeled display equations are numbered; unlabeled equations do not consume a number. Fractions use native Typst typesetting. Use an escaped slash (`$A \/ B$`) for a literal quotient slash.

Folded content is shown in full on paper; diagrams and function plots remain vector graphics. Use `@label` within the document and `#link("https://example.com")[Link text]` for external links. The website's `note-ref` and `geopedia` resolution is not available in a standalone PDF.

## Compile

Use Typst 0.15.1 or later. The website build prepares all required fonts, so the PDF can be compiled without system fonts:

```sh
npm run build
typst compile --ignore-system-fonts --font-path .build/typst-fonts content/print-example.typ content/print-example.pdf
```

Browser printing keeps the blog's compact heading hierarchy and continuous sections, using the reference's page size, margins, and fonts. Use the standalone Typst PDF for the original chapter layout, running headers, folios, contents pagination, and title page.
