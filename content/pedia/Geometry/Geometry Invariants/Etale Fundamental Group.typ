#import "../../../template.typ": *

#show: note

Let $X$ be a connected scheme, $overline(x)$ a geometric point, and $cal(X) = Shv(X_et,Ani)$ its #pedia("Etale Topos")[small étale $oo$-topos].

= Fiber Functor

#definition(title: [Étale Fundamental Group])[
    Restrict the stalk functor to #pedia("Etale Topos", <finite-local-systems>)[finite locally constant objects]:
    $ omega_(overline(x)):LocSys_"fin" (cal(X)) -> Fin, quad F |-> overline(x)^* F. $
    The _étale fundamental group_ is
    $ pi_1^et (X,overline(x)) := Aut(omega_(overline(x))), $
    with the profinite topology defined by its actions on all finite fibers.
] <definition>

This is the fundamental group of the #pedia("Galois Category")[Galois category] $(LocSys_"fin" (cal(X)),omega_(overline(x)))$. Equivalently, use finite étale schemes and the functor $Y |-> Hom_X (overline(x),Y)$.

= Monodromy and Covers <monodromy>

Put $G = pi_1^et (X,overline(x))$. Evaluation gives
$ FEt/X simeq LocSys_"fin" (cal(X)) simeq Fin_G^"cont". $
The last category consists of finite sets with continuous $G$-action. Consequently:

+ Connected finite étale covers correspond to transitive actions.
+ Pointed connected covers correspond to open subgroups $H <= G$, with fiber $G/H$; without a point, take conjugacy classes of subgroups.
+ A connected cover is _Galois_ if its deck group acts transitively on its fiber, equivalently if $H$ is normal.

Here connected means connected as a scheme; geometric connectedness is a stronger condition.

= Galois Covers and the Fundamental Pro-Object <galois-covers>

The #pedia("Fundamental Pro-Object")[fundamental pro-object] is
$ P_(overline(x)) := varprojlim((Y,overline(y)))^sharp Y, $
over pointed connected finite étale Galois covers. It pro-represents $omega_(overline(x))$. Thus
$ G simeq (Aut_(Pro(FEt/X))(P_(overline(x))))^opp
    simeq varprojlim((Y,overline(y))) (Aut_X (Y))^opp. $
The opposite groups account for precomposition on $Hom(P_(overline(x)),-)$. Transition maps are induced by pointed maps of covers; this is an actual inverse limit of finite groups.

= Homotopy and Classical Viewpoints <shape>

For the #pedia("Etale Homotopy Type", <profinite>)[profinite étale shape],
$ pi_1^et (X,overline(x)) simeq pi_1 (hat(Pi)^et_oo (X),overline(x)). $
Equivalently, its pointed 1-truncation is $B_"pro" G$.

For a field $k$, this recovers $pi_1^et (Spec k,overline(x)) simeq Gal(k^sep/k)$. For a connected scheme of finite type over $CC$ with complex base point $x$,
$ pi_1^et (X,overline(x)) simeq hat(pi_1 (X^"an",x)), $
the profinite completion of the topological fundamental group.

= Geometric and Arithmetic Groups <arithmetic>

If $X/k$ is geometrically connected, quasi-compact and quasi-separated, there is an exact sequence
$ 1 -> pi_1^et (X_(overline(k)),overline(x)) -> pi_1^et (X,overline(x)) -> Gal(k^sep/k) -> 1. $
These are respectively the geometric and arithmetic fundamental groups. Changing the geometric base point gives an isomorphism defined up to inner automorphism.
