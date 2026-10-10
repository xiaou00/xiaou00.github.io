#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Picard Scheme])[
    Let $f: X -> S$ be a morphism of schemes, and write $X_T := X times_S T$. The _relative Picard functor_ $Pic_(X/S)$ is the fppf sheafification of
    $ (Sch/S)^opp -> Ab, quad T |-> Pic(X_T) $
    where $Pic(X_T)$ is the #pedia[Picard Group] of $X_T$, with maps induced by pullback.

    If this functor is represented by an $S$-scheme $underline(Pic)_(X/S)$, the representing scheme is called the _Picard scheme_ of $X$ over $S$. Tensor product of line bundles makes it a commutative group scheme.
] <definition>

#remark[
    Equivalently, one may sheafify the presheaf
    $ T |-> Pic(X_T) / f_T^* Pic(T), $
    where $f_T: X_T -> T$ is the projection. Thus line bundles pulled back from the base are identified with the identity; sheafification is still required in general.
] <relative-line-bundles>

= Representability for Curves

#theorem(title: [Picard Scheme of a Curve])[
    Let $C/k$ be a smooth projective geometrically connected curve over a field $k$, of genus $g$. The relative Picard functor $Pic_(C/k)$ is represented by a smooth separated commutative $k$-group scheme $underline(Pic)_(C/k)$, locally of finite type and of dimension $g$.

    Thus, for every $k$-scheme $T$, there is a natural isomorphism
    $ Hom_k (T, underline(Pic)_(C/k)) ≅ Pic_(C/k)(T). $
    This holds over any field $k$, even when $C(k) = emptyset$.
] <curve-representability>

#proofsketch[
    Smoothness and geometric connectedness make $C$ geometrically integral, so #link("https://arxiv.org/abs/math/0504020")[Grothendieck's Picard representability theorem] applies. Smoothness of the Picard scheme follows from $H^2(C, cal(O)_C) = 0$, which removes the obstructions to deforming line bundles. Its tangent space at the identity is $H^1(C, cal(O)_C)$, giving dimension $g$.
]

#remark[
    Better check out #Stack("0B9R")
]

#remark[
    The natural map $Pic(C) -> underline(Pic)_(C/k)(k)$ is injective, but need not be surjective. It is an isomorphism if $C(k) != emptyset$.
] <rational-points>

= Degree Components

In this section, let $X/k$ be a smooth projective connected curve over an algebraically closed field, of #pedia("Genus")[genus] $g$.

#definition(title: [$Pic^d (X)$])[
    For $d in ZZ$, write $Pic^d (X)$ for the open and closed subscheme of $underline(Pic)_(X/k)$ corresponding to line bundles of fiberwise #pedia("Degree of a Line Bundle")[degree] $d$. In particular,
    $ Pic^d (X)(k) = { [cal(L)] in Pic(X) : deg(cal(L)) = d }. $
] <degree-d>

#proposition[
    + The Picard scheme exists and decomposes as
      $ underline(Pic)_(X/k) = ∐_(d in ZZ) Pic^d (X). $
      Each $Pic^d (X)$ is smooth, projective, and connected of dimension $g$.
    + $Pic^0(X)$ is the identity component and is an abelian variety, the #pedia("Jacobian Variety")[Jacobian] of $X$.
    + Each $Pic^d (X)$ is a torsor under $Pic^0(X)$. Choosing a degree-$d$ line bundle $cal(L)$ gives an isomorphism
      $ Pic^0(X) -> Pic^d (X), quad [cal(M)] |-> [cal(M) tens cal(L)]. $
      This identification depends on the choice of $cal(L)$; for $d != 0$, $Pic^d (X)$ is not a subgroup of the Picard scheme.
] <degree-components>
