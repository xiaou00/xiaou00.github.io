#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Infinity Category])[
    An _$oo$-category_ (or _quasicategory_) is a #pedia("Simplicial Set")[simplicial set] $cal(C)$ in which every _inner horn_ has a filler: every map
    $ Lambda_i^n -> cal(C), quad n >= 2, quad 0 < i < n, $
    extends to a map $Delta^n -> cal(C)$. Here $Lambda_i^n subset Delta^n$ is the union of all faces except the $i$th. Fillers need not be unique.
] <definition>

#remark[
    Vertices of $cal(C)$ are its objects, edges are its morphisms, and $2$-simplices encode composition. A _functor_ $cal(C) -> cal(D)$ is a map of simplicial sets. This is a model for $(oo,1)$-categories.
] <functors>

#remark[
    A #pedia("Kan Complex")[Kan complex] fills every horn, including the outer horns $i = 0,n$. It models an _$oo$-groupoid_: an $oo$-category in which every morphism is invertible up to homotopy.
] <groupoids>
