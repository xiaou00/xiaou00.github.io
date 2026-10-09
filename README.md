# Liber 777

A small personal website with **Home**, **Notes**, and **Encyclopedia**. Write in Typst; the build produces static HTML, native MathML, and SVG diagrams. There is no browser framework or client-side math compiler.

## Run locally

Use Node.js 22+ and Typst 0.15.1+.

```sh
npm install
npm run dev
```

Open <http://127.0.0.1:5173>. Saving content, shared templates, styles, or configuration rebuilds the preview. Compilation errors leave the last successful version available and appear in the browser until fixed.

```sh
npm run build                  # Generate dist/
npm run preview                # Build and serve the static site
npm run dev -- --port 5174      # Use another port
npm run build -- --no-cache     # Force a fresh compilation
```

Set `TYPST_BIN` if Typst is not on your PATH. Development output lives in `.build/dev/`; production output lives in `dist/`.

## Personal home page

Edit `site.config.mjs`. The `profile` object contains the name, role, About paragraphs, interests, and external links. The bracketed text is placeholder content to replace with your own details. Empty optional lists are omitted from the page.

The site has three independent routes:

| Route | Content |
| --- | --- |
| `/` | Personal home page |
| `/notes/` | Searchable notebook directory |
| `/geopedia/` | Searchable encyclopedia |

The homepage uses text and links. It has no image dependency.

## Write a note

```sh
npm run new:note -- "Algebra/My first note"
```

This creates `content/notes/Algebra/My first note.typ` with a blank body:

```typst
#import "../../template.typ": *

#show: note

```

The filename supplies the title, and folders supply notebook names. Each note gets its own URL, for example `/notes/Algebra/My%20first%20note/`. Nested folders are supported. Notes with the same title can live in different folders because their full paths identify them.

Files and folders starting with `_` or `.` are unpublished drafts. New-file commands create published names and never overwrite existing files. Titles may contain Unicode symbols, spaces, and punctuation, but not path separators, NUL, or invalid Unicode. Empty path segments and `.` or `..` are not allowed.

## Write an encyclopedia entry

```sh
npm run new:object -- "Vector space"
```

This creates `content/geopedia/Vector space.typ`, using the same blank template as a note. There are no required sections, categories, numeric IDs, or metadata fields.

**The title is the unique identifier.** Titles must be unique across the entire encyclopedia, including different folders. Canonically equivalent Unicode titles count as duplicates. A file such as `Algebra/Vector space.typ` still has the title `Vector space` and the URL `/geopedia/Vector%20space/`.

Moving an entry between folders does not change its URL or references. Renaming the file changes its title; update references to match. Adjust template import paths when moving files between directory levels. See [Encyclopedia authoring](docs/geopedia.md).

## Links and references

```typst
#note-ref("Algebra/My first note")
#note-ref("./Another note", target: <result>)
#note-ref("../Overview")[Custom link text]

#geopedia("Vector space")
#geopedia("Vector space", target: <definition>)
#geopedia("Vector space")[Custom link text]
```

Note paths start at `content/notes/`; `./` and `../` are relative to the current note. From the encyclopedia, use a path from the notes root. Encyclopedia references always use the title alone, without a folder or file extension.

Use normal Typst labels and `@label` references within a document. Public labels are preserved even if only another document links to them. References and backlinks are generated automatically. A deleted or unpublished target becomes plain text; restoring it restores the link. An invalid path or a missing label in an existing target produces a diagnostic.

## Visual style

The website adapts the supplied SLATE templates into a blog layout. Body text and headings use Libertinus Serif, mathematics uses Libertinus Math, interface and statement labels use Noto Sans, and code uses Liberation Mono. The palette is ink `#29323b`, muted `#687785`, rules `#ccd5dd`, and wash `#f3f5f7`.

`src/style.css` defines a shared reading scale: 17px body text, 34px page titles, and 24/20/18px section headings, adjusted slightly for small screens. Section numbers sit inline with their headings; there is no separate chapter banner. Paragraphs are left-aligned, and sections flow continuously without large chapter breaks or divider rules. The homepage, directories, navigation, and mathematical environments use the same scale. All fonts are bundled locally. The standalone PDF preserves the supplied reference’s print layout.

## Writing tools

```typst
= A section <section>

#definition(title: [An example])[
  Write a definition here.
] <definition>

#theorem[Write a result here.] <result>
#proof[Explain why @result holds.]

#fold(title: "Show details")[Additional discussion.]

$ a^2 + b^2 = c^2 $
```

