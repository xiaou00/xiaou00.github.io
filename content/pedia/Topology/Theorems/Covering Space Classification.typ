#import "../../../template.typ": *

#show: note

Let $X$ be a connected #pedia("Anima")[anima], choose $x:* -> X$, and put $G := pi_1 (X,x) = pi_0 Omega_x X$.

= Monodromy

#theorem(title: [Classification of Coverings])[
    Evaluation at $x$, with transport around loops, gives equivalences
    $ Cov(X) simeq Set^G, quad FCov(X) simeq Fin^G. $
    Here the left sides are #pedia("Covering Space")[covering categories], and the right sides are sets or finite sets with a left $G$-action. The action on $Y_x$ is called _monodromy_.
] <classification>

#proof[
    Set-valued functors factor through the fundamental groupoid $tau_(<=1) X$. Since $X$ is connected, this groupoid is equivalent to #pedia("Classifying Anima", <discrete>)[$B G$]. Hence $Fun(X,Set) simeq Fun(B G,Set) simeq Set^G$; restrict to finite sets for the second assertion.
]

#proposition[
    For a covering $Y -> X$,
    $ pi_0 Y simeq Y_x/G, quad Deck(Y/X) simeq Aut_G (Y_x). $
    In particular, $Y$ is connected exactly when the fiber is nonempty and the monodromy action is transitive.
] <components>

#proof[
    Points in a fiber are joined in $Y$ exactly when a lifted loop connects them; every component meets the fiber. Automorphisms correspond under @classification to equivariant bijections.
]

= Subgroups

A connected covering with a chosen $y in Y_x$ determines
$ H := "Stab"_G (y) = p_* pi_1 (Y,y), quad Y_x simeq G/H. $
This classifies pointed connected coverings up to pointed isomorphism by subgroups $H <= G$. Without a chosen $y$, the classification is by conjugacy classes of subgroups. Finite connected coverings correspond to finite-index subgroups, with degree $[G:H]$.

For the normal-subgroup case, see #pedia("Galois Covering").
