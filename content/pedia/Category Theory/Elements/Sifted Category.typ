#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Sifted Category])[
    A small #pedia("Infinity Category")[$oo$-category] $I$ is _sifted_ if $I$-indexed #pedia("Limit", <colimit>)[colimits] in #pedia("Anima")[$Ani$] commute with finite products. Thus, for every finite set $A$ and family $F_a: I -> Ani$, the comparison map
    $ colim_(i in I) product_(a in A) F_a (i) -> product_(a in A) colim_(i in I) F_a (i) $
    is an equivalence, including when $A$ is empty.

    We call $I$ _cosifted_ if $I^opp$ is sifted.
] <definition>

#remark(title: [Cofinality])[
    Equivalently, $I$ is nonempty and the diagonal $I -> I times I$ is _cofinal_. A functor $u: J -> I$ is cofinal if the canonical map
    $ colim_(j in J) F(u(j)) -> colim_(i in I) F(i) $
    is an equivalence for every diagram $F$ in any $oo$-category admitting these colimits.
] <cofinal>

#example[
    Every #pedia("Filtered Category")[filtered category] is sifted, as is #pedia("Simplex")[$Delta^opp$]. In particular, the _geometric realization_ of a simplicial object is a sifted colimit:
    $ abs(X_bullet) := colim_([n] in Delta^opp) X_n. $
] <geometric-realization>
