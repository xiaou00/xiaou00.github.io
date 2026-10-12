#import "../../../template.typ": *

#show: note

Let $X$ be a connected #pedia("Anima")[anima] with base point $x$.

= Definition

#definition(title: [Galois Covering])[
    A connected #pedia("Covering Space")[covering] $p:Y -> X$ is _Galois_ (or _regular_) if $Deck(Y/X)$ acts transitively on $Y_x$. This action is then simply transitive. Its _Galois group_ is
    $ Gal(Y/X) := Deck(Y/X). $
] <definition>

= Normal-Subgroup Criterion

#proposition[
    For a connected covering $Y -> X$, choose $y in Y_x$ and put $G = pi_1 (X,x)$ and $H = p_* pi_1 (Y,y)$. Then
    $ Deck(Y/X) simeq N_G (H)/H, $
    where $N_G (H) = {g in G : g H g^(-1) = H}$. Consequently, $Y/X$ is Galois exactly when $H$ is normal in $G$, and then
    $ Gal(Y/X) simeq G/H. $
] <criterion>

#proof[
    By #pedia("Covering Space Classification", <classification>)[monodromy], $Y_x simeq G/H$ and deck transformations are its equivariant bijections. These are precisely $g H |-> g a^(-1) H$, for $a in N_G (H)$, modulo $H$. They act freely, and transitively exactly when $N_G (H) = G$.
]

#corollary(title: [Finite Galois Closure])[
    Every connected finite covering is dominated by a connected finite Galois covering.
] <galois-closure>

#proof[
    If $H$ has finite index, its core $N := inter_(g in G) g H g^(-1)$ is the kernel of the action on $G/H$, hence normal of finite index. The quotient map $G/N -> G/H$ gives the required covering.
]

The analogous notion in a #pedia("Galois Category")[Galois category] is a #pedia("Galois Object")[Galois object].
