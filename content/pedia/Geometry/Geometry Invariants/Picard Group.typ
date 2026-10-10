#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Picard Group])[
    Let $X$ be a scheme. The _Picard group_ $Pic(X)$ is the abelian group of isomorphism classes of #pedia[line bundle] on $X$, equivalently locally free $cal(O)_X$-modules of rank $1$. Its group operation is induced by tensor product:
    $ [cal(L)] + [cal(M)] := [cal(L) tens_(cal(O)_X) cal(M)]. $
    The identity is $[cal(O)_X]$, and the inverse of $[cal(L)]$ is $[cal(L)^*]$, where $cal(L)^*$ denotes the dual line bundle.
] <definition>

#remark[
    There is a natural isomorphism
    $ Pic(X) ≅ H^1(X, cal(O)_X^times) $
    where cohomology is taken in the Zariski topology and $cal(O)_X^times$ is the sheaf of units. See #Stack("09NT").
] <cohomology>
