#import "../../../template.typ": *

#show: note

= Definition <six-functors>

Let $f:X -> Spec k$ be separated of finite type, $Lambda = ZZ/m$ with $m$ invertible in $k$, and $K in Dcat(X_et,Lambda)$ on the #pedia("Etale Topos")[small étale topos]. All functors are understood to be derived. In the #pedia("Six-Functor Formalism")[six-functor formalism], $f_!$ is the direct image with proper support, with $f_! tack.l f^!$.

#definition(title: [Compactly Supported Cohomology])[
    Define
    $ Gamma_c (X,K) := Gamma((Spec k)_et,f_! K), $
    $ H^n_c (X,K) := H^n (Gamma_c (X,K)). $
    If $k$ is separably closed, this simplifies to $Gamma_c (X,K) simeq f_! K$.
] <definition>

If $X/k$ is proper, $f_! = f_*$, so $H^n_c (X,K) = H^n_et (X,K)$.

#remark(title: [Topological Version])[
    For a locally compact Hausdorff space $T$ with $p:T -> *$, the same definition is $Gamma_c (T,K) := p_! K$.
] <topological>
