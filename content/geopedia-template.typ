#import "template.typ": *

// Content labels use pairs because Typst dictionary keys must be strings.
#let _pairs(values, parameter) = {
  if type(values) == dictionary { return values.pairs() }
  assert(type(values) == array, message: parameter + " 请填写 (([名称], [内容]), ...).")
  for pair in values {
    assert(type(pair) == array and pair.len() == 2,
      message: parameter + " 的每一项应为 ([名称], [内容]).")
    assert(type(pair.at(0)) in (type([]), str),
      message: parameter + " 的名称请使用 [内容].")
  }
  values
}

#let _value(value) = if type(value) == bool {
  if value { [是] } else { [否] }
} else if value == none {
  [未记录]
} else if type(value) in (int, float) {
  str(value)
} else {
  value
}

#let _entries(values) = html.elem("dl", attrs: (class: "object-facts"), {
  for (name, value) in values {
    html.elem("div", [
      #html.elem("dt", name)
      #html.elem("dd", _value(value))
    ])
  }
})

#let encyclopedia(
  name: [],
  definition: [],
  introduction: [],
  base: [],
  aliases: (),
  properties: (),
  invariants: (),
  invariant-notes: [],
  content: [],
) = {
  assert(name != [], message: "encyclopedia 必须填写 name.")
  assert(definition != [], message: "encyclopedia 必须填写 definition (定义或构造).")
  assert(type(aliases) == array and aliases.all(it => type(it) in (type([]), str)),
    message: "aliases 请填写内容列表, 例如 ([别名], [另一个别名]).")
  assert(type(properties) == array and properties.all(it => type(it) == type([])),
    message: "properties 请填写内容列表, 例如 ([光滑], [紧合]).")
  let invariants = _pairs(invariants, "invariants")
  note({
    set heading(numbering: none)
    html.elem("div", attrs: (
      hidden: "",
      "data-object-template": "",
    ), [
      #html.elem("div", attrs: ("data-object-name": ""), name)
      #html.elem("div", attrs: ("data-object-introduction": ""), introduction)
      #for alias in aliases {
        html.elem("div", attrs: ("data-object-alias": ""), alias)
      }
    ])
    if base != [] {
      html.elem("div", attrs: (class: "object-base"), [*基底与约定* #base])
    }
    [= 定义与构造 <construction>]
    definition
    [= 基本性质 <properties>]
    if properties.len() > 0 {
      html.elem("ul", attrs: (class: "object-properties", role: "list"), {
        for property in properties { html.elem("li", property) }
      })
    } else {
      html.elem("p", attrs: (class: "object-unrecorded"), [尚未记录性质.])
    }
    [= 不变量 <invariants>]
    if invariants.len() > 0 { _entries(invariants) }
    invariant-notes
    if invariants.len() == 0 and invariant-notes == [] {
      html.elem("p", attrs: (class: "object-unrecorded"), [尚未记录不变量.])
    }
    if content != [] {
      [= 讨论 <discussion>]
      content
    }
  })
}
