#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

= Cocartesian Edges

Let $p: cal(E) -> cal(B)$ be an #pedia("Inner Fibration")[inner fibration] of #pedia("Infinity Category")[$oo$-categories]. Fix an edge $u: x -> y$ over $alpha: s -> t$. Mapping spaces and homotopy pullbacks are as in #pedia("Cartesian Fibration").

#definition(title: [Cocartesian Edge])[
    The edge $u$ is _$p$-coCartesian_ if, for every $z in cal(E)$, the following square is a homotopy pullback:

    #web-diagram(diagram(spacing: 36pt, {
        node((0, 0), [$Map_(cal(E))(y,z)$])
        node((1, 0), [$Map_(cal(E))(x,z)$])
        node((0, 1), [$Map_(cal(B))(t,p(z))$])
        node((1, 1), [$Map_(cal(B))(s,p(z))$])
        edge((0, 0), (1, 0), [$- compose u$], "->")
        edge((0, 1), (1, 1), [$- compose alpha$], "->")
        edge((0, 0), (0, 1), [$p$], "->")
        edge((1, 0), (1, 1), [$p$], "->")
    }))

    Equivalently, the opposite edge is $p^opp$-#pedia("Cartesian Fibration", <cartesian-edge>)[Cartesian].
] <cocartesian-edge>

#remark(title: [Universal Forward Transport])[
    Given $v: x -> z$ and $beta: t -> p(z)$ with a specified homotopy $p(v) simeq beta compose alpha$, the space of factorizations $v simeq w compose u$, with $w: y -> z$ over $beta$, is contractible. Thus $y$ universally transports $x$ forward along $alpha$.
] <meaning>

= Cocartesian Fibrations

#definition(title: [Cocartesian Fibration])[
    The inner fibration $p$ is a _coCartesian fibration_ if every arrow $alpha: s -> t$ and every object $x in cal(E)_s$ admit a $p$-coCartesian lift $x -> y$ over $alpha$.

    The source $x$ is prescribed; the target is denoted $alpha_! x$. These lifts give transport functors
    $ alpha_!: cal(E)_s -> cal(E)_t, $
    compatible with composition up to coherent homotopy.
] <definition>

Equivalently, $p^opp$ is a #pedia("Cartesian Fibration")[Cartesian fibration]; see #HTT[Definition 2.4.2.1]. By #pedia("Straightening-Unstraightening"), coCartesian fibrations with small fibers correspond to covariant functors $cal(B) -> Cat_oo$.

#remark[
    An individual coCartesian edge gives universal transport along one base arrow. Calling $p$ a coCartesian fibration requires such lifts for every base arrow and every source object. An #pedia("Infinity Operad")[$oo$-operad] only requires these lifts for inert base arrows.
] <existence>
