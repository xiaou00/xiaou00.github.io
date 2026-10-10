#import "../../../template.typ": *

#show: note

The Jacobian variety is an important construction that turns a genus $g$ curve into a $g$-dimensional #pedia[abelian variety].

= Definition

#definition(title: [Jacobian Variety])[
    Let $C/k$ be a #pedia("Smoothness")[smooth], #pedia("Properness")[proper], #pedia("Connectivity")[geometrically connected] curve over a field $k$, of genus $g$. The _Jacobian variety_ of $C$ is the abelian variety
    $ Jac(C) := Pic^0(C) $
]

#claim[
    The Jacobian variety $Jac(C)$ is smooth, separated Abelian $k$-group scheme, locally of finite type and of dimension $g$.
]

= Basic Theory

#theorem[
    There is a canonical isomorphism of $k$-vector spaces
    $ T_0Jac(C) simeq H^1(C, cal(O)_C) $
    where $T_0Jac(C)$ is the tangent space of $Jac(C)$ at the identity.
]

#proof[
    Recall the definition of the tangent space gives
    $ T_0Jac(C) = ker(Jac(C)(k[epsilon]/(epsilon^2)) -> Jac(C)(k)) $
    consider the short exact sequence of sheaves
    $ 1 -> 1+epsilon#h(0pt)cal(O)_C -> cal(O)^times_(C_epsilon) -> cal(O)^times_C -> 1 $
    where $C_epsilon = C times_k Spec k[epsilon]/(epsilon^2)$, since $epsilon^2=0$,
    $ (1+epsilon a)(1+epsilon b) = 1+epsilon(a+b) $
    this gives $1+epsilon#h(0pt)cal(O)_C simeq cal(O)_C$ as sheaves of abelian groups, so we have the short exact sequence
    $ 0 -> cal(O)_C -> cal(O)^times_(C_epsilon) -> cal(O)^times_C -> 1 $
    taking the long exact sequence of cohomology gives
    $
    H^0(C_epsilon, cal(O)^times_(C_epsilon))
        &-> H^0(C, cal(O)^times_C)
        -> H^1(C, cal(O)_C)\
        &-> H^1(C_epsilon, cal(O)^times_(C_epsilon))
        -> H^1(C, cal(O)^times_C)\
    $
    since $H^1(X,cal(O)^times_X) simeq Pic(X)$, and the first map is surjective since any unit $u$ can be lifted to $u+epsilon 0$, we have
    $ H^1(C,cal(O)_C) simeq ker(Pic(C_epsilon) -> Pic(C)) = T_0Jac(C) $
]

#corollary[
    By #pedia[Serre Duality], we have
    $ T_0^*Jac(C) simeq H^0(C, omega_C) $
]
