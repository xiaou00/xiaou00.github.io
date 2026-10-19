#import "../../template.typ": *
#import "@preview/fletcher:0.5.8": diagram, node, edge

#show: note

See #pedia[correspondence category]


= Basic Definitions <chap-basic-definitions>

== The Category $Corr(cal(C),E)$

#definition(title:[Geometric Setup])[
    A _geometric setup_ is an $oo$-category $cal(C)$ together with a class of morphisms $E$, invariant under equivalence, containing all equivalences, and stable under composition. Pullbacks of morphisms in $E$ along arbitrary morphisms are required to exist and to belong to $E$. A morphism in $E$ is called _admissible_.
]

#example[
    Take $cal(C)=Sch$ and $E$ the proper morphisms. This is a geometric setup: proper morphisms are stable under base change and composition.
]

#construction(title:[Cosimplicial object $Q_bullet$])[
    Fix $n>=0$. Define the poset
    $ P_n = {(i,j) | 0 <= j <= i <= n}, $
    with order
    $ (i,j) prec.eq (i',j') <=> i' <= i, j <= j'. $
    Set $Q_n = Ner(P_n)$. Equivalently, $Q_n$ is the full simplicial subset of $(Delta^n)^opp times Delta^n$ spanned by $(i,j)$ with $j<=i$.

    For each $alpha : [m] -> [n]$, define
    $ Q(alpha) : Q_m &-> Q_n \ (i,j) &|-> (alpha(i),alpha(j)). $
    This gives a cosimplicial object
    $ Q : Delta -> sSet. $
]

#construction(title:[Simplicial set $B(cal(C))$])[
    Define
    $ B(cal(C))_n = Hom_sSet (Q_n,cal(C)). $
    Precomposition with $Q(alpha)$ makes $B(cal(C))$ a simplicial set.
]

#construction(title:[The category $Corr(cal(C),E)$])[
    Define $Corr(cal(C),E) subset B(cal(C))$ to consist of maps
    $ F : Q_n -> cal(C), $
    satisfying:

    +   ($E$-condition) For all $0<=j<=j'<=i<=n$, we have
        $ (F(i,j) -> F(i,j')) in E. $
    +   (Cartesian) For all $0<=j<=j'<=i'<=i<=n$, the square
        #web-diagram(diagram(spacing: 20pt, {
            node((-1, 0), [$F(i,j)$])
            node((-1, 1), [$F(i,j')$])
            node((0, 0), [$F(i',j)$])
            node((0, 1), [$F(i',j')$])
            edge((0, 0), (0, 1), "->")
            edge((-1, 0), (0, 0), "->")
            edge((-1, 0), (-1, 1), "->")
            edge((-1, 1), (0, 1), "->")
        }))
        is Cartesian.

    For $alpha:[m]->[n]$, set
    $ alpha^* F = F compose Q(alpha). $
    Both conditions are preserved, so $Corr(cal(C),E)$ is a simplicial subset.
]

#remark[
    The $0$-simplices are the objects of $cal(C)$, since $Q_0 = Delta^0$. For $n=1$, $Q_1$ is
    #web-diagram(diagram(spacing: 20pt, {
        node((-0.5, -0.866025), [$(1,0)$])
        node((0, 0), [$(1,1)$])
        node((-1, 0), [$(0,0)$])
        edge((-0.5, -0.866025), (-1, 0), "->")
        edge((-0.5, -0.866025), (0, 0), "->")
    }))
    Hence a $1$-simplex is a correspondence
    #web-diagram(diagram(spacing: 20pt, {
        node((-0.5, -0.866025), [$Z$])
        node((-1, 0), [$X$])
        node((0, 0), [$Y$])
        edge((-0.5, -0.866025), (-1, 0), [$p$], label-side: right, "->")
        edge((-0.5, -0.866025), (0, 0), [$q$], label-side: left, "->")
    }))
    where $q in E$, representing a morphism $X->Y$. Similarly, $Q_2$ is
    #web-diagram(diagram(spacing: 20pt, {
        node((-0.5, -0.866025), [$(2,0)$])
        node((-1, 0), [$(1,0)$])
        node((-1.5, 0.866025), [$(0,0)$])
        node((-0.5, 0.866025), [$(1,1)$])
        node((0, 0), [$(2,1)$])
        node((0.5, 0.866025), [$(2,2)$])
        edge((-0.5, -0.866025), (-1, 0), "->")
        edge((-1, 0), (-1.5, 0.866025), "->")
        edge((-1, 0), (-0.5, 0.866025), "->")
        edge((-0.5, -0.866025), (0, 0), "->")
        edge((0, 0), (-0.5, 0.866025), "->")
        edge((0, 0), (0.5, 0.866025), "->")
    }))
    so a $2$-simplex is of form
    #web-diagram(diagram(spacing: 20pt, {
        node((-0.5, -0.866025), [$U$])
        node((-1, 0), [$V$])
        node((-1.5, 0.866025), [$X$])
        node((-0.5, 0.866025), [$Y$])
        node((0, 0), [$W$])
        node((0.5, 0.866025), [$Z$])
        edge((-0.5, -0.866025), (-1, 0), "->")
        edge((-1, 0), (-1.5, 0.866025), "->")
        edge((-1, 0), (-0.5, 0.866025), "->", stroke: color.hsl(240deg, 153, 153))
        edge((-0.5, -0.866025), (0, 0), "->",stroke: color.hsl(240deg, 153, 153))
        edge((0, 0), (-0.5, 0.866025), "->")
        edge((0, 0), (0.5, 0.866025), "->", stroke: color.hsl(240deg, 153, 153))
    }))
    where the central square is Cartesian and the highlighted arrows lie in $E$. In particular,
    $ U simeq V times_Y W. $
]

