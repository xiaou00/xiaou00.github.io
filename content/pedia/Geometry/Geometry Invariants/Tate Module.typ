#import "../../../template.typ": *

#show: note

= Definition

Let $A/k$ be an #pedia("Abelian Variety")[abelian variety] of dimension $g$. Fix a separable closure $k^sep$ and a prime $ell != char(k)$.

#definition(title: [Tate Module])[
    The _$ell$-adic Tate module_ and _rational Tate module_ are
    $ T_ell A := varprojlim(r >= 1) A[ell^r](k^sep), quad V_ell A := T_ell A tens_(ZZ_ell) QQ_ell, $
    using the #pedia("Torsion Point", <n-torsion>)[torsion subgroups] and transition maps $[ell]$. Thus elements are sequences $(P_r)$ satisfying $[ell]P_(r+1) = P_r$.

    Give $T_ell A$ the inverse limit topology. A scalar in #pedia("p-adic Integers")[$ZZ_ell$] acts on the $r$-th coordinate through its residue modulo $ell^r$.
] <definition>

#remark[
    The module $T_ell A$ is free of rank $2g$ over $ZZ_ell$.
] <structure>

= Elliptic Curves

#proposition[
    For an #pedia("Elliptic Curve")[elliptic curve] $E$, $T_ell E simeq ZZ_ell^2$ noncanonically. Coordinate projection gives a canonical isomorphism
    $ T_ell E / ell^r T_ell E simeq E[ell^r](k^sep). $
    The inverse limit topology is the $ell$-adic topology.
] <tate-structure>

#proofsketch[
    By the #pedia("Torsion Point", <torsion-structure>)[torsion structure], each $E[ell^r](k^sep)$ is free of rank $2$ over $ZZ/ell^r ZZ$. The #pedia("Torsion Point", <transition-maps>)[surjective transition maps] let us lift a basis of $E[ell](k^sep)$ recursively. The lifts remain bases: any relation, after multiplication by $ell^(r-1)$, has coefficients divisible by $ell$; induction gives divisibility by $ell^r$. In these compatible bases, transitions are reduction maps, giving both assertions.
]

= Functoriality and Galois Action

A $k$-homomorphism $f: A -> B$ induces the continuous $ZZ_ell$-linear map
$ T_ell f: T_ell A -> T_ell B, quad (P_r) |-> (f(P_r)). $
This respects identities, composition, and addition; in particular $T_ell [n] = n id$.

The group $G_k := Gal(k^sep / k)$ acts componentwise, giving a continuous #pedia("Group Representation")[representation]
$ rho_(A,ell): G_k -> Aut_(ZZ_ell)(T_ell A) simeq "GL"_(2g)(ZZ_ell), $
where the last identification requires a basis. Continuity follows because all torsion points at each level are defined over a finite Galois extension. Coordinate projections and maps $T_ell f$ are Galois equivariant.

For elliptic curves, #pedia("Isogeny", <tate-modules>)[isogenies induce isomorphisms on rational Tate modules].

The same construction for the multiplicative group gives #pedia("Tate Twist", <galois>)[$T_ell GG_m = ZZ_ell (1)$].
