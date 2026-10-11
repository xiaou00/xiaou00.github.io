#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Kan Complex])[
    A #pedia("Simplicial Set")[simplicial set] $X$ is a _Kan complex_ if every map $Lambda_i^n -> X$ extends to $Delta^n -> X$, for $n >= 1$ and $0 <= i <= n$.

    Here $Delta^n$ is the standard $n$-simplex, and the horn $Lambda_i^n subset Delta^n$ is the union of all its faces except the $i$th.
] <definition>