#theorem(title:[Liu--Zheng])[
    The simplicial set $Corr(cal(C),E)$ is a quasicategory ($oo$-category).
]

#proof(title:[Proof sketch])[
    Denote $K=Corr(cal(C),E)$. By #HTT[Corollary 2.3.2.2], it suffices to show that restriction is a trivial Kan fibration:
    $ r:Fun(Delta^2,K)->Fun(Lambda^2_1,K). $

    Extend $Q$ by colimits. The description of its simplices gives
    $ Q(S)=colim_(Delta^n->S) Q_n, quad Q(S)_s simeq S_(2s+1). $
    Thus $Q$ preserves products and monomorphisms. Set
    $ A=Q(Lambda^2_1), quad B=Q(Delta^2)=A^triangle.l. $
    For an $E$-admissible diagram $F:A->cal(C)$, fill the cone vertex by
    $ tilde(F)(2,0) simeq F(1,0) times_(F(1,1)) F(2,1). $
    This pullback exists; its right leg lies in $E$ by base change and composition.

    Let $cal(D) subset Fun(A,cal(C))$ consist of diagrams admitting limits, and $cal(L) subset Fun(B,cal(C))$ of limit cones, both full subcategories. By the dual of #HTT[Proposition 4.3.2.15], restriction is a trivial Kan fibration:
    $ p:cal(L)->cal(D). $
    This makes the construction work in families, relative to prescribed limit cones.

    Indeed, for $m>=0$, set
    $ R &= Q(partial Delta^m), \
      T &= (partial Delta^m times Delta^2) union_(partial Delta^m times Lambda^2_1) (Delta^m times Lambda^2_1). $
    By adjunction, a map $T->K$ gives
    $ (R times B) union_(R times A) (Q_m times A) -> cal(C). $
    The boundary data are limit cones. Lifting along $p$ extends this to
    $ G:Q_m times B -> cal(C). $
    Pullback pasting preserves the Cartesian condition; base change and composition preserve the $E$-condition. Hence $G$ gives a filler
    $ Delta^m times Delta^2 -> K. $
    Thus $r$ has all boundary lifts, and $K$ is a quasicategory.
]

