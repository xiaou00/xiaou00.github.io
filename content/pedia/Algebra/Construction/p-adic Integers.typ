#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [$p$-adic Integers])[
    For a prime $p$, the ring of _$p$-adic integers_ is the $p$-adic completion of $ZZ$:
    $ ZZ_p := varprojlim(n >= 1) ZZ/p^n ZZ, $
    using the reduction maps $ZZ/p^(n+1) ZZ -> ZZ/p^n ZZ$. This is an actual #pedia("Projective Limit")[inverse limit] of rings, equipped with the inverse limit topology of the finite discrete quotients.

    An element is a compatible sequence $(a_n)_(n >= 1)$ with $a_n in ZZ/p^n ZZ$ and $a_(n+1) equiv a_n mod p^n$.
] <definition>

#remark[
    The ideals $p^n ZZ_p$ form a neighbourhood basis of zero, and $ZZ -> ZZ_p$ has dense image. The ring $ZZ_p$ is a complete discrete valuation ring; its additive group is the pro-$p$ completion of $ZZ$, hence a #pedia("Profinite Group")[profinite group].
] <completion>
