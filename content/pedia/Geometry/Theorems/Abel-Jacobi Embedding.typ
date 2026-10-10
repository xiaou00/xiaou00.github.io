#import "../../../template.typ": *

#show: note

= Definition

#definition(title:[Abel-Jacobi Embedding])[
    Suppose $C$ is a #pedia("Smoothness")[smooth], #pedia("Properness")[proper], #pedia("Connectivity")[geometrically connected] curve over a field $k$ of genus $g >= 1$, and $J = Jac(C)$ is the #pedia[Jacobian variety] of $C$. Fix a point $O in C(k)$, The _Abel-Jacobi embedding_ is the morphism
    $
    alpha_O : C &-> J\
    P &|-> [cal(O)_C (P-O)]
    $
]

Since the degree of divisor $P-O$ is 0, this morphism is well-defined. It's not hard to show that this is a morphism of $k$-schemes.

= State of The Result

#theorem(title:[Abel-Jacobi Embedding])[
    The Abel-Jacobi map $alpha_O$ is a closed immersion. When $g=1$, it is an isomorphism.
] <closed-immersion>

#remark[ 
    Both assertions can be checked after extending $k$ to an algebraic closure, so assume $k$ is algebraically closed.
]

#proof[
    A nonconstant rational function with only one simple pole would give a degree-one map $C -> PP^1$, hence $C simeq PP^1$, contradicting $g >= 1$. Thus $h^0 (C, cal(O)_C(P)) = 1$ for every $P$. Also, $alpha_O (P) = alpha_O (Q)$ means $P-Q$ is principal, which forces $P=Q$ by the same argument.

    Next, consider the differential at $P$,
    $ d alpha_(O,P) : T_P C -> T_(alpha_O(P)) J. $
    Under translation in $J$ and Serre duality, its dual is the evaluation map
    $ H^0(C, omega_C) -> omega_C|_P. $
    Riemann--Roch and $h^0(C, cal(O)_C(P)) = 1$ give $h^0(C, omega_C(-P)) = g-1$. Since $h^0(C, omega_C) = g$, evaluation is surjective, so $d alpha_(O,P)$ is injective.

    Since $C$ is proper and $alpha_O$ is injective on points and tangent spaces, $alpha_O$ is a closed immersion.

    If $g=1$, its image is a nonempty one-dimensional closed subscheme of the smooth connected curve $J$, hence has all of $J$ as its support. Since $J$ is reduced, this closed immersion is an isomorphism.
]
