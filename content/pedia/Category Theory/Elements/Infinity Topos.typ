#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Infinity Topos])[
    An _$oo$-topos_ is an #pedia("Infinity Category")[$oo$-category] $cal(X)$ admitting an #pedia("Adjunction")[adjunction]
    $ L: PShv(cal(C)) arrows.lr cal(X): i, quad L tack.l i, $
    where $cal(C)$ is small, $PShv(cal(C)) = Fun(cal(C)^opp,Ani)$, $i$ is fully faithful, and the localization is accessible and left exact.

    _Left exact_ means that $L$ preserves finite limits. _Accessible_ means that $i L$ preserves $kappa$-filtered colimits for some regular cardinal $kappa$.
] <definition>

See #HTT[Definition 6.1.0.4]. Typical examples are #pedia("Anima")[$Ani$], presheaf categories, and $Shv(cal(C),J;Ani)$, the anima-valued sheaves on a site. In the last case, $L$ is sheafification. Limits are computed in presheaves, and colimits are sheafified presheaf colimits.

An object $F$ is _0-truncated_ if every $Map_(cal(X))(T,F)$ is a set. The full subcategory $cal(X)_(<=0)$ is an ordinary topos; for a site it is $Shv(cal(C),J;Set)$.

= Geometric Morphisms and Sections

#definition(title: [Geometric Morphism])[
    A _geometric morphism_ $f:cal(X) -> cal(Y)$ is an adjunction
    $ f^*:cal(Y) arrows.lr cal(X):f_*, quad f^* tack.l f_*, $
    with $f^*$ preserving finite limits. The inverse image $f^*$ also preserves all colimits.
] <geometric-morphism>

= Global Sections <global-sections>

Every $oo$-topos has a global-sections geometric morphism $Gamma:cal(X) -> Ani$:
$ Gamma^* tack.l Gamma_*, quad Gamma_* F = Map_(cal(X))(1,F). $
Here $1$ is terminal and $underline(K) := Gamma^* K$ is the _constant object_ associated to $K in Ani$. On a site, this is the sheafification of the constant presheaf.

= Open Subtopoi <open-subtopos>

Every slice $cal(X)_(\/U)$ is again an $oo$-topos. If $U -> 1$ is a monomorphism, it defines an _open subtopos_ $cal(X)_(\/U) -> cal(X)$. On sheaves of abelian groups, its inverse image $j^*$ has an exact left adjoint $j_!$, called _extension by zero_.

The #pedia("Etale Topos")[small étale topos] is the setting for the fundamental group and cohomology of a scheme.
