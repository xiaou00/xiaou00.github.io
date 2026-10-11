#import "../../../template.typ": *

#show: note

= Definition

Let $G$ be an ordinary #pedia("Group")[group] with identity $e$, and let $R$ be a #pedia("Ring")[ring].

#definition(title: [Group Ring and Group Algebra])[
    The _group ring_ $R[G]$ is the free left $R$-module with basis $[g]$ for $g in G$. Its elements are finite sums $sum_(g in G) a_g [g]$, with multiplication determined by
    $ (a[g])(b[h]) = (a b)[g h], quad 1_(R[G]) = 1_R [e]. $
    Addition is coefficientwise, and multiplication extends distributively. Thus each $[g]$ is a unit with inverse $[g^(-1)]$.

    If $R$ is commutative, this is an associative unital $R$-algebra, called the _group algebra_ of $G$ over $R$.
] <definition>

#remark(title: [Universal Property])[
    Suppose $R$ is commutative. For every associative unital $R$-algebra $A$, restriction along $g |-> [g]$ gives a natural bijection
    $ Hom_(Alg_R)(R[G],A) simeq Hom_(Grp)(G,A^times). $
    Here $R$-algebras have a unit-preserving map from $R$ with central image, and $A^times$ is the group of units of $A$.
] <universal-property>

#proposition(title: [Representations as Modules])[
    For any ring $R$, #pedia("Group Representation", <linear>)[representations] and modules are related by an equivalence of ordinary categories
    $ Rep_R (G) = Fun(B G,Mod_R) simeq Mod_(R[G]). $
    A representation $(V,rho)$ becomes a left $R[G]$-module by
    $ (sum_g a_g [g])v := sum_g a_g rho(g)(v). $
    Conversely, a module gives the action $rho(g)(v) := [g]v$. Equivariant $R$-linear maps are exactly $R[G]$-linear maps.
] <representations>