== Symmetric Monoidal Structure

#claim[
    If $cal(C)$ admits finite products, then $Corr(cal(C),E)$ is a symmetric monoidal $oo$-category.
]

#construction(title:[Tensor product of correspondences])[
    Let $ast$ be a terminal object of $cal(C)$. Define
    $ X tens X' := X times X', quad bold(1) := ast. $
    For correspondences
    $ f=(X <-^p Z ->^q Y), quad f'=(X' <-^(p') Z' ->^(q') Y'), $
    set
    $ f tens f' = (X times X' <--^(p times p') Z times Z' -->^(q times q') Y times Y'). $
    For $q,q' in E$, factor
    $ Z times Z' -->^(q times "id") Y times Z' -->^("id" times q') Y times Y'. $
    Both arrows are base changes, hence $q times q' in E$ by composition.

    For $n$-simplices, define pointwise
    $ (F tens F')(i,j) = F(i,j) times F'(i,j). $
    Products preserve pullbacks, and
    $ (Z times_Y W) times (Z' times_(Y') W')
      simeq (Z times Z') times_(Y times Y') (W times W'). $
    Hence the tensor product preserves Cartesian diagrams and commutes with composition.

    Finally, products induce
    $ (X tens Y) tens Z &simeq X tens (Y tens Z), \
      bold(1) tens X &simeq X simeq X tens bold(1), \
      X tens Y &simeq Y tens X. $
    Their higher coherences are inherited from products in $cal(C)$. This gives the symmetric monoidal structure $Corr(cal(C),E)^tens$; see #link("https://arxiv.org/html/2412.20548v2#S4.SS1")[Chowdhury, Proposition 4.1.12].
]

#pagebreak(weak: true)

== Six-Functor Formalisms

Assume from now on that $cal(C)$ admits finite products.

#definition(title:[3-Functor Formalism])[
    A _3-functor formalism_ (abbrev. 3FF) is a lax symmetric monoidal functor
    $ Dcat : Corr(cal(C),E)^tens -> Cat_oo^times. $
]

The three operations are recovered as follows.

#construction(title:[Functor $f^*$ / pullback])[
    For $f:X->Y$, set
    $ iota^*(f) := (Y <--^f X -->^("id") X). $
    This gives the canonical functor and its composite
    $ iota^* : cal(C)^opp -> Corr(cal(C),E), quad Dcat^* := Dcat compose iota^*. $
    For composable $f,g$, we obtain
    $ f^*:Dcat(Y)->Dcat(X), quad (g compose f)^* simeq f^* compose g^*. $
    This is the _pullback fuctor_ determined by $f$.
]

#construction(title:[Functor $f_!$ / exceptional pushforward])[
    Let $cal(C)_E subset cal(C)$ contain all objects and only morphisms in $E$. For $f:X->Y$ in $E$, set
    $ iota_!(f) := (X <--^("id") X -->^f Y). $
    Similarly, we have
    $ iota_! : cal(C)_E -> Corr(cal(C),E), quad Dcat_! := Dcat compose iota_!. $
    For composable $f,g in E$, we obtain
    $ f_!:Dcat(X)->Dcat(Y), quad (g compose f)_! simeq g_! compose f_!. $
    This is the _exceptional pushforward functor_ or _!-pushforward functor_ determined by $f$. 
]

#construction(title:[Bifunctor $- tens -$ / tensor product])[
    The lax symmetric monoidal structure gives the external product
    $ times.square_(X,Y) : Dcat(X) times Dcat(Y) -> Dcat(X times Y). $
    Using the diagonal $Delta_X : X -> X times X$ and by the pullback functor we've already defined, we obtain the tensor product
    $ M tens_X N := Delta_X^*(M times.square_(X,X) N). $
    Its unit is
    $ bold(1)_X=p_X^* bold(1)_ast, quad p_X:X->ast, $
    where $bold(1)_ast$ comes from the lax unit map. The diagonal and terminal map induce the coherent symmetric monoidal structure on $Dcat(X)$. This is the _internal tensor product_ on $Dcat(X)$.
]

