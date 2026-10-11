#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Module])[
    Let $R$ be a #pedia("Ring")[ring]. A _left $R$-module_ is an #pedia("Group", <abelian>)[abelian group] $(M,+)$ with a scalar multiplication $R times M -> M$, satisfying
    $ r(x+y) = r x + r y, quad (r+s)x = r x + s x, $
    $ (r s)x = r(s x), quad 1_R x = x $
    for all $r,s in R$ and $x,y in M$. Modules are left modules unless stated otherwise.
] <definition>

A module over a #pedia("Field")[field] $k$ is called a _vector space_ over $k$.
