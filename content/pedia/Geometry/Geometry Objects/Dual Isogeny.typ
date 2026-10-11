#import "../../../template.typ": *

#show: note

= Pullback on Jacobians

Let $f: C -> D$ be a nonconstant morphism of smooth proper geometrically connected curves over a field $k$. Pullback of line bundles induces a homomorphism of #pedia("Jacobian Variety")[Jacobian varieties]
$ f^*: Jac(D) -> Jac(C), quad [cal(L)] |-> [f^* cal(L)]. $ <jacobian-pullback>

Indeed, $deg(f^* cal(L)) = (deg f) deg cal(L)$, so pullback preserves degree zero. It respects tensor products and commutes with base change, hence defines a morphism of #pedia("Picard Scheme")[Picard functors] and their identity components. The induced map goes in the opposite direction to $f$.

= Dual Isogeny of Elliptic Curves

Let $f: (E,e) -> (E',e')$ be an #pedia("Isogeny")[isogeny] of #pedia("Elliptic Curve")[elliptic curves] over $k$. The #pedia("Abel-Jacobi Embedding", <closed-immersion>)[Abel-Jacobi isomorphisms] identify each curve with its Jacobian:
$ alpha_E: E -> Jac(E), quad P |-> [cal(O)_E (P-e)], $
and similarly $alpha_(E'): E' -> Jac(E')$ using $e'$.

#definition(title: [Dual Isogeny])[
    The _dual isogeny_ of $f$ is the morphism obtained by transporting $f^*: Jac(E') -> Jac(E)$ through these identifications:
    $ hat(f) := alpha_E^(-1) compose f^* compose alpha_(E'): E' -> E. $
] <definition>

#proposition[
    Put $d = deg f$. Then $hat(f)$ is an isogeny of degree $d$, and
    $ hat(f) compose f = [d]_E, quad f compose hat(f) = [d]_(E'). $
    These identities characterize $hat(f)$ uniquely.
] <dual-identities>

#proofsketch[
    The norm map $f_*: Jac(E) -> Jac(E')$, induced by pushforward of divisors, corresponds to $f$ under the Abel-Jacobi identifications. Since $f_* compose f^* = [d]$, we get $f compose hat(f) = [d]_(E')$. Thus $hat(f)$ is nonconstant, hence an isogeny. Composing on the left with $hat(f)$ and cancelling the surjective map $hat(f)$ gives the other identity.

    By #pedia("Theorem of the Square", <multiplication-degree>)[the degree of multiplication], $d deg hat(f) = deg[d] = d^2$, so $deg hat(f) = d$. Uniqueness follows from $hat(f) compose f = [d]_E$ and the surjectivity of $f$.
]

= Duality Laws

#proposition(title: [Duality Laws])[
    Extend the dual isogeny operation to the zero homomorphism by $hat(0) = 0$. For homomorphisms $f,g: E -> E'$ and $h: E' -> E''$ of elliptic curves over $k$,
    $ hat(f+g) = hat(f) + hat(g), $
    $ hat(h compose f) = hat(f) compose hat(h), quad hat(hat(f)) = f. $
    For every integer $n$, multiplication is self-dual:
    $ hat([n]_E) = [n]_E. $
    Consequently,
    $ hat([n]_(E') compose f) = [n]_E compose hat(f) = hat(f) compose [n]_(E'). $
] <duality-laws>
