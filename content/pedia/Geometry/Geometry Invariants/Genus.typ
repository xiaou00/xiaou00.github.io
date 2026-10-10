#import "../../../template.typ": *

#show: note

= Definitions

== Arithmetic Genus

#definition(title:[Arithmetic Genus])[
    Let $X/k$ be a #pedia("Properness")[proper], #pedia("Connectivity")[geometrically connected], #pedia("Smoothness")[smooth] and of pure #pedia[relative dimension] $n$ over $k$. The _arithmetic genus_ of $X$ is defined to be
    $ p_a (X) = (-1)^n (chi(X, cal(O)_X) - 1) $
    where $chi(X, O_X)$ is the #pedia[Euler characteristic] of the structure sheaf $O_X$.
]

#remark[
    Write $h^i (X, cal(F)) := dim_k H^i (X, cal(F))$. Under the above assumptions, $h^0(X, cal(O)_X) = 1$, so equivalently
    $ p_a (X) = sum_(i=1)^n (-1)^(n+i) h^i (X, cal(O)_X). $
    In particular, for a curve ($n=1$),
    $ p_a (X) = h^1 (X, cal(O)_X). $
]

== Geometric Genus

#definition(title:[Geometric Genus])[
    Let $X/k$ be a #pedia("Properness")[proper], #pedia("Connectivity")[geometrically connected], #pedia("Smoothness")[smooth] and of pure #pedia[relative dimension] $n$ over $k$. The _geometric genus_ of $X$ is defined to be
    $ p_g (X) = h^0 (X, omega_X) $
    where $omega_X$ is the sheaf of top differential forms on $X$.
]

#claim[
    The arithmetic genus and geometric genus are the same for a smooth projective curve $X/k$, we use the notation $g(X) = p_a (X) = p_g (X)$ and call it the _genus_ of $X$.
]
