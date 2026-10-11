#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": * 

#show: note

= Definition

#definition(title: [Natural Transformation])[
    Let $F,G: cal(C) -> cal(D)$ be #pedia("Functor")[functors]. A _natural transformation_ $eta: F -> G$ assigns to each object $X$ a morphism $eta_X: F(X) -> G(X)$ such that, for every $f: X -> Y$,
    $ G(f) compose eta_X = eta_Y compose F(f). $
    It is a _natural isomorphism_ if every $eta_X$ is an isomorphism.
] <definition>

#remark[
    The previous can be expressed as a commutative diagram:
    #web-diagram(diagram(spacing: 24pt, {
        node((-1, 0), [$F(X)$])
        node((-1, 1), [$F(Y)$])
        node((0, 0), [$G(X)$])
        node((0, 1), [$G(Y)$])
        edge((-1, 0), (-1, 1), [$F(f)$], label-side: right, "->")
        edge((0, 0), (0, 1), [$G(f)$], label-side: left, "->")
        edge((-1, 0), (0, 0), [$eta_X$], label-side: left, "->")
        edge((-1, 1), (0, 1), [$eta_Y$], label-side: right, "->")
    }))
]

Write $Nat(F,G)$ for the natural transformations from $F$ to $G$. Functors $cal(C) -> cal(D)$ and natural transformations form the _functor category_ $Fun(cal(C),cal(D))$, with composition defined componentwise.
