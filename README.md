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

Development restarts reuse the compilation cache in `.build/typst-cache/`. Cached notes do not start a Typst process; at most four recently compiled notes keep a process for incremental edits. Source and imported-file contents are checked before reusing cached output. Changing shared templates recompiles affected notes, and the first build without a valid cache still compiles every document.

During a preview session, unchanged documents reuse their parsed content and reference data. Unchanged output files are reused in the next complete build, so saving one note avoids rewriting the rest of the site. References, backlinks, adjacent-page links, and the search directory still update when their inputs change. Failed builds keep the last successful preview.

## Personal home page

Edit `site.config.mjs`. The `profile` object contains the name, role, About paragraphs, interests, and external links. The bracketed text is placeholder content to replace with your own details. Empty optional lists are omitted from the page.

The site has three independent routes:

| Route | Content |
| --- | --- |
| `/` | Personal home page |
| `/notes/` | Searchable notebook directory |
| `/pedia/` | Searchable encyclopedia |

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

The filename supplies the title, and folders supply notebook names. Each note gets its own URL, for example `/notes/Algebra/My%20first%20note/`. Nested folders are supported. References can find a note by its title across all folders. If multiple notes share a title (ignoring case), use an explicit path to disambiguate.

Files and folders starting with `_` or `.` are unpublished drafts. New-file commands create published names and never overwrite existing files. Titles may contain Unicode symbols, spaces, and punctuation, but not path separators, NUL, or invalid Unicode. Empty path segments and `.` or `..` are not allowed.

## Write an encyclopedia entry

```sh
npm run new:object -- "Vector space"
```

This creates `content/pedia/Vector space.typ`, using the same blank template as a note. There are no required sections, categories, numeric IDs, or metadata fields.

**The title is the unique identifier.** Titles must be unique across the entire encyclopedia, including different folders, ignoring case. Canonically equivalent Unicode titles count as duplicates. A file such as `Algebra/Vector space.typ` still has the title `Vector space` and the URL `/pedia/Vector%20space/`.

Moving an entry between folders does not change its URL or references. Renaming the file changes its title; update references to match. Adjust template import paths when moving files between directory levels. See [Encyclopedia authoring](docs/pedia.md).

## Links and references

```typst
#note-ref[My first note]
#note-ref("Another note", <result>)
#note-ref("Overview")[Custom link text]
#note-ref("Another note", <result>)[See the result]

#pedia[Vector space]
#pedia("Vector space", <definition>)
#pedia("Vector space")[Custom link text]
#pedia("Vector space", <definition>)[See the definition]
#pedia("")[Reference to add later]
```

Use a note's filename without its folder or `.typ` extension, from either collection. Moving a note between folders updates the destination URL automatically without changing name references. Renaming it requires updating references. Existing note paths such as `#note-ref("Algebra/My first note")` still work: paths start at `content/notes/`, and `./` and `../` are relative to the current note. From the encyclopedia, explicit paths start at the notes root. Encyclopedia references always use the title alone.

Title lookup ignores case and normalizes equivalent Unicode in both collections: `#note-ref[my first note]` finds `My first note.typ`, and `#pedia[vector space]` finds `Vector space.typ`. Link text preserves the title spelling you supply, while the destination URL uses the actual filename. Target labels keep their exact spelling. A note and an encyclopedia entry may share the same title; the reference function chooses the collection.

Use normal Typst labels and `@label` references within a document. Public labels are preserved even if only another document links to them. References and backlinks are generated automatically. A deleted or unpublished target becomes plain text; restoring it restores the link. Both helpers accept empty destinations such as `#note-ref("")[Reference to add later]` and use automatic text for empty captions. Both support `target: <label>` as well as a positional label. Pedia also permits missing labels as placeholders: they display as `Title / label`, or keep your custom text; adding the label restores the link automatically. Invalid paths and missing labels in `note-ref` still produce a diagnostic.

Literature shortcuts are available in notes, encyclopedia entries, and the PDF template:

