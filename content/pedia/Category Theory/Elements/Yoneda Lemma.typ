#import "../../../template.typ": *

#show: note

= Yoneda Lemma

Let $cal(C)$ be a locally small #pedia("Category")[category]. For $X in cal(C)$, the #pedia("Functor")[functor]
$ h_X := Hom_(cal(C))(-,X): cal(C)^opp -> Set $
sends $T$ to $Hom_(cal(C))(T,X)$ and acts on morphisms by precomposition.

#lemma(title: [Yoneda])[
    For every functor $F: cal(C)^opp -> Set$, evaluation at the identity gives a bijection
    $ Nat(h_X,F) simeq F(X), quad eta |-> eta_X (id_X), $
    natural in $X$ and $F$. Here $Nat$ denotes #pedia("Natural Transformation")[natural transformations].
] <yoneda>

#proof[
    Given $x in F(X)$, define $eta_T (f) := F(f)(x)$ for $f: T -> X$. This is natural. Conversely, naturality forces $eta_T (f) = F(f)(eta_X (id_X))$, so these constructions are inverse.
]

For the $oo$-categorical version, see #pedia("Infinity Yoneda").
