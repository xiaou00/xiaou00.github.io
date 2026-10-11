#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Torsion Point])[
    Let $(A,e)$ be an #pedia("Abelian Variety")[abelian variety] over a field $k$, and let $ell/k$ be a field extension. A point $P in A(ell)$ is a _torsion point_ if
    $ [n]P = e $
    for some integer $n >= 1$. The least such $n$ is the _order_ of $P$.

    For a fixed $n >= 1$, a point satisfying $[n]P = e$ is called an _$n$-torsion point_; its order divides $n$.
] <definition>

#remark[
    The _$n$-torsion subgroup scheme_ is
    $ A[n] := ker([n]: A -> A), $
    with $ell$-points $A[n](ell) = {P in A(ell) : [n]P = e}$. For an #pedia("Elliptic Curve")[elliptic curve] $E$, the same notation gives $E[n]$.
] <n-torsion>
