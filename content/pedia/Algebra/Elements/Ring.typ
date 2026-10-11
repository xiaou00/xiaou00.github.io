#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Ring])[
    A _ring_ is an #pedia("Group", <abelian>)[abelian group] $(R,+)$ with an associative multiplication $R times R -> R$ and a multiplicative identity $1$, satisfying
    $ r(s+t) = r s + r t, quad (r+s)t = r t + s t, $
    $ 1 r = r = r 1 $
    for all $r,s,t in R$. Rings are always assumed to have an identity, and ring homomorphisms preserve it.
] <definition>

#definition(title: [Commutative Ring])[
    A ring $R$ is _commutative_ if $r s = s r$ for all $r,s in R$.
] <commutative>
