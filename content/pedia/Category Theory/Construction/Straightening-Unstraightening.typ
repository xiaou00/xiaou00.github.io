#import "../../../template.typ": *

#show: note

#let CoCart = $sans("CoCart")$
#let Cart = $sans("Cart")$
#let LFib = $sans("LFib")$
#let RFib = $sans("RFib")$

= Statement

Let $S$ be a small #pedia("Infinity Category")[$oo$-category], and write $Cat_oo$ for the $oo$-category of small $oo$-categories.

#theorem(title: [Straightening-Unstraightening])[
    There are equivalences
    $ Fun(S,Cat_oo) simeq CoCart(S), $
    $ Fun(S^opp,Cat_oo) simeq Cart(S). $
    Here $CoCart(S)$ and $Cart(S)$ consist of #pedia("Cocartesian Fibration")[cocartesian] and #pedia("Cartesian Fibration")[cartesian fibrations] over $S$ with small fibers. Their morphisms are functors over $S$ preserving the respective cocartesian or cartesian edges.

    _Unstraightening_ sends a functor $F$ to a fibration $p: cal(E) -> S$ with fiber $cal(E)_s simeq F(s)$. An arrow $s -> t$ induces transport $F(s) -> F(t)$ in the cocartesian case, and $F(t) -> F(s)$ in the cartesian case. _Straightening_ recovers this functor from the fibration.
] <statement>

#remark(title: [Anima-Valued Functors])[
    For #pedia("Anima")[anima-valued] functors, the equivalences restrict to
    $ Fun(S,Ani) simeq LFib(S), quad Fun(S^opp,Ani) simeq RFib(S). $
    Left and right fibrations are the cocartesian and cartesian fibrations whose fibers are $oo$-groupoids. Morphisms here are maps over $S$.
] <anima>
