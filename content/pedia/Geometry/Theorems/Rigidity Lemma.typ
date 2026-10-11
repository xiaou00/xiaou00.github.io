#import "../../../template.typ": *

#show: note

= Statement

#lemma(title: [Rigidity Lemma])[
    Let $X,Y$ be geometrically integral varieties over a field $k$, with $X$ proper, and let $Z$ be a separated $k$-variety. Fix $x_0 in X(k)$ and $y_0 in Y(k)$. If a morphism $f: X times_k Y -> Z$ is constant on $X times {y_0}$, then
    $ f(x,y) = f(x_0,y). $
    Thus $f$ factors through the projection to $Y$.
] <rigidity>

#proof[
    We may extend $k$ to an algebraic closure. Put $g(y) = f(x_0,y)$ and choose an affine neighbourhood $U subset Z$ of $f(x_0,y_0)$. Since the projection $p: X times_k Y -> Y$ is proper,
    $ V := Y ∖ p(f^(-1)(Z ∖ U)) $
    is an open neighbourhood of $y_0$, with $f(X times V) subset U$.

    For each $y in V(k)$, the map $f(-,y): X -> U$ is constant: $U$ is affine and $H^0(X, cal(O)_X) = k$. Hence $f = g compose p$ on $X times V$. This is dense in the integral variety $X times_k Y$, so separatedness of $Z$ extends the equality everywhere.
]

= Application to Abelian Varieties

#corollary[
    A $k$-morphism $f: A -> B$ between #pedia("Abelian Variety")[abelian varieties] satisfying $f(0) = 0$ is a group homomorphism.
] <homomorphisms>

#proof[
    Apply the lemma to
    $ h: A times_k A -> B, quad h(x,y) = f(x+y) - f(x) - f(y). $
    Since $h(x,0) = 0$, the lemma gives $h(x,y) = h(0,y) = 0$. Thus $f(x+y) = f(x) + f(y)$.
]
