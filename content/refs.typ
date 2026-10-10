// Shared literature references for HTML and PDF output.
#let _reference(name, url, body) = link(url, [\[#name#if body != [] { [, #body] }\]])

#let _tag-reference(name, base, tag) = {
  assert(type(tag) == str, message: name + " expects a four-character tag string.")
  let tag = upper(tag.trim())
  assert(tag.match(regex("^[0-9A-Z]{4}$")) != none,
    message: name + " expects a four-character tag, such as \"0003\", not a section number.")
  _reference(name, base + tag, [Tag #tag])
}

#let Stack(tag) = _tag-reference("Stacks", "https://stacks.math.columbia.edu/tag/", tag)
#let Kerodon(tag) = _tag-reference("Kerodon", "https://kerodon.net/tag/", tag)
#let HA(body) = _reference("HA", "https://www.math.ias.edu/~lurie/papers/HA.pdf", body)
#let HTT(body) = _reference("HTT", "https://www.math.ias.edu/~lurie/papers/HTT.pdf", body)
