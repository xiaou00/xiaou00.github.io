# Encyclopedia authoring

Browse `/geopedia/` to search entries by title or body text. Each entry is an ordinary Typst document with a globally unique title.

## Create an entry

```sh
npm run new:object -- "Vector space"
```

The command creates `content/geopedia/Vector space.typ` without overwriting an existing file. The body is blank:

```typst
#import "../template.typ": *

#show: note

```

Write any explanation, definition, formula, or diagram below it. There are no required fields or fixed sections. The supplied `Test entry.typ` is a removable demonstration file, not content inserted into new entries.

## Titles and folders

The filename without `.typ` is the title and unique identifier. You may organize files in subfolders, but two published entries cannot share a title. Canonically equivalent Unicode names also count as duplicates. Notes and encyclopedia entries can share a title because they are separate collections.

For example, `Algebra/Vector space.typ` has the title `Vector space` and the URL `/geopedia/Vector%20space/`. Moving it does not change its URL. Update the relative template import when moving between directory levels. Renaming the file changes its title and requires updating references.

Titles cannot be blank, contain `/`, `\`, NUL, or invalid Unicode, or equal `.` or `..`. Files and folders starting with `_` or `.` are unpublished drafts.

## References

```typst
#geopedia("Vector space")
#geopedia("Vector space")[Custom text]
#geopedia("Vector space", target: <definition>)
```

Use only the title, without the folder or extension. If the title itself ends in `.typ`, include that as part of the title. The default link caption is the title. Create anchors using normal Typst labels:

```typst
= Definition <definition>

Write the definition here.
```

To reference a note from an entry, use a path from `content/notes/`:

```typst
#note-ref("Algebra/My first note")
```

References and backlinks appear automatically. Deleting or unpublishing a target temporarily turns its references into plain text. Restoring the target restores links. A missing label in an existing target is an error.

## Preview

`npm run dev` watches for changes. Duplicate titles and syntax errors preserve the last successful preview until fixed. `npm run build` generates the static site, including source downloads, and supports the configured deployment base path.
