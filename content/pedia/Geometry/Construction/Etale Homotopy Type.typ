#import "../../../template.typ": *

#show: note

Let $cal(X) = Shv(X_et,Ani)$ be the #pedia("Etale Topos")[small étale $oo$-topos], with $Gamma^* tack.l Gamma_*$.

= Shape

#definition(title: [Étale Homotopy Type])[
    The _étale homotopy type_ is the #pedia("Pro Completion")[pro-anima]
    $ Pi^et_oo (X) := Shape(cal(X)) in Pro(Ani) $
    characterized by
    $ Map_(Pro(Ani))(Pi^et_oo (X),K) simeq Gamma_* Gamma^* K $
    for every $K in Ani$, regarded as a constant pro-object on the left.
] <definition>

Thus the shape records global sections of constant anima-valued sheaves. If $Gamma^"pro"_sharp$ denotes the pro-left adjoint of $Gamma^*$, the same definition is
$ Pi^et_oo (X) = Gamma^"pro"_sharp (1). $
A presentation is written $Pi^et_oo (X) = varprojlim(i)^sharp P_i$; it is a formal limit, not generally an ordinary anima.

= Profinite Shape

#definition(title: [Profinite Étale Homotopy Type])[
    An anima is _$pi$-finite_ if it has finitely many components and finite homotopy groups, vanishing above some degree. Let $Ani_"fin"$ denote this full subcategory.

    The _profinite étale homotopy type_ $hat(Pi)^et_oo (X) in Pro(Ani_"fin")$ satisfies the same mapping formula for $pi$-finite $K$. It is the profinite completion of $Pi^et_oo (X)$.
] <profinite>

= Monodromy <fundamental-group>

Finite local systems agree under
$ LocSys_"fin" (cal(X)) simeq LocSys_"fin" (hat(Pi)^et_oo (X)), $
where the right side uses #pedia("Local System", <profinite>)[local systems on a pro-anima]. For connected $X$ with geometric point $overline(x)$,
$ tau_(<=1) hat(Pi)^et_oo (X) simeq B_"pro" pi_1^et (X,overline(x)). $
This relates the full homotopy type to the #pedia("Etale Fundamental Group")[étale fundamental group]; the latter retains only the pointed 1-type.

For a field $k$, with $G_k = Gal(k^sep/k)$,
$ hat(Pi)^et_oo (Spec k) simeq B_"pro" G_k = varprojlim(N)^sharp B(G_k/N), $
over open normal subgroups $N$. For a finite abelian group $A$, the constant-coefficient case of #pedia("Etale Cohomology", <shape>)[étale cohomology] is recovered by mapping into $K(A,n)$.
