#import "../../template.typ": *

#show: note

Let $(E,e)$ be an #pedia("Elliptic Curve")[elliptic curve] over a field $k$. An #pedia("Invariant Differential")[invariant differential] is a regular $1$-form $omega$ satisfying $tau_P^* omega = omega$ for every translation $tau_P(Q) = Q+P$, after any base change.

= Regular Forms Are Invariant

#proposition[
    Every global regular $1$-form on $E$ is invariant, and
    $ h^0(E, Omega^1_(E/k)) = 1. $
    A nonzero such form $omega$ has no zeros and trivializes the cotangent bundle:
    $ Omega^1_(E/k) = cal(O)_E omega. $
] <regular-forms>

#proof[
    The cotangent space at $e$ is one-dimensional. By the #pedia("Invariant Differential", <differentials>)[invariant differential lemma], any nonzero value there extends uniquely by translation to an invariant form $omega$. Translations are isomorphisms, so $omega$ vanishes nowhere. Thus $Omega^1_(E/k) = cal(O)_E omega$; since $H^0(E, cal(O)_E) = k$, every global regular form is a scalar multiple of $omega$.
]

= Weierstrass Coordinates

For a smooth #pedia("Weierstrass Equations")[Weierstrass model]
$ y^2 + a_1 x y + a_3 y = x^3 + a_2 x^2 + a_4 x + a_6, $
a nonzero invariant differential is
$ omega = frac(dif x, 2y + a_1 x + a_3) = frac(dif y, 3x^2 + 2a_2 x + a_4 - a_1 y). $ <weierstrass-differential>
Each expression is used where its denominator is nonzero; together they extend to all of $E$.

#proofsketch[
    Differentiating the equation gives the equality in @weierstrass-differential. Smoothness ensures that the two denominators never vanish simultaneously on the affine chart, so they define a regular, nonvanishing form there. At $e$, using the local parameter $t = -x/y$ gives
    $ omega = (1 + O(t)) dif t. $
    Hence the form is also regular and nonzero at $e$, and @regular-forms makes it invariant.
]

For the short form $y^2 = x^3 + A x + B$ in characteristic different from $2$ and $3$, this reduces to $omega = frac(dif x, 2y)$.

= The Group Law

#proposition[
    Let $m: E times_k E -> E$ be addition and $pr_1, pr_2$ the projections. Then
    $ m^* omega = pr_1^* omega + pr_2^* omega. $
    Consequently, for every integer $n$,
    $ [n]^* omega = n omega, $
    where $[n](P) = n P$ and $n$ on the right is viewed in $k$. In particular, $[-1]^* omega = -omega$.
] <group-law>

#proof[
    In each tangent direction, the differential of addition is the differential of a translation. Invariance therefore gives the first identity. Also, $d[n]_e = n id$ on $T_e E$; since invariant forms are determined at $e$, this gives the second identity.
]

= Pullback by an Isogeny

#proposition[
    Let $phi: E -> E'$ be an #pedia("Isogeny")[isogeny], and choose nonzero invariant forms $omega$ on $E$ and $omega'$ on $E'$. There is a unique $c_phi in k$ such that
    $ phi^* omega' = c_phi omega. $
    Moreover, $phi$ is separable if and only if $c_phi != 0$.
] <separability>

#proof[
    The pullback is regular, so @regular-forms gives the scalar $c_phi$. For a nonconstant map of smooth curves, the map on differentials at the generic point is nonzero exactly when the induced extension of function fields is separable. Here this is precisely the condition $c_phi != 0$.
]

#example[
    If $char k = p > 0$ and $n != 0$, then $[n]$ is separable exactly when $p$ does not divide $n$. In particular, $[p]^* omega = 0$ even though $[p]$ is nonconstant.
]
