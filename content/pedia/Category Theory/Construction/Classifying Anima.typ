#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Classifying Anima])[
    Let $G$ be a group object in #pedia("Anima")[$Ani$]. Its _classifying anima_ is the #pedia("Sifted Category", <geometric-realization>)[geometric realization] of the bar construction:
    $ B G := abs(B_bullet G) = colim_([n] in Delta^opp) B_n G, quad B_n G = G^n. $
    Here $G^0 = *$; the face maps multiply adjacent entries or drop an end entry, and the degeneracies insert the identity. The anima $B G$ is pointed and connected, with $Omega(B G) simeq G$.
] <definition>

#remark(title: [Discrete Groups])[
    For an ordinary #pedia("Group")[group] $G$, the bar construction is the #pedia("Nerve")[nerve] of the groupoid with one object and automorphism group $G$. It is a #pedia("Kan Complex")[Kan complex], and
    $ pi_1 (B G,*) simeq G, quad pi_n (B G,*) = 0 quad (n >= 2). $
    Thus $B G$ is the Eilenberg-Mac Lane anima $K(G,1)$. Functors out of $B G$ define #pedia("Group Representation")[group representations].
] <discrete>

#remark(title: [Profinite Groups])[
    For a #pedia("Profinite Group")[profinite group] $G = varprojlim(i in I)^sharp G_i$, its _profinite classifying anima_ is the formal #pedia("Pro Completion")[pro-object]
    $ B_"pro" G := varprojlim(i in I)^sharp B G_i in Pro(Ani). $
    This construction retains the finite quotient system of $G$.
] <profinite>
