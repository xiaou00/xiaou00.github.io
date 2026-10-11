#import "../../../template.typ": *

#show: note

= Definition

Let $A/k$ be an #pedia("Abelian Variety")[abelian variety] of dimension $g$. Fix a separable closure $k^sep$ and a prime $ell != char(k)$.

#definition(title: [Tate Module])[
    The _$ell$-adic Tate module_ of $A$ is
    $ T_ell A := varprojlim(n >= 1) A[ell^n](k^sep), $
    with transition maps
    $ [ell]: A[ell^(n+1)](k^sep) -> A[ell^n](k^sep). $
    Here $A[ell^n]$ is the #pedia("Torsion Point", <n-torsion>)[$ell^n$-torsion subgroup scheme]. Thus an element is a sequence $(P_n)_(n >= 1)$ with $P_n in A[ell^n](k^sep)$ and $[ell]P_(n+1) = P_n$.

    This is a #pedia("p-adic Integers")[$ZZ_ell$-module], equipped with the inverse limit topology of the finite discrete groups above. The _rational Tate module_ is
    $ V_ell A := T_ell A tens_(ZZ_ell) QQ_ell. $
] <definition>

#remark[
    The module $T_ell A$ is free of rank $2g$ over $ZZ_ell$. The absolute Galois group $G_k := Gal(k^sep / k)$ acts continuously, componentwise.
] <structure>
