#import "../../../template.typ": *

#show: note

Let $cal(X) = Shv(X_et,Ani)$ be the #pedia("Etale Topos")[small étale $oo$-topos] of a scheme $X$, and let $A in Ab(cal(X)_(<=0))$ be an abelian étale sheaf.

= Internal Eilenberg-Mac Lane Objects

#definition(title: [Étale Cohomology])[
    For $n >= 0$, let $K(A,n) = B^n A$ be the internal Eilenberg-Mac Lane object, obtained by iterated delooping in $cal(X)$, with $K(A,0) = A$. Define
    $ H^n_et (X,A) := pi_0 Map_(cal(X))(1,K(A,n)). $
    Thus a cohomology class is a homotopy class of global sections of $K(A,n)$.
] <definition>

For $n > 0$, $K(A,n)$ has homotopy sheaf $A$ in degree $n$ and no other nonzero homotopy sheaves.

= Derived Sections and Ext <derived>

Let $Dcat(cal(X),ZZ)$ be the derived category of abelian sheaves, or its stable $oo$-categorical enhancement. On derived categories, $f^*,f_*,f_!,f^!$ and $Gamma$ denote the derived functors, without $"L"$ or $"R"$ prefixes. Then
$ H^n_et (X,A) = H^n (Gamma(cal(X),A)). $
Concretely, take an injective resolution $A -> I^bullet$ and apply ordinary sections termwise; the resulting complex $I^bullet(X)$ computes $Gamma(cal(X),A)$.

Ordinary sections are $H^0 (Gamma(cal(X),A)) = Hom_(Ab(cal(X)_(<=0)))(underline(ZZ),A)$. Thus
$ H^n_et (X,A) simeq Ext^n_(Ab(cal(X)_(<=0)))(underline(ZZ),A)
    simeq pi_0 Map_(Dcat(cal(X),ZZ))(underline(ZZ),A[n]). $
For a bounded below complex $K$, the same formula $H^n (Gamma(cal(X),K))$ defines hypercohomology.

= Spectra and Shape <spectra>

Let $Sp(cal(X))$ be the category of spectrum objects in $cal(X)$, and $H A$ the Eilenberg-Mac Lane spectrum, whose $n$th space is $K(A,n)$. Global sections extend to spectra, and
$ H^n_et (X,A) simeq pi_(-n) Gamma_* (H A). $
More generally, $pi_(-n) Gamma_* E$ defines cohomology with coefficients in a spectrum object $E$. Ring spectra give cup products via multiplication.

== Shape <shape>

For a constant abelian group $M$, the #pedia("Etale Homotopy Type")[shape] gives
$ H^n_et (X,underline(M)) simeq pi_0 Map_(Pro(Ani))(Pi^et_oo (X),K(M,n)). $
If $M$ is finite, one may replace the shape by its profinite completion. A nonconstant $A$ uses the internal object $K(A,n)$ from the definition.

= Torsors, Gerbes, and Cocycles <torsors>

$H^1_et (X,A)$ classifies $A$-torsors: sheaves with an $A$-action which are locally isomorphic to $A$ acting on itself. $H^2_et (X,A)$ classifies gerbes banded by $A$: locally nonempty, locally connected groupoid-valued sheaves with compatible automorphism sheaves identified with $A$.

For a possibly nonabelian group sheaf $G$, the same torsor interpretation defines the pointed set
$ H^1_et (X,G) := pi_0 Map_(cal(X))(1,B G). $

== Hypercovers <hypercovers>

For an étale hypercover $U_bullet -> X$, form $C^q(U_bullet,A) = A(U_q)$ using ordinary sections, with differential the alternating sum of face pullbacks. Then
$ H^n_et (X,A) simeq colim_(U_bullet -> X) H^n (C^bullet(U_bullet,A)), $
over refinements, with hypercover maps taken up to homotopy. A hypercover covers the matching object at every simplicial degree. Ordinary Čech covers suffice when their terms are $A$-acyclic; one cover need not compute all cohomology.

= Galois and Adic Coefficients <galois>

For $X = Spec k$, an abelian étale sheaf corresponds to a discrete continuous $G_k = Gal(k^sep/k)$-module $M$. Then
$ H^n_et (Spec k,A) simeq H^n_"cont" (G_k,M), $
the right derived functors of invariants, computed by continuous group cochains. For a general scheme, the fundamental group alone need not determine higher étale cohomology.

== Adic Coefficients <adic>

Let $ell$ be a prime #pedia("Invertible Prime")[invertible on $X$]. Continuous $ell$-adic cohomology is defined using the coefficient system:
$ Gamma_et (X,ZZ_ell) := varprojlim(r) Gamma_et (X,ZZ/ell^r), $
$ Gamma_et (X,QQ_ell) := Gamma_et (X,ZZ_ell) times.o_(ZZ_ell) QQ_ell. $
The limit and tensor product are taken in the derived category. Take $H^n$ to obtain the groups; possible $lim^1$ terms are retained. These are adic coefficients, rather than discrete constant $ZZ_ell$ or $QQ_ell$ sheaves.

The coefficients $ZZ_ell (n)$ and $QQ_ell (n)$ are #pedia("Tate Twist")[Tate twists].

The corresponding proper-support theory is #pedia("Compactly Supported Cohomology")[compactly supported cohomology].
