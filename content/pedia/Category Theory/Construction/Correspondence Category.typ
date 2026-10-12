#import "../../../template.typ": *

#show: note

= Geometric Setup

#definition(title: [Geometric Setup])[
    A _geometric setup_ is an #pedia("Infinity Category")[$oo$-category] $cal(C)$ with a class $E$ of morphisms, invariant under equivalence, containing all equivalences, and closed under composition. Pullbacks of arrows in $E$ along arbitrary arrows must exist and belong to $E$.

    Arrows in $E$ are called _admissible_.
] <setup>

For example, take schemes with proper morphisms, or with separated morphisms of finite type.

= Correspondences

#definition(title: [Correspondence Category])[
    The _correspondence $oo$-category_ $Corr(cal(C),E)$ has the objects of $cal(C)$. A morphism $X -> Y$ is a span
    $ X <-^p Z ->^q Y, quad q in E. $
    Equivalences of spans identify their middle objects compatibly with both legs. Composition is by pullback:
    $ (X <- Z -> Y), quad (Y <- W -> T)
        quad |-> quad (X <- Z times_Y W -> T). $
    The identity is $X <-^(id) X ->^(id) X$.
] <definition>

The following simplicial model includes all higher coherences.

= Simplicial Model <simplicial-model>

Let $P_n$ be the poset of pairs $(i,j)$ with $0 <= j <= i <= n$, ordered by
$ (i,j) <= (i',j') quad <==> quad i' <= i " and " j <= j'. $
Put $Q_n := Ner(P_n)$, using the #pedia("Nerve")[nerve]. An $n$-simplex of $Corr(cal(C),E)$ is a map $F:Q_n -> cal(C)$ satisfying:

+ $F(i,j) -> F(i,j')$ belongs to $E$ whenever $j <= j' <= i$.
+ For $j <= j' <= i' <= i$, the canonical map is an equivalence:
  $ F(i,j) ->^simeq F(i',j) times_(F(i',j')) F(i,j'). $

Faces and degeneracies restrict along $(i,j) |-> (alpha(i),alpha(j))$ for $alpha:[m] -> [n]$.

#theorem[
    This simplicial set is a quasicategory. If $cal(C)$ has finite products, it has a canonical #pedia("Monoidal Category", <symmetric>)[symmetric monoidal structure]
    $ Corr(cal(C),E)^tens, quad X tens Y := X times Y, quad bold(1) := *. $
    Spans are tensored by taking products of their three objects and two legs.
] <symmetric-monoidal>

Pullback pasting supplies coherent composition. Products preserve these pullbacks, and products of admissible arrows remain admissible. See #link("https://arxiv.org/html/2412.20548v2#S4.SS1")[Chowdhury, §4.1].

Functors out of this category define #pedia("Three-Functor Formalism")[three-functor formalisms].
