# Encyclopedia authoring

Browse `/pedia/` to search entries by title or body text. Each entry is an ordinary Typst document with a globally unique title.

## Create an entry

```sh
npm run new:object -- "Vector space"
```

The command creates `content/pedia/Vector space.typ` without overwriting an existing file. The body is blank:

```typst
#import "../template.typ": *

#show: note

```

Write any explanation, definition, formula, or diagram below it. There are no required fields or fixed sections. The supplied `Test entry.typ` is a removable demonstration file, not content inserted into new entries.

## Titles and folders

The filename without `.typ` is the title and unique identifier. You may organize files in subfolders, but two published entries cannot share a title, ignoring case. Canonically equivalent Unicode names also count as duplicates. Notes and encyclopedia entries can share a title because they are separate collections.

For example, `Algebra/Vector space.typ` has the title `Vector space` and the URL `/pedia/Vector%20space/`. Moving it does not change its URL. Update the relative template import when moving between directory levels. Renaming the file changes its title and requires updating references.

Titles cannot be blank, contain `/`, `\`, NUL, or invalid Unicode, or equal `.` or `..`. Files and folders starting with `_` or `.` are unpublished drafts.

## References

```typst
#pedia[Vector space]
#pedia("Vector space", <definition>)
#pedia("Vector space")[Custom text]
#pedia("Vector space", <definition>)[See the definition]
#pedia("")[Reference to add later]
```

Use only the title, without the folder or extension. If the title itself ends in `.typ`, include that as part of the title. `#pedia[Title]` accepts plain text; use `#pedia("Title")` for titles containing Typst markup characters. The default link caption is the title, followed by the target's caption when a label is supplied. The original `target: <definition>` syntax remains supported. Create anchors using normal Typst labels:

```typst
= Definition <definition>

Write the definition here.

#proposition[Write a proposition here.] <main-result>
```

Use `#pedia("Vector space", <main-result>)` to link directly to that proposition. Definitions, theorems, lemmas, corollaries, headings, and equations can all be referenced by their labels.

Title lookup ignores case: `#pedia[vector space]` also finds `Vector space.typ` and displays `vector space`. Link text preserves the title spelling you supply, while the destination URL uses the actual file title. Labels such as `<main-result>` retain their exact spelling.

To reference a note from an entry, use its filename without the folder or `.typ` extension:

```typst
#note-ref[My first note]
#note-ref("My first note", <result>)[See the result]
```

Note names also ignore case and preserve the spelling you supply. If multiple notes share the same name, use an explicit path such as `#note-ref("Algebra/My first note")` to choose one.

References and backlinks appear automatically. Missing, deleted, or unpublished entries and missing labels render as plain text until the destination exists. A missing label displays as `Title / label`; custom captions, including mathematics, are preserved. Adding or restoring the destination automatically restores the link and backlinks.

Use `#pedia("")[Text to link later]` for text without a destination. `#pedia[]` renders no visible text, while `#pedia("Vector space")[]` uses the automatic caption. Invalid title paths still produce an error.

## Preview

`npm run dev` watches for changes. Duplicate titles and syntax errors preserve the last successful preview until fixed. `npm run build` generates the static site, including source downloads, and supports the configured deployment base path.
