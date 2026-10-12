#import "../../../template.typ": *

#show: note

Let $(cal(C),omega)$ be a #pedia("Galois Category")[Galois category], with $G := pi_1 (cal(C),omega)$.

= Definition

#definition(title: [Galois Object])[
    A connected object $A$ is _Galois_ if $Aut_(cal(C))(A)$ acts transitively on $omega(A)$. The action is then simply transitive, and its _Galois group_ is
    $ Gal(A) := Aut_(cal(C))(A). $
] <definition>

#proposition[
    For connected $A$, choose $a in omega(A)$ and put $U := "Stab"_G (a)$. Then $U$ is open and $omega(A) simeq G/U$. The object $A$ is Galois exactly when $U$ is normal, in which case
    $ Gal(A) simeq G/U. $
] <criterion>

#proof[
    Under #pedia("Galois Category", <reconstruction>)[reconstruction], automorphisms are equivariant bijections of $G/U$. The #pedia("Galois Covering", <criterion>)[normalizer calculation] applies, with $g U |-> g b^(-1) U$ identifying the quotient with the automorphism group.
]

Every connected object is dominated by a Galois object: replace $U$ by the open normal subgroup $N := inter_(g in G) g U g^(-1)$ and use $G/N -> G/U$. In $FCov(X)$, these are precisely the connected finite #pedia("Galois Covering")[Galois coverings].
