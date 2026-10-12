#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

= Mapping Spaces and Pullbacks

For an #pedia("Infinity Category")[$oo$-category] $cal(C)$, $Map_(cal(C))(a,b)$ is the #pedia("Anima")[anima] of arrows $a -> b$, their homotopies, and all higher homotopies.

A _homotopy pullback_ $A times_C B$ is the #pedia("Limit")[limit] in $Ani$ of $A -> C <- B$. Its points include a point of $A$, a point of $B$, and a path between their images in $C$. A square of spaces is _homotopy Cartesian_ if its upper left corner maps equivalently to the homotopy pullback of the other three corners. All squares below include their coherent commutativity data.

= Cartesian Edges

Let $p: cal(E) -> cal(B)$ be an #pedia("Inner Fibration")[inner fibration] of $oo$-categories, and let $u: x -> y$ lie over $alpha: s -> t$, with $s=p(x)$ and $t=p(y)$.

#definition(title: [Cartesian Edge])[
    The edge $u$ is _$p$-Cartesian_ if, for every $z in cal(E)$, the following square is a homotopy pullback:

    #web-diagram(diagram(spacing: 36pt, {
        node((0, 0), [$Map_(cal(E))(z,x)$])
        node((1, 0), [$Map_(cal(E))(z,y)$])
        node((0, 1), [$Map_(cal(B))(p(z),s)$])
        node((1, 1), [$Map_(cal(B))(p(z),t)$])
        edge((0, 0), (1, 0), [$u compose -$], "->")
        edge((0, 1), (1, 1), [$alpha compose -$], label-side: right, "->")
        edge((0, 0), (0, 1), [$p$], "->")
        edge((1, 0), (1, 1), [$p$], label-side: left, "->")
    }))

    This is the mapping-space characterization of #HTT[Proposition 2.4.4.3].
] <cartesian-edge>

#remark(title: [Universal Pullback])[
    Given $v: z -> y$ and $beta: p(z) -> s$, together with a homotopy $p(v) simeq alpha compose beta$, there is a factorization $v simeq u compose w$ with $w: z -> x$ over $beta$. The space of such factorizations, including the required homotopies, is contractible. Thus $x$ is the universal way to pull $y$ back along $alpha$.
] <meaning>

= Cartesian Fibrations

#definition(title: [Cartesian Fibration])[
    The inner fibration $p$ is a _Cartesian fibration_ if every arrow $alpha: s -> t$ and every object $y in cal(E)_t$ admit a $p$-Cartesian lift $x -> y$ over $alpha$.

    The target $y$ is prescribed; the source is denoted $alpha^* y$. These lifts give transport functors
    $ alpha^*: cal(E)_t -> cal(E)_s, $
    compatible with composition up to coherent homotopy.
] <definition>

This is contravariant transport: by #pedia("Straightening-Unstraightening"), a Cartesian fibration with small fibers corresponds to a functor $cal(B)^opp -> Cat_oo$. The dual notion is a #pedia("Cocartesian Fibration")[coCartesian fibration].

#example[
    For ordinary categories, consider the category of maps of sets and commutative squares, projected to the target set. The Cartesian lift of $alpha: S -> T$ at $Y -> T$ is the pullback square with source $S times_T Y -> S$.
]
