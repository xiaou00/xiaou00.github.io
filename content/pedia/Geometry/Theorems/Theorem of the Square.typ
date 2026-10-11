#import "../../../template.typ": *

#show: note

= Statement

#theorem(title: [Theorem of the Square])[
    Let $A$ be an #pedia("Abelian Variety")[abelian variety] over a field $k$, and let $cal(L)$ be a #pedia("Line Bundle")[line bundle] on $A$. For $a,b in A(k)$, write $t_a (x) = x+a$ for translation. Then
    $ t_(a+b)^* cal(L) tens cal(L) simeq t_a^* cal(L) tens t_b^* cal(L). $
    The same statement holds after any field extension $ell/k$.
] <square>

#corollary(title: [Degree of Multiplication])[
    Let $(E,e)$ be an #pedia("Elliptic Curve")[elliptic curve] over a field $k$. For every nonzero integer $n$, the multiplication #pedia("Isogeny")[isogeny] $[n]: E -> E$ has degree
    $ deg[n] = n^2. $
    This holds in every characteristic.
] <multiplication-degree>

#proofsketch[
    Put $cal(L) = cal(O)_E (e)$, so $deg cal(L) = 1$ and $[-1]^* cal(L) simeq cal(L)$. The theorem of the square, together with the see-saw principle, gives the symmetric line-bundle identity
    $ [n]^* cal(L) simeq cal(L)^(tens n^2). $
    Taking #pedia("Degree of a Line Bundle")[degrees] yields
    $ deg[n] = deg([n]^* cal(L)) = n^2. $
]