The template provides `definition`, `theorem`, `lemma`, `proposition`, `corollary`, `axiom`, `exercise`, `construction`, `claim`, `example`, `remark`, `question`, `proof`, `proofsketch`, `answer`, and `fold`. Labels, default captions, and interface text are in English. All statements use chapter-prefixed numbering. Theorem, lemma, proposition, and corollary share a counter; other types have separate counters (`axiom` shares the definition counter). Counters reset at numbered level-one headings. Remarks, examples, and constructions have no left rule. Proofs are unnumbered. Statements accept the reference template’s `title`, `italic`, `style`, `ruled`, and `to` options.

Equations use native MathML. Fractions use native Typst typesetting, matching the supplied template; escape a slash (`$A \/ B$`) when a literal slash is needed. Only labeled display equations receive a chapter-prefixed number; unlabeled equations do not consume a number. `underline` and `overline` work in mathematical expressions. Wide equations and tables scroll within the reading column. Reading pages include a table of contents, progress indicator, source download, and print button.

### Diagrams and images

Wrap Fletcher or CeTZ diagrams in `#web-diagram(...)` to export SVG. An optional `caption` and ordinary labels provide figure references. Use `#diagram-row[...]` for a row of diagrams. The `simplex2`, `simplex2hollow`, and `young` helpers already include SVG rendering:

```typst
#simplex2($x$, $y$, $z$, ab: $f$, bc: $g$, ac: $g compose f$)
#young(3, 2, labels: (1, 2, 3, 4, 5))
#assets-image("diagram.png", alt: "A diagram")
#sticker("xiaou0_idle", width: 120pt, alt: "A reading character")
```

Put images in `assets/` and stickers in `sticker/` or `stickers/`. Image paths support subfolders and optional extensions. Only referenced images are copied into the build. Supported formats include PNG, WebP, GIF, JPEG, SVG, and AVIF. Missing images produce a diagnostic.

### Function plots

```typst
#function-plot(x => x*x, x-range: (-3, 3), y-range: (-1, 9))
#function-plot((calc.sin, calc.cos), labels: ($sin x$, $cos x$))
#function-plot(x => 1/x, breaks: (0,))
#implicit-plot((x, y) => x*x + y*y - 4)
```

Both plot helpers accept a function or an array of functions. Common options include `x-range`, `y-range`, `width`, `height`, `labels`, `x-label`, `y-label`, `grid`, `equal`, `samples`, `colors`, `caption`, and `alt`. The default size is 264pt by 180pt, with equal axis scales. Explicit plots use 400 samples; implicit plots use an 80-by-80 grid.

Return `none` outside a function's domain. Explicit plots accept known discontinuities in `breaks`. Implicit plots must return a numeric residual, not a boolean; they use zero-contour interpolation and may miss repeated roots or details smaller than the grid. See [plot examples](content/function-plot-example.typ).

For a standalone PDF, use [the print template](content/print-template.md).

## Example files

The repository includes four small, removable example files:

- `content/notes/Examples/Test note.typ`: headings, a theorem, a proof, and folded content.
- `content/notes/Examples/Test links.typ`: note links, encyclopedia links, and an equation.
- `content/notes/Examples/Test style.typ`: the SLATE typography, statement kinds, shared counters, and labeled equations.
- `content/geopedia/Test entry.typ`: a free-form entry with a backlink to a note.

These are demonstration content. Newly created notes and entries still start blank.

## Build and deployment

The compiler caches HTML, MathML, and SVG in `.build/typst-cache/`. Development sessions also reuse Typst's incremental compiler. Changes to real dependencies, fonts, compiler options, or templates invalidate the relevant cache. Page styling and profile edits do not require recompiling unchanged content.

Fonts are served locally. The build prepares the bundled fonts for Typst in `.build/typst-fonts/`, so diagrams do not depend on system fonts. Typst's HTML exporter is experimental; page-specific PDF layout should use the print template or `html.frame` rather than relying on direct HTML export.

Run `npm run build` and deploy `dist/` to a static host that serves directory `index.html` files. Use `404.html` as the error page. Set `base` in `site.config.mjs` to `/repository-name/` for subdirectory hosting and set `url` to the public origin for canonical URLs. Public Typst content and helpers are copied to `dist/sources/`; draft files and hidden folders are excluded.

The existing `.github/workflows/pages.yml` builds with Node.js 22 and Typst 0.15.1 and deploys to GitHub Pages from the repository's default branch. Select **GitHub Actions** as the Pages build source. Local edits update the local preview; commit and push when you want to publish them.

## Verification

```sh
npm test
npm run test:browser
```

Browser tests use Chromium at `/usr/bin/chromium`, or `CHROMIUM_PATH` if set. They run in a temporary workspace on an independent port, with their own fixtures, and save reports to `test-results/`. Unicode fixtures deliberately exercise multilingual paths even though the site's supplied content and interface are English.
