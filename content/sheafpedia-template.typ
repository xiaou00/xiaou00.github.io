#import "template.typ": *

#let _schema = json("sheafpedia-schema.json")

#let _entries(values) = html.elem("dl", attrs: (class: "object-facts"), {
  for (name, value) in values {
    html.elem("div", [
      #html.elem("dt", name)
      #html.elem("dd", value)
    ])
  }
})

// Boolean and numeric options are registered in sheafpedia-schema.json.
// Omitted / none means unrecorded, never false or zero.
#let encyclopedia(
  name: [],
  definition: [],
  introduction: [],
  base: [],
  properties: [],
  aliases: (),
  extra-properties: (:),
  numerical-invariants: (:),
  invariants: (:),
  invariant-notes: [],
  ..options
) = {
  assert(name != [], message: "encyclopedia 必须填写 name.")
  assert(definition != [], message: "encyclopedia 必须填写 definition (定义或构造).")
  assert(type(aliases) == array and aliases.all(it => type(it) == str),
    message: "aliases 必须是字符串数组.")
  for (key, value) in (("extra-properties", extra-properties),
    ("numerical-invariants", numerical-invariants), ("invariants", invariants)) {
    assert(type(value) == dictionary, message: key + " 必须是字典.")
  }
  assert(options.pos().len() == 0, message: "encyclopedia 请使用命名参数.")
  let named = options.named()
  let known = _schema.properties.keys() + _schema.numbers.keys()
  for key in named.keys() {
    assert(key in known, message: "未知的 encyclopedia 参数: " + key)
  }
  let flags = (:)
  let numbers = (:)
  for (key, label) in _schema.properties {
    flags.insert(label, named.at(key, default: none))
  }
  for (key, value) in extra-properties {
    assert(key.trim() != "" and key not in flags, message: "自定义性质名称为空或重复: " + key)
    flags.insert(key, value)
  }
  for (key, value) in flags {
    assert(value == none or type(value) == bool,
      message: key + " 只接受 true, false 或 none.")
  }
  for (key, label) in _schema.numbers {
    numbers.insert(label, named.at(key, default: none))
  }
  for (key, value) in numerical-invariants {
    assert(key.trim() != "" and key not in numbers, message: "数值不变量名称为空或重复: " + key)
    numbers.insert(key, value)
  }
  for (key, value) in numbers {
    assert(value == none or type(value) in (int, float),
      message: key + " 只接受数值或 none. 含公式的值请放入 invariants 字典.")
    if value != none {
      assert(value == value and value != float.inf and value != -float.inf,
        message: key + " 必须是有限数值.")
    }
  }
  note({
    set heading(numbering: none)
    html.elem("div", attrs: (
      hidden: "",
      "data-object-template": json.encode((aliases: aliases, properties: flags, numbers: numbers), pretty: false),
    ), [
      #html.elem("div", attrs: ("data-object-name": ""), name)
      #html.elem("div", attrs: ("data-object-introduction": ""), introduction)
    ])
    if base != [] {
      html.elem("div", attrs: (class: "object-base"), [*基底与约定* #base])
    }
    [= 定义与构造 <construction>]
    definition
    [= 基本性质 <properties>]
    let recorded = flags.pairs().filter(pair => pair.at(1) != none)
    if recorded.len() > 0 {
      _entries(recorded.map(((key, value)) => (key,
        html.elem("span", attrs: (class: if value { "fact-yes" } else { "fact-no" }),
          if value { [是] } else { [否] }))))
    }
    html.elem("p", attrs: (class: "object-unrecorded"), [未列出的性质尚未记录.])
    properties
    [= 不变量 <invariants>]
    let numeric = numbers.pairs().filter(pair => pair.at(1) != none)
    if numeric.len() > 0 { _entries(numeric.map(((key, value)) => (key, str(value)))) }
    if invariants.len() > 0 { _entries(invariants.pairs()) }
    invariant-notes
    if numeric.len() == 0 and invariants.len() == 0 and invariant-notes == [] {
      html.elem("p", attrs: (class: "object-unrecorded"), [尚未记录不变量.])
    }
  })
}
