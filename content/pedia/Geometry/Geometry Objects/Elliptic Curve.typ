#import "../../../template.typ": *

#show: note

= Definition

== Absolute Definition

#definition(title:[Elliptic Curve])[
    Fix a base scheme $S in Sch$, define the _category of elliptic curves over $S$_
    $ Ell/S = {E in Grp(Sch/S) : vec(
        delim: #none,
        E/S "smooth & proper",
        E/S "geometrically connected",
        dim(E/S) = 1
    )} $
    be the full subcategory of the category of group schemes over $S$ consisting of those group schemes $E/S$ which are #pedia("Smoothness")[smooth], #pedia("Properness")[proper], #pedia("Connectivity")[geometrically connected], and of pure #pedia[relative dimension] 1. An _elliptic curve over $S$_ is an object of $Ell/S$.
]

#definition(title:[The Moduli Elliptic Curve Functor])[
    The _moduli elliptic curve functor_ is the functor
    $ cal(M)_(1,1)(S) := (Ell/S)^simeq $
]

== Characterization over $k$

#definition(title:[Elliptic Curve])[
    Suppose $k$ is a field. An _elliptic curve over $k$_ is a tuple $(E,e)$, where

    + $E$ is a smooth, proper, geometrically connected curve over $k$.
    + $E$ has genus 1.
    + $e:Spec k -> E$ is a $k$-point of $E$.
]

#remark[
    Here, since $E$ is smooth and proper with $k$-point, it is automatically projective over $k$. So we can replace the condition "proper" with "projective" in the definition above.
]

#lemma(title:[#Stack("047I")])[
    Let $(G,e)$ be a group scheme over $S$, $f$ be the structure morphism $f:G->S$, then
    $ Omega^1_(G/S) simeq f^* e^* Omega_(G/S) $
    specially, if $S=Spec k$, we have
    $ Omega^1_(G/S) simeq cal(O)_G times.o_k e^* Omega^1_(G/k) $
] <lemma-1>

#theorem(title:[Equivalence of Definitions])[
    A $k$-elliptic curve $(E,e)$ is equivalent to an object in $Ell/Spec k$.
]

#proof[
    Suppose we have a $E in Ell/k$, we only have to show that $E$ has genus 1, the $k$-point automatically given by the identity section $e: Spec k -> E$. By @lemma-1, we have
    $ Omega^1_(E/k) simeq cal(O)_E times.o_k e^* Omega^1_(E/k) $
    since $dim E=1$, $e^* Omega^1_(E/k)$ is a rank 1 locally free sheaf over $Spec k$, which 1-dimensional $k$-vector space, so $e^* Omega^1_(E/k) simeq k$, hence
    $ omega_E simeq Omega^1_(E/k) simeq cal(O)_E $
    we can calculate the genus of $E$ by the formula
    $ g(E) = h^0(E, omega_E) = h^0(E, cal(O)_E) = 1 $

    The reverse direction is shown by the #pedia[Abel-Jacobi Embedding]
]

#corollary[
    $E = Jac(E)$ holds for any elliptic curve $E$ over $k$. 
]

#corollary[
    An elliptic curve is an #pedia[Abelian variety] of dimension 1. The converse is also true.
]
