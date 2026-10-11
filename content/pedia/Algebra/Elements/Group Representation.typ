#import "../../../template.typ": *

#show: note

= Definition via BG

Let $G$ be a #pedia("Group")[group], or more generally a group object in #pedia("Anima")[$Ani$], and let $B G$ be its #pedia("Classifying Anima")[classifying anima].

#definition(title: [Group Representation])[
    A _representation_ of $G$ in an #pedia("Infinity Category")[$oo$-category] $cal(C)$, or a _$G$-object_ of $cal(C)$, is a #pedia("Functor", <infinity>)[functor]
    $ F: B G -> cal(C). $
    The $oo$-category of representations is
    $ Rep_(cal(C))(G) := Fun(B G,cal(C)), $
    with #pedia("Functor", <natural-transformations>)[natural transformations] as morphisms.

    The underlying object is $X := F(*)$. Since $B G$ is an $oo$-groupoid, its arrows act by equivalences of $X$; the functor includes all coherences for the action.
] <definition>

#remark(title: [Ordinary Categories])[
    For an ordinary group $G$, the groupoid with one object and automorphism group $G$ models $B G$ via its #pedia("Nerve")[nerve]. If $cal(C)$ is ordinary, a representation is equivalently an object $X$ and a group homomorphism
    $ rho: G -> Aut_(cal(C))(X). $
    Thus $rho(g h) = rho(g) compose rho(h)$ and $rho(e) = id_X$. A morphism to $(Y,rho')$ is a map $u: X -> Y$ satisfying $u compose rho(g) = rho'(g) compose u$ for every $g in G$.
] <ordinary>

= Linear Representations

#definition(title: [Linear Representation])[
    Let $G$ be an ordinary group and $R$ a #pedia("Ring")[ring]. Write $Mod_R$ for the ordinary category of left #pedia("Module")[$R$-modules]. An _$R$-linear representation_ of $G$ is an object of
    $ Rep_R (G) := Fun(B G,Mod_R). $
    Equivalently, it is an $R$-module $V$ with an action $G -> Aut_R (V)$ by $R$-linear automorphisms. Over a #pedia("Field")[field] $k$, this is the usual representation on a vector space.
] <linear>

These representations can also be described as modules over the #pedia("Group Algebra", <representations>)[group ring].