#definition(title:[6-Functor Formalism])[
    A _6-functor formalism_ (abbrev. 6FF) is a 3FF $Dcat : Corr(cal(C),E)^tens -> Cat_oo^times$ such that:

    +   For all $f$ in $cal(C)$, the pullback functor $f^*$ admits a right adjoint $f_*$. This is the _pushforward functor_ determined by $f$.
    +   For all $f$ in $E$, the exceptional pushforward functor $f_!$ admits a right adjoint $f^!$. This is the _exceptional pullback functor_ determined by $f$.
    +   For all $X in cal(C)$ and $A in Dcat(X)$, the internal tensor product $- tens_X A$ admits a right adjoint $Hom_X (A,-)$. This is the _internal Hom functor_ on $Dcat(X)$.
]

#remark[
    This definition does NOT implies that $f_! simeq f_*$ and $f^! simeq f^*$ if $f in E$. But if $f$ is an equivalence it helds.
]

#proposition[
    If $f$ is an equivalence, then $f_! simeq f_*$ and $f^! simeq f^*$.
]

#proof[
    Let $g:Y->X$ be an inverse of $f:X->Y$. In $Corr(cal(C),E)$,
    $ (X <--^("id") X -->^f Y) simeq (X <--^g Y -->^("id") Y). $
    Thus $f_! simeq g^* simeq (f^*)^(-1)$. By uniqueness of right adjoints,
    $ f_* simeq g^* simeq f_!, quad f^! simeq f^*. $
]

== Stable Presentable 6FF

#remark[
    From now on we denote $Cat^"st,ex"_oo$ to be the $oo$-category of all stable $oo$-categories with morphisms being exact functors.
]

#remark[
    We are not using the Lurie tensor product on $Cat^"st,ex"_oo$ in this case, instead using the Cartesian product, hence the symmetric monoidal structure is denoted as $(Cat^"st,ex"_oo)^times$.
]

#definition(title:[Stable 3FF])[
    A _stable 3-functor formalism_ (abbrev. stable 3FF) is a lax symmetric monoidal functor
    $ Dcat : Corr(cal(C),E)^tens -> (Cat^"st,ex"_oo)^times. $
]

#remark[
    Correspondence
    $ X <--^p W -->^q Y, quad q in E $
    in $Corr(cal(C),E)$ is corresponding to the functor
    $ q_! p^* : Dcat(X) -> Dcat(Y) $
    in $Cat^"st,ex"_oo$.
]

And a _stable 6FF_ is basically a stable 3FF with the right adjoints $f_*,f^!$ and $Hom_X (A,-)$, which are all exact functors.

#definition(title:[Stable Presentable 3FF])[
    A _stable presentable 3-functor formalism_ (abbrev. stable presentable 3FF) is a lax symmetric monoidal functor
    $ Dcat : Corr(cal(C),E)^tens -> (PrL_"st")^times.o. $
]

And a _stable presentable 6FF_ is basically a stable presentable 3FF with the right adjoints $f_*,f^!$ and $Hom_X (A,-)$, which are all exact functors.

#remark[
    There exists a canonical forgetful monoidal functor
    $ U : (PrL_"st")^times.o -> (Cat^"st,ex"_oo)^times.o $
    so this makes sense to say that a stable presentable 6FF is a stable 6FF, and a stable presentable 3FF is a stable 3FF.
]

#claim[
    The theories we are going to develop in #note-ref("02 Basic Theory", <chap-basic-theory>)[Basic Theory] are all valid for stable 6FF and stable presentable 6FF.
]

The following is pretty obvious since that's how $PrL_"st"$ works.

#claim[
    Stable presentable 3FF $<==>$ Stable presentable 6FF.
]
