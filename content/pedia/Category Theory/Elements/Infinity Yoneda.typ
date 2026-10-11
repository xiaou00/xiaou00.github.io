#import "../../../template.typ": *

#show: note

= Statement

Let $cal(C)$ be a small #pedia("Infinity Category")[$oo$-category]. Write
$ PShv(cal(C)) := Fun(cal(C)^opp,Ani), quad j(c) := Map_(cal(C))(-,c), $
using #pedia("Anima")[anima-valued] presheaves.

#theorem(title: [Infinity Yoneda])[
    For $c in cal(C)$ and $F in PShv(cal(C))$, evaluation at the identity gives an equivalence
    $ Map_(PShv(cal(C)))(j(c),F) simeq F(c), quad eta |-> eta_c (id_c), $
    natural in $c$ and $F$.
] <yoneda>

#corollary(title: [Yoneda Embedding])[
    The Yoneda functor $j: cal(C) -> PShv(cal(C))$ is fully faithful:
    $ Map_(PShv(cal(C)))(j(c),j(d)) simeq Map_(cal(C))(c,d). $
] <embedding>

This is the mapping-space version of the #pedia("Yoneda Lemma")[Yoneda lemma].
