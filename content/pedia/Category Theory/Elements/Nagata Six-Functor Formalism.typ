#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

= Nagata Setup

We use the case where all morphisms are admissible.

#definition(title: [Nagata Setup])[
    A _Nagata setup_ $(cal(C),I,P)$ consists of an $oo$-category with finite limits and two classes of morphisms such that:

    + $(cal(C),I)$ and $(cal(C),P)$ are #pedia("Correspondence Category", <setup>)[geometric setups].
    + Every arrow factors as $f = p compose j$, with $j in I$ and $p in P$.
    + Each arrow in $I$ or $P$ is $n$-truncated for some finite $n$.
    + For $W = I,P$ and $g in W$, one has $f in W$ if and only if $g compose f in W$.
] <setup>

Here $n$-truncated means that the fibers of $Map(T,X) -> Map(T,Y)$ are $n$-truncated anima for every $T$. For separated schemes of finite type over a field, take $I$ to be open immersions and $P$ proper morphisms; the factorization is a compactification.

= Adjoinable Squares <adjoinable>

For a commutative square of categories
#web-diagram(diagram(spacing: 32pt, {
    node((0, 0), [$cal(A)$])
    node((1, 0), [$cal(B)$])
    node((0, 1), [$cal(C)$])
    node((1, 1), [$cal(D)$])
    edge((0, 0), (1, 0), [$u$], "->")
    edge((0, 0), (0, 1), [$g$], "->")
    edge((1, 0), (1, 1), [$h$], label-side: left, "->")
    edge((0, 1), (1, 1), [$v$], label-side: right, "->")
}))
_Vertically left-adjoinable_ means that $g,h$ have left adjoints and the canonical mate
$ h^"L" v -> u g^"L" $
is an equivalence. This mate uses the unit and counit; the superscript $"L"$ here denotes a left adjoint, not a derived-functor prefix.

= Nagata Compatibility <compatibility>

Write $Corr(cal(C)) = Corr(cal(C),"All")$. A partial map $a:S ⇀ T$ is a map defined on a subset of $S$; the remaining inputs are omitted. In the monoidal total category, an arrow over $a$ is a family of spans
$ product_(s in a^(-1)(t)) X_s <- Z_t -> Y_t, quad t in T. $
For $W = I,P$, let $W_-$ and $W_-^opp$ denote componentwise arrows over identity partial maps represented by
$ X <-^(id) X ->^w Y, quad Y <-^w X ->^(id) X, quad w in W, $
respectively. Let $P_times^opp$ consist of the arrows represented by
$ product_(s in a^(-1)(t)) X_s <-^(p_t) Y_t ->^(id) Y_t, quad p_t in P. $
Empty products mean $*$.

#definition(title: [Nagata Formalism])[
    A #pedia("Three-Functor Formalism")[3FF] is _Nagata_ if its associated functor
    $ hat(Dcat):Corr(cal(C))^tens -> Cat_oo, quad (X_s)_(s in S) |-> product_(s in S) Dcat(X_s), $
    sends every commutative square of types
    $ (I_-^opp,I_-), quad (I_-^opp,P_times^opp), quad (P_-,P_times^opp), quad (P_-,I_-) $
    to vertically left-adjoinable squares. In a type $(A,B)$, vertical arrows lie in $A$ and horizontal arrows in $B$.

    A _Nagata 6FF_ is a #pedia("Six-Functor Formalism")[6FF] whose underlying 3FF is Nagata.
] <definition>

These conditions express compatibility of open extension and proper pushforward with the correspondence and tensor structures. See #link("https://arxiv.org/pdf/2309.11449v4#page=21")[Kuijper, Definition 3.2.3].

= Proper and Open Maps

#theorem[
    A Nagata 3FF has canonical adjunctions
    $ j_! tack.l j^*, quad p^* tack.l p_!, quad j in I, quad p in P. $
    In a Nagata 6FF, uniqueness of right adjoints therefore gives
    $ j^! simeq j^*, quad p_! simeq p_*. $
] <adjunctions>

The first assertion follows by induction on truncation degree using the diagonals and the adjoinable squares. For a factorization $f = p compose j$, it yields
$ f_! simeq p_* j_!, $
canonically compatibly with the chosen formalism. This is the compactification description of #pedia("Compactly Supported Cohomology")[proper-support pushforward].

Open-closed gluing is an additional condition, described by #pedia("Recollement").
