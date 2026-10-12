#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

Let $Dcat$ be a #pedia("Six-Functor Formalism")[6FF] on $(cal(C),E)$. All identities below are natural equivalences with their higher coherences. The base-change, projection and Künneth formulas already hold for a 3FF.

= Base Change

Consider a Cartesian square with $f in E$:
#web-diagram(diagram(spacing: 32pt, {
    node((0, 0), [$X'$])
    node((1, 0), [$X$])
    node((0, 1), [$Y'$])
    node((1, 1), [$Y$])
    edge((0, 0), (1, 0), [$g'$], "->")
    edge((0, 0), (0, 1), [$f'$], "->")
    edge((1, 0), (1, 1), [$f$], label-side: left, "->")
    edge((0, 1), (1, 1), [$g$], label-side: right, "->")
}))

#theorem(title: [Beck-Chevalley])[
    There is a canonical equivalence
    $ g^* f_! simeq f'_! g'^*. $
] <base-change>

#proof[
    Both composites are the image of the correspondence $X <- X times_Y Y' -> Y'$.
]

In a 6FF, taking right adjoints also gives $f^! g_* simeq g'_* f'^!$.

= Projection Formula

#theorem(title: [Projection Formula])[
    For $f:X -> Y$ in $E$, $A in Dcat(X)$ and $B in Dcat(Y)$,
    $ f_! (A tens_X f^* B) simeq f_! A tens_Y B. $
    Equivalently, $f_!$ is $Dcat(Y)$-linear via pullback.
] <projection-formula>

#proof[
    Write the internal tensor as diagonal pullback of the external product. Apply base change to the pullback of $f times id_Y$ along $Delta_Y$, whose upper map is the graph $(id_X,f)$, and use compatibility of external products with pushforward.
]

= Künneth Formulas

#theorem(title: [Künneth])[
    For $f:X -> Y$ and $g:X' -> Y'$, external products satisfy
    $ (f times g)^*(M times.square N) simeq f^* M times.square g^* N, $
    with $M in Dcat(Y)$ and $N in Dcat(Y')$. If $f,g in E$, then also
    $ (f times g)_! (A times.square B) simeq f_! A times.square g_! B, $
    with $A in Dcat(X)$ and $B in Dcat(X')$.
] <kunneth>

#proof[
    These are the naturality equivalences of the lax symmetric monoidal structure on $Dcat$.
]

Versions with $f_*$ or $f^!$ require further hypotheses; taking adjoints alone does not give equivalences on external products.

= Internal Duality

#theorem(title: [Grothendieck-Verdier Duality])[
    For $f:X -> Y$ in $E$, $A in Dcat(X)$ and $B,C in Dcat(Y)$,
    $ f_* Hom_X (A,f^! B) simeq Hom_Y (f_! A,B), $
    $ f^! Hom_Y (C,B) simeq Hom_X (f^* C,f^! B). $
] <duality>

#proof[
    Map an arbitrary object into either side, use the tensor-Hom and $f_! tack.l f^!$ adjunctions, and apply the projection formula. The resulting mapping spaces agree naturally, so #pedia("Infinity Yoneda")[Yoneda] gives both equivalences.
]

== Verdier Dual <verdier-dual>

If $p_X:X -> *$ is admissible, define
$ omega_X := p_X^! bold(1)_*, quad bb(D)_X A := Hom_X (A,omega_X). $
For $f:X -> Y$ with $f,p_Y in E$, the formulas become
$ bb(D)_Y f_! simeq f_* bb(D)_X, quad bb(D)_X f^* simeq f^! bb(D)_Y. $
On subcategories where the biduality map $A -> bb(D)_X bb(D)_X A$ is an equivalence, $bb(D)_X$ is a duality.

The geometric identifications for proper and open maps are explained in #pedia("Nagata Six-Functor Formalism"); open-closed gluing is #pedia("Recollement").
