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

= Elliptic Curves

#proposition[
    Let $E/k$ be an elliptic curve and $n >= 1$ invertible in $k$. Then $[n]$ is finite étale of degree $n^2$, and its kernel $E[n]$ is finite étale of rank $n^2$. Over a separable closure,
    $ E[n](k^sep) simeq (ZZ/n ZZ)^2, $
    noncanonically.
] <torsion-structure>

#proof[
    The map $[n]$ is finite locally free of #pedia("Theorem of the Square", <multiplication-degree>)[degree $n^2$]. Since #note-ref("Invariant Differentials on Elliptic Curves", <group-law>)[$[n]^* omega = n omega$], its differential is invertible everywhere, so it is étale.

    For $n = ell^r$, the finite abelian group $E[ell^r](k^sep)$ has order $ell^(2r)$, is killed by $ell^r$, and has $ell^2$ elements killed by $ell$. It therefore has two cyclic factors, necessarily both of order $ell^r$. The general case follows by the Chinese remainder theorem.
]

#remark[
    For a prime $ell != char(k)$ and $r >= 1$, the transition map
    $ [ell]: E[ell^(r+1)](k^sep) -> E[ell^r](k^sep) $
    is surjective with kernel $E[ell](k^sep)$: each fiber of $[ell]$ is nonempty finite étale and hence has a $k^sep$-point.
] <transition-maps>
