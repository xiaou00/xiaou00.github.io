#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Local System])[
    Let $X$ be an #pedia("Anima")[anima] and $cal(C)$ an #pedia("Infinity Category")[$oo$-category]. A _$cal(C)$-valued local system_ on $X$ is a functor
    $ F: X -> cal(C). $
    These form $LocSys_(cal(C))(X) := Fun(X,cal(C))$, with natural transformations as morphisms. Paths induce equivalences between fibers; higher simplices encode coherent transport.
] <definition>

For $cal(C) = Set$ or $Fin$, these are #pedia("Covering Space")[coverings or finite coverings]. For an ordinary category $cal(C)$ and connected pointed $X$, transport gives
$ LocSys_(cal(C))(X) simeq Fun(B pi_1 (X,x),cal(C)). $
Thus ordinary local systems are #pedia("Group Representation")[representations] of the fundamental group. With general $oo$-categorical coefficients, they can also detect higher homotopy.

= Continuous Finite Local Systems

#definition(title: [Finite Local System on a Pro-Anima])[
    For a #pedia("Pro Completion")[pro-anima] $X = varprojlim(i in I)^sharp X_i$, define
    $ LocSys_"fin" (X) := colim_(i in I^opp) Fun(X_i,Fin), $
    in $Cat_oo$, with transition functors given by pullback. A finite local system is represented at some stage; comparisons are made after passing to a common refinement.
] <profinite>

For a #pedia("Profinite Group")[profinite group] $G$, this gives
$ LocSys_"fin" (B_"pro" G) simeq Fin_G^"cont", $
the category of finite sets with continuous $G$-action. Here #pedia("Classifying Anima", <profinite>)[$B_"pro" G$] uses the finite quotients of $G$; continuity means that the action factors through a finite quotient.
