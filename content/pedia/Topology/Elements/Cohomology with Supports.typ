#import "../../../template.typ": *

#show: note

Let $cal(X)$ be an #pedia("Infinity Topos")[$oo$-topos], $j:cal(U) -> cal(X)$ an open subtopos, and $Z$ its closed complement.

= Definition

#definition(title: [Cohomology with Supports])[
    For a bounded below complex $K$ of abelian sheaves, with all functors understood to be derived, define
    $ Gamma_Z (cal(X),K) := fib(Gamma(cal(X),K) -> Gamma(cal(U),j^* K)), $
    $ H^n_Z (cal(X),K) := H^n (Gamma_Z (cal(X),K)). $
    For an abelian sheaf $A$, its degree-zero group is
    $ H^0_Z (cal(X),A) = ker(H^0 (cal(X),A) -> H^0 (cal(U),j^* A)). $
] <definition>

For a topological space, these are sections supported on the closed subset $Z$. For a scheme, use $cal(X) = Shv(X_et,Ani)$ and $U = X backslash Z$ to obtain étale cohomology with supports.

= Sections Trivialized on the Complement

For an abelian sheaf $A$ and $n >= 0$, the #pedia("Etale Cohomology", <definition>)[internal Eilenberg-Mac Lane description] gives
$ H^n_Z (cal(X),A) simeq pi_0 fib(Gamma_* K(A,n) -> Gamma_* K(j^* A,n)), $
where the second global-sections functor is on $cal(U)$ and the fiber is over the zero section. A class is a section together with a trivialization on the complement.

The defining fiber sequence yields the localization long exact sequence
$ dots -> H^n_Z (cal(X),A) -> H^n (cal(X),A) -> H^n (cal(U),j^* A) -> H^(n+1)_Z (cal(X),A) -> dots. $

Taking the filtered union over compact supports gives topological #pedia("Compactly Supported Cohomology", <topological>)[compactly supported cohomology].
