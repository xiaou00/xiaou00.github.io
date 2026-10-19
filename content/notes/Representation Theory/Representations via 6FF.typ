#import "../../template.typ": *

#show: note

= Classical Interpretations

== Group Representations

#definition(title:[Group Representation])[
    A _linear representation_ of a group $G$ on a vector space $V$ over a field $k$ is a group homomorphism
    $ rho : G -> GL(V) $ 
    where $GL(V)$ is the general linear group.
]

See #pedia[Group Representation] for more details. We write
$ Rep_k (G) $
for the category of representations of $G$ over $k$, where $k$ can be a field or a commutative ring. We have the equivalence
$ Rep_k (G) simeq Fun(B G, Mod_k) simeq Mod_(k[G]) $

== Lie Algebra Representations

#definition(title:[Representation of a Lie Algebra])[
    Suppose $frak(g)$ is a Lie algebra over a field $k$. A _representation_ of $frak(g)$ on a vector space $V$ over $k$ is a Lie algebra homomorphism
    $ rho : frak(g) -> gl(V) $
    where $gl(V)$ is the Lie algebra of endomorphisms of $V$ with the commutator bracket.
]

We write
$ Rep_k (frak(g)) $
for the category of representations of $frak(g)$ over $k$. We have the equivalence
$ Rep_k (frak(g)) simeq Mod_(U(frak(g))) $
where $U(frak(g))$ is the universal enveloping algebra of $frak(g)$.

== Algebraic Group Representations

#definition(title:[Representation of an Algebraic Group])[
    Suppose $G$ is an algebraic group over a field $k$. A _representation_ of $G$ on a vector space $V$ over $k$ is a group scheme homomorphism
    $ rho : G -> GL(V) $
    where $GL(V)$ is the general linear group scheme. Equivalently, a representation of $G$ is a comodule over the Hopf algebra $k[G]$ of regular functions on $G$.
]

= Let's use 6FF 
