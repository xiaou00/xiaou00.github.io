// Web counterpart to 参考/template.typ. The writing interface stays familiar.
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

// Slash syntax follows the default style; explicit frac(...) stays stacked.
#let frac = math.frac.with(style: "vertical")

#let note(doc) = {
  // The build supplies the title from the filename.
  set document(title: sys.inputs.at("note-title", default: ""), author: "xiaou0")
  set text(lang: "zh")
  set smartquote(enabled: false)
  set math.frac(style: "horizontal")
  set heading(numbering: "1.1")
  // Keep explicit labels even when only another note references them.
  show heading: _labelled
  show figure: _labelled
  show math.underline: _math-line
  show math.overline: it => _math-line(it, over: true)
  [#metadata(none) <note>]
  // Validate the template from the HTML, without a second Typst evaluation.
  html.elem("span", attrs: ("data-note-template": "", hidden: ""), [])
  doc
}

// Resolve after all notes compile, so mutual references never import each other.
#let note-ref(file, target: none, ..rest) = {
  assert(rest.pos().len() <= 1 and rest.named().len() == 0,
    message: "自定义链接文字请放在 note-ref(...)[文字] 中.")
  let body = rest.pos().at(0, default: none)
  assert(type(file) == str, message: "note-ref 的文件名必须是字符串.")
  assert(target == none or type(target) in (str, label),
    message: "target 必须是标签或字符串.")
  html.elem("a", attrs: (
    "data-note": file,
    "data-note-target": if target == none { "" } else { str(target) },
    "data-note-auto": if body == none { "true" } else { "false" },
  ), if body == none { [] } else { body })
}

// GeoPedia references use the same deferred resolution as note references.
#let object-ref(id, target: none, ..rest) = {
  assert(type(id) == str, message: "object-ref 的编号必须是字符串.")
  assert(rest.pos().len() <= 1 and rest.named().len() == 0,
    message: "自定义链接文字请放在 object-ref(...)[文字] 中.")
  assert(target == none or type(target) in (str, label),
    message: "target 必须是标签或字符串.")
  let body = rest.pos().at(0, default: none)
  html.elem("a", attrs: (
    "data-object": id,
    "data-note-target": if target == none { "" } else { str(target) },
    "data-note-auto": if body == none { "true" } else { "false" },
  ), if body == none { [] } else { body })
}

#let geopedia = object-ref

// Each environment has a native figure counter and supports @references.
#let _env(kind, name, body, title: "", numbered: true) = figure(
  html.elem("div", attrs: (class: "env-body", "data-env": kind), body),
  kind: kind,
  supplement: name,
  numbering: if numbered { "1" } else { none },
  caption: if numbered {
    if title == "" { [] } else { html.elem("span", attrs: (class: "env-title"), [(#title)]) }
  } else {
    [#name#if title != "" { [ #html.elem("span", attrs: (class: "env-title"), [(#title)])] }]
  },
)

#let theorem(body, title: "") = _env("theorem", [定理], body, title: title)
#let lemma(body, title: "") = _env("lemma", [引理], body, title: title)
#let proposition(body, title: "") = _env("proposition", [命题], body, title: title)
#let corollary(body, title: "") = _env("corollary", [推论], body, title: title)
#let definition(body, title: "") = _env("definition", [定义], body, title: title)
#let axiom(body, title: "") = _env("axiom", [公理], body, title: title)
#let example(body, title: "") = _env("example", [例], body, title: title, numbered: false)
#let remark(body, title: "") = _env("remark", [注], body, title: title, numbered: false)
#let question(body, title: "") = _env("question", [问题], body, title: title, numbered: false)

#let _proof(name, body) = html.elem("div", attrs: (class: "proof"), [
  #html.elem("span", attrs: (class: "proof-label"), name)
  #body
  #html.elem("span", attrs: (class: "qed", "aria-label": "证毕"), [□])
])
#let proof(body) = _proof([证明], body)
#let proofsketch(body) = _proof([证明思路], body)
#let answer(body) = _proof([解答], body)

// Native disclosure: closed initially, with keyboard and no-JavaScript support.
#let fold(body, title: "展开查看") = html.elem("details", attrs: (class: "note-fold"), [
  #html.elem("summary", title)
  #html.elem("div", attrs: (class: "note-fold-body"), body)
])

// Keep a distinct name so importing Fletcher's diagram never shadows this.
// Only the drawing becomes SVG; surrounding equations remain native MathML.
#let web-diagram(body, caption: none) = figure(
  html.elem("div", attrs: (
    class: "diagram-scroll",
    role: "region",
    "aria-label": "图形, 可横向滚动",
    tabindex: "0",
  ), html.frame({
    // SVG glyphs are fixed at compile time, so CSS cannot supply their fonts.
    set text(font: "Source Han Serif")
    show math.equation: set text(font: ("Libertinus Math", "Source Han Serif"))
    body
  })),
  kind: "diagram",
  supplement: [图],
  caption: caption,
)

#import "abbrev.typ" : *
