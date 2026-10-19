#import "../../template.typ": *
#import "@preview/fletcher:0.5.8": diagram, node, edge

#show: note

We use the notation and definitions from #note-ref("01 Basic Definitions", <chap-basic-definitions>)[Basic Definitions].

= Basic Theory <chap-basic-theory>

== Base Change (Beck--Chevalley) Theorem

#theorem(title:[Beck--Chevalley Theorem])[
    Suppose
    $ Dcat : Corr(cal(C),E)^times.o -> Cat^times_oo, $
    the forall cartesian square
    #web-diagram(diagram(spacing: 22pt, {
        import "@preview/fletcher:0.5.8": cetz
        let quiver-corner(mark) = cetz.draw.get-ctx(ctx => {
            let m = ctx.transform
            let angle = calc.atan2(m.at(0).at(0), m.at(1).at(0))
            let determinant = m.at(0).at(0) * m.at(1).at(1) - m.at(0).at(1) * m.at(1).at(0)
            let orientation = if determinant < 0 { -1 } else { 1 }
            let target = mark.angle + if mark.rev { 180deg } else { 0deg }
            cetz.draw.rotate((target - angle) * orientation)
            cetz.draw.line((135deg, mark.size), (0, 0), (225deg, mark.size))
        })
        node((-1, 0), [$X'$])
        node((-1, 1), [$Y'$])
        node((0, 0), [$X$])
        node((0, 1), [$Y$])
        edge((0, 0), (0, 1), [$f$], label-side: left, "->")
        edge((-1, 0), (-1, 1), [$f'$], label-side: right, "->")
        edge((-1, 0), (0, 0), [$g'$], label-side: left, "->")
        edge((-1, 1), (0, 1), [$g$], label-side: right, "->")
        edge((-1, 0), (0, 1), marks: ((inherit: "straight", pos: 0, rev: true, size: 8, sharpness: 45deg, tip-origin: 0, tail-origin: 0, angle: 45deg, draw: quiver-corner, stroke: (cap: "round", join: "round")),), extrude: ())
    }))
    with $f in E$, there's a canonical equivalence
    $ g^* f_! simeq f'_! g'^*. $
] <thm-base-change>

#remark[
    The abbreviation BCT agree with both Beck--Chevalley and Base Change Theorem, so why not use it?
]

#proof[
    By def, $f_!$ and $g^*$ corresponds to
    $ X <--^(id) X -->^f Y, quad Y <--^g Y' -->^(id) Y' $
    their composite corresponds to
    $ X <--^(pr_1) X times_Y Y' -->^(pr_2) Y', $
    where $pr_1,pr_2$ are the projections. Similarly, $g'^*$ and $f'_!$ corresponds to
    $ X <--^(g') X' -->^(id) X', quad X' <--^(id) X' -->^(f') Y' $
    their composite corresponds to
    $ X <--^(g') X' -->^(f') Y', $
    notice that $f' in E$ since $E$ is stable under base change. Now because the square is Cartesian, we have a canonical equivalence
    $ X' -->^~ X times_Y Y', $
    which obviously gives the desired equivalence.
]

== Künneth Formula

Let $times.square$ be the external product, we have

#theorem(title:[Künneth Formula I])[
    Suppose $f:X->X' in E$, $g:Y->Y' in E$ $A in Dcat(X)$, and $B in Dcat(Y)$. Then
    $ (f times g)_! (A times.square B) simeq f_! A times.square g_! B. $
] <thm-kunneth-exceptional-pushforward>

#theorem(title:[Künneth Formula II])[
    Suppose $f:X->X'$, $g:Y->Y'$ $A in Dcat(X)$, and $B in Dcat(Y)$. Then
    $ (f times g)^* (A times.square B) simeq f^* A times.square g^* B. $
] <thm-kunneth-pullback>

#theorem(title:[Künneth Formula III])[
    Suppose $f:X->X' in E$, $g:Y->Y' in E$ $A in Dcat(X)$, and $B in Dcat(Y)$. Then
    $ (f times g)^! (A times.square B) simeq f^! A times.square g^! B. $
] <thm-kunneth-exceptional-pullback>

#theorem(title:[Künneth Formula IV])[
    Suppose $f:X->X'$, $g:Y->Y'$ $A in Dcat(X)$, and $B in Dcat(Y)$. Then
    $ (f times g)_* (A times.square B) simeq f_* A times.square g_* B. $
] <thm-kunneth-pushforward>

These four formulas are all trivial corollaries of the naturality of lax symmetric monoidal functor $Dcat$. We have a useful lemma for the next Projection Formula.

#lemma[
    For $A in Dcat(X)$ and $B in Dcat(Y)$, we have
    $ A times.square_(X,Y) B simeq pr_X^* A times.o_(X,Y) pr_Y^* B. $ 
] <lemma-external-product>

#proof[
    By @thm-kunneth-pullback, for all $f:X'->X$, $g:Y'->Y$, we have
    $ (f times g)^*(A times.square B) simeq f^* A times.square g^* B $
    let $Z = X times Y$, $f = pr_X$ and $g = pr_Y$, then we have
    $ (pr_X times pr_Y)^*(A times.square B) simeq pr_X^* A times.square pr_Y^* B $
    then we can calculate
    $
    pr_X^* A times.o pr_Y^* B &simeq Delta^*_(X times Y) (pr_X^* A times.square pr_Y^* B) \
    &simeq Delta^*_(X times Y) (pr_X times pr_Y)^* (A times.square B) \
    &simeq ((pr_X times pr_Y) compose Delta_(X times Y))^* (A times.square B) \
    &simeq id^* (A times.square B) \
    &simeq A times.square B.
    $
]

