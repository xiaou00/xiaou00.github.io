#import "../../../template.typ": *

#show: note

= Definition

Let $X$ be an #pedia("Anima")[anima].

#definition(title: [Covering Space])[
    A _covering space_ of $X$ is a set-valued #pedia("Local System")[local system]. Write
    $ Cov(X) := Fun(X,Set). $
    By #pedia("Straightening-Unstraightening", <anima>)[unstraightening], it is equivalently a map $p:Y -> X$ whose homotopy fibers $Y_x$ are discrete sets, namely a $0$-truncated map. Morphisms are maps over $X$.
] <definition>

#definition(title: [Finite Covering Space])[
    A covering is _finite_ if every fiber is a finite set. Thus
    $ FCov(X) := Fun(X,Fin) subset Cov(X). $
    Over connected $X$, the cardinality $abs(Y_x)$ is independent of $x$ and is the _degree_ of the covering. Empty fibers are allowed.
] <finite>

#remark(title: [Topological Spaces])[
    Classically, a covering map is locally a projection $U times S -> U$, with $S$ discrete; it is finite when $S$ is finite. For a locally path-connected, semilocally simply connected topological space, this agrees with the definition on its homotopy type. In particular, it applies to CW complexes.
] <classical>

= Deck Transformations

#definition(title: [Deck Transformation Group])[
    The _deck transformation group_ is
    $ Deck(Y/X) := Aut_X (Y). $
    Its elements are automorphisms of the covering over $X$.
] <deck-transformations>

See #pedia("Covering Space Classification") for monodromy and #pedia("Galois Covering") for coverings with a transitive deck action.