```typst
#Stack("0385")                 // [Stacks, Tag 0385]
#HA[Corollary 1.1.3.4]          // [HA, Corollary 1.1.3.4]
#HTT[]                         // [HTT]
#HTT[Theorem 6.1.0.6]           // [HTT, Theorem 6.1.0.6]
#Kerodon("0003")               // [Kerodon, Tag 0003]
```

`Stack` and `Kerodon` link directly to the official tag page. Supply the four-character tag from that page's URL, not its dotted section or theorem number. `HA` (Higher Algebra) and `HTT` (Higher Topos Theory) link to the official PDFs; their bracketed content is a display locator, not a jump to a particular PDF page. Use `#HA[]` or `#HTT[]` to cite the whole book. The shared helpers are defined in `content/refs.typ`.

## Visual style

The **Graph** page at `/graph/` shows all published notes and encyclopedia entries, including pages with no connections. Links created with `note-ref` and `pedia` become lines; repeated or reciprocal references share one line. Missing targets, drafts, and external references are omitted.

Drag nodes to rearrange them, drag the background to pan, and scroll or pinch to zoom. Click a node to open its page, search to locate a title, or use **Fit view** to see everything. The graph rebuilds with the site and refreshes automatically during `npm run dev`. Its script runs only on the graph page and needs no external service. The page list remains usable without JavaScript.

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

Equations use native MathML. In inline and display math, `/` stays on the baseline: `$Sch/S$` renders as a quotient with a slash, and `$(a + b)/c$` keeps its parentheses. Use `$frac(a, b)$` for a stacked fraction. Ordinary delimiters stay at text size: `$(frac(a, b))$`. Use `$lr((frac(a, b)))$` to scale the surrounding parentheses with their contents; this also works for square brackets, braces, and vertical bars. The print template uses the same conventions. Only labeled display equations receive a chapter-prefixed number; unlabeled equations do not consume a number. `underline` and `overline` work in mathematical expressions. Wide equations and tables scroll within the reading column. Reading pages include a table of contents, progress indicator, source download, and print button.

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
- `content/pedia/Test entry.typ`: a free-form entry with a backlink to a note.

These are demonstration content. Newly created notes and entries still start blank.

## Build and deployment

The compiler caches HTML, MathML, and SVG in `.build/typst-cache/`. Development sessions also reuse Typst's incremental compiler. Changes to real dependencies, fonts, compiler options, or templates invalidate the relevant cache. Page styling and profile edits do not require recompiling unchanged content.

Fonts are served locally. The build prepares the bundled fonts for Typst in `.build/typst-fonts/`, so diagrams do not depend on system fonts. Typst's HTML exporter is experimental; page-specific PDF layout should use the print template or `html.frame` rather than relying on direct HTML export.

Run `npm run build` and deploy `dist/` to a static host that serves directory `index.html` files. Use `404.html` as the error page. Set `base` in `site.config.mjs` to `/repository-name/` for subdirectory hosting and set `url` to the public origin for canonical URLs. Public Typst content and helpers are copied to `dist/sources/`; draft files and hidden folders are excluded.

The `.github/workflows/pages.yml` workflow builds with Node.js 22 and Typst 0.15.1, then deploys `dist/` to GitHub Pages on pushes to `master`. It can also be started from the Actions tab with **Run workflow**.

For the `xiaou00/xiaou00.github.io` repository:

1. Open **Settings → Pages → Build and deployment**, and set **Source** to **GitHub Actions**.
2. Commit the project, including `.github/workflows/pages.yml`, and push to `master`.
3. Wait for **Actions → Deploy GitHub Pages** to succeed, then visit <https://xiaou00.github.io/>.

The current `url: 'https://xiaou00.github.io'` and `base: '/'` settings already match this repository. Future pushes to `master` update the site automatically. If you rename the publishing branch, update the workflow's `branches` setting as well. Build output and dependencies stay ignored; only source files need to be pushed.

## Verification

```sh
npm test
npm run test:browser
```

Browser tests use Chromium at `/usr/bin/chromium`, or `CHROMIUM_PATH` if set. They run in a temporary workspace on an independent port, with their own fixtures, and save reports to `test-results/`. Unicode fixtures deliberately exercise multilingual paths even though the site's supplied content and interface are English.
