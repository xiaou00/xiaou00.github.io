#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Group])[
    A _group_ is a set $G$ with a multiplication $G times G -> G$, an identity $e$, and an inverse $g^(-1)$ for each $g in G$, satisfying
    $ (g h)k = g(h k), quad e g = g = g e, $
    $ g g^(-1) = e = g^(-1) g $
    for all $g,h,k in G$.
] <definition>

#definition(title: [Abelian Group])[
    A group $G$ is _abelian_ if $g h = h g$ for all $g,h in G$. Its operation is often written additively, with identity $0$ and inverse $-g$.
] <abelian>
