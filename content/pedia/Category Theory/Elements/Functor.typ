#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Functor])[
    A _functor_ $F: cal(C) -> cal(D)$ between #pedia("Category")[categories] assigns an object $F(X)$ to each object $X$ and a morphism $F(f): F(X) -> F(Y)$ to each morphism $f: X -> Y$, preserving identities and composition:
    $ F(id_X) = id_(F(X)), quad F(g compose f) = F(g) compose F(f). $
] <definition>

A _contravariant functor_ from $cal(C)$ to $cal(D)$ is a functor $cal(C)^opp -> cal(D)$, where $cal(C)^opp$ is the #pedia("Category", <opposite>)[opposite category]. It reverses arrows: $f: X -> Y$ gives $F(f): F(Y) -> F(X)$.

= Infinity Categories

#definition(title: [Functor of Infinity Categories])[
    For #pedia("Infinity Category")[$oo$-categories] $cal(C),cal(D)$, a _functor_ $F: cal(C) -> cal(D)$ is a map of #pedia("Simplicial Set")[simplicial sets]. Their _functor $oo$-category_ is the simplicial set
    $ Fun(cal(C),cal(D))_n := Hom_(sSet)(cal(C) times Delta^n,cal(D)). $
    This is again an $oo$-category.
] <infinity>

#remark[
    A _natural transformation_ $F -> G$ is an edge in $Fun(cal(C),cal(D))$, equivalently a map $cal(C) times Delta^1 -> cal(D)$ restricting to $F,G$ at the two endpoints. Higher simplices encode the higher coherence data.
] <natural-transformations>
