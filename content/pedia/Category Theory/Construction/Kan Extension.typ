#import "../../../template.typ": *

#show: note

= Definition

Let $u: cal(C) -> cal(D)$ be a #pedia("Functor", <infinity>)[functor] between small #pedia("Infinity Category")[$oo$-categories], and let $cal(E)$ be an $oo$-category. Precomposition gives
$ u^*: Fun(cal(D),cal(E)) -> Fun(cal(C),cal(E)), quad G |-> G compose u. $

#definition(title: [Kan Extension])[
    The _left_ and _right Kan extension_ functors, when they exist, are the #pedia("Adjunction", <infinity>)[adjoints] of precomposition:
    $ Lan_u ⊣ u^* ⊣ Ran_u. $
    For $F: cal(C) -> cal(E)$, they come with natural transformations
    $ F -> u^* (Lan_u F), quad u^* (Ran_u F) -> F. $
] <definition>

#proposition(title: [Pointwise Formulas])[
    When the indicated #pedia("Limit")[colimits or limits] exist for every $d in cal(D)$, the corresponding extension is given by
    $ (Lan_u F)(d) simeq colim_((c,u(c) -> d)) F(c), $
    $ (Ran_u F)(d) simeq lim_((c,d -> u(c))) F(c). $
    The indices are the comma $oo$-categories of the indicated arrows, with their commutative triangles and higher homotopies.
] <pointwise>

#example[
    For the unique functor $u: cal(C) -> *$, these recover $Lan_u F = colim_(cal(C)) F$ and $Ran_u F = lim_(cal(C)) F$.
]