== Projection Formula

#theorem(title:[Projection Formula])[
    Suppose $f:X->Y in E$, $A in Dcat(X)$, and $B in Dcat(Y)$. Then
    $ f_! (A tens_X f^* B) simeq f_! A tens_Y B. $
]

#remark[
    We sometimes write
    $ integral_f A := f_! A $
    and call it the _integration along $f$_, somehow makes sense due to the analogy with differential forms. There's some analogy between tensor product and product of functions, we somehow have a form of projection formula for functions, which looks like
    $ integral_f (A dot f^* B) simeq lr((integral_f A)) dot B $
]

Firstly we have the following characterization of the external product



#proof(title:[Proof of Projection Formula])[
    Consider
    #web-diagram(diagram(spacing: 24pt, {
        import "@preview/fletcher:0.5.8": cetz
        let quiver-corner(mark) = cetz.draw.get-ctx(ctx => {
            let m = ctx.transform
            let angle = calc.atan2(m.at(0).at(0), m.at(1).at(0))
            let determinant = m.at(0).at(0) * m.at(1).at(1) - m.at(0).at(1) * m.at(1).at(0)
            let orientation = if determinant < 0 { -1 } else { 1 }
            let target = mark.angle + if mark.rev { 180deg } else { 0deg }
            cetz.draw.rotate((target - angle) * orientation)
            cetz.draw.line((135deg, mark.size), (0, 0), (225deg, mark.size))
        })
        node((-1, 0), [$X$])
        node((0, 0), [$X times Y$])
        node((0, 1), [$Y times Y$])
        node((-1, 1), [$Y$])
        edge((-1, 1), (0, 1), [$Delta_Y$], label-side: right, "->")
        edge((-1, 0), (0, 0), [$Gamma_f$], label-side: left, "->")
        edge((-1, 0), (-1, 1), [$f$], label-side: right, "->")
        edge((0, 0), (0, 1), [$f times id_Y$], label-side: left, "->")
        edge((-1, 0), (0, 1), marks: ((inherit: "straight", pos: 0, rev: true, size: 8, sharpness: 45deg, tip-origin: 0, tail-origin: 0, angle: 45deg, draw: quiver-corner, stroke: (cap: "round", join: "round")),), extrude: ())
    }))
    Where $Gamma_f = (id_X,f)$. use @thm-base-change, we got
    $ f_! Gamma_f^* simeq Delta^*_Y (f times id_Y)_! $
    by @thm-kunneth-exceptional-pushforward, we have
    $ (f times id_Y)_! (A times.square B) simeq (f_! A) times.square B $
    by @lemma-external-product, we have 
    $
    f_! (A tens_X f^* B) &simeq f_! Gamma_f^* (A times.square B) \
    &simeq Delta^*_Y (f times id_Y)_! (A times.square B) \
    &simeq Delta^*_Y ((f_! A) times.square B) \
    &simeq f_! A tens_Y B.
    $
]

== Grothendieck--Verdier Duality

#theorem(title:[Grothendieck--Verdier Duality I])[
    Forall $f:X->Y in E$, $A in Dcat(X)$ and $B in Dcat(Y)$, we have a natural equivalence
    $ f_* Hom_X (A,f^! B) simeq Hom_Y (f_! A,B). $
] <thm-GV-duality-I>

#proof[
    Forall $C in Dcat(Y)$, we have
    $
    &Map_Y (C, f_* Hom_X (A,f^! B)) \
    simeq& Map_X (f^* C, Hom_X (A,f^! B))&quad "(by adjunction)" \
    simeq& Map_X (f^* C tens A, f^! B)&quad "(by adjunction)" \
    simeq& Map_Y (f_! (f^* C tens A), B)&quad "(by adjunction)" \
    simeq& Map_Y (C tens f_! A, B)&quad "(by projection formula)" \
    simeq& Map_Y (C, Hom_Y (f_! A,B))&quad "(by adjunction)" \
    $
    Hence by Yoneda lemma, we have
    $ f_* Hom_X (A,f^! B) simeq Hom_Y (f_! A,B). $
]

#theorem(title:[Grothendieck--Verdier Duality II])[
    Forall $f:X->Y in E$, $A in Dcat(X)$ and $B in Dcat(Y)$, we have a natural equivalence
    $ f^! Hom_Y (A,B) simeq Hom_X (f^* A,f^! B). $
] <thm-GV-duality-II>

#proof[
    Forall $C in Dcat(X)$, we have
    $
    &Map_X (C, f^! Hom_Y (A,B)) \
    simeq& Map_Y (f_! C, Hom_Y (A,B))&quad "(by adjunction)" \
    simeq& Map_Y (f_! C tens A, B)&quad "(by adjunction)" \
    simeq& Map_Y (f_! (C tens f^* A), B)&quad "(by projection formula)" \
    simeq& Map_X (C tens f^* A, f^! B)&quad "(by adjunction)" \
    simeq& Map_X (C, Hom_X (f^* A,f^! B))&quad "(by adjunction)" \
    $
    Hence by Yoneda lemma, we have
    $ f^! Hom_Y (A,B) simeq Hom_X (f^* A,f^! B). $
]
