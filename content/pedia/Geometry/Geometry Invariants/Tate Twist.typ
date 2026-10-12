#import "../../../template.typ": *

#show: note

Let $X$ be a scheme and $ell$ a prime #pedia("Invertible Prime")[invertible on $X$].

= Coefficients <coefficients>

On the #pedia("Etale Topos")[small étale topos], put $Lambda_r = ZZ/ell^r ZZ$ and
$ Lambda_r (1) := mu_(ell^r), quad mu_(ell^r)(U) = {u in cal(O)(U)^times : u^(ell^r) = 1}. $
This is a locally free $Lambda_r$-module sheaf of rank one, with scalar action $a dot u = u^a$.

The adic coefficients are
$ ZZ_ell (1) := (mu_(ell^r))_(r >= 1), quad QQ_ell (1) := ZZ_ell (1) tens_(ZZ_ell) QQ_ell, $
with transition maps $mu_(ell^(r+1)) -> mu_(ell^r)$, $u |-> u^ell$. Here $ZZ_ell (1)$ denotes the compatible #pedia("Etale Cohomology", <adic>)[adic system].

= Tate Twists

#definition(title: [Tate Twist])[
    For $Lambda = Lambda_r, ZZ_ell$, or $QQ_ell$, set
    $ Lambda(0) := Lambda, quad Lambda(n) := Lambda(1)^(tens n) quad (n > 0), $
    $ Lambda(-n) := underline(Hom)_Lambda (Lambda(n),Lambda) quad (n > 0), $
    where $underline(Hom)$ is internal Hom in the corresponding coefficient category.

    The _$n$th Tate twist_ of a sheaf or complex $K$ is
    $ K(n) := K tens_Lambda Lambda(n), quad n in ZZ. $
    On complexes, tensor products are understood to be derived.
] <definition>

Twisting is an exact equivalence: $K(a)(b) simeq K(a+b)$ and $K(0) simeq K$. It preserves cohomological degrees.

= Over a Field <galois>

For $X = Spec k$, the corresponding continuous $G_k = Gal(k^sep/k)$-module is
$ ZZ_ell (1) = varprojlim(r) mu_(ell^r)(k^sep) = T_ell GG_m, $
the #pedia("Tate Module")[Tate-module construction] applied to the multiplicative group. It is free of rank one, with $G_k$ acting through the _cyclotomic character_
$ chi_ell: G_k -> ZZ_ell^times, quad sigma(zeta) = zeta^(chi_ell (sigma) mod ell^r) quad (zeta in mu_(ell^r)(k^sep)). $
Thus, if $V$ has action $rho$, the action on $V(n)$ is $sigma |-> chi_ell (sigma)^n rho(sigma)$.

See #link("https://www.math.columbia.edu/~chaoli/docs/AbelianVarieties.html")[Tate modules and p-divisible groups, Definition 30].
