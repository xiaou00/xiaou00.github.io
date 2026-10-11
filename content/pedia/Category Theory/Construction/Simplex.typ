#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Simplex])[
    The _simplex category_ $Delta$ is the #pedia("Category")[category] whose objects are the finite nonempty ordered sets
    $ [n] := {0 < 1 < dots < n}, quad n >= 0. $
    A morphism $alpha: [m] -> [n]$ is a nondecreasing map: $i <= j$ implies $alpha(i) <= alpha(j)$. Composition and identities are those of functions.
] <definition>

#remark(title: [Cofaces and Codegeneracies])[
    The standard maps are:
    - _Cofaces_ $delta^i: [n-1] -> [n]$: the injections skipping $i$, for $n >= 1$ and $0 <= i <= n$.
    - _Codegeneracies_ $sigma^i: [n+1] -> [n]$: the surjections identifying $i$ and $i+1$, for $n >= 0$ and $0 <= i <= n$.

    Every morphism in $Delta$ is a composite of these maps and identities.
] <generators>
