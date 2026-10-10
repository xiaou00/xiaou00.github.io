#import "../../../template.typ": *

#show: note

We fix $cal(C)$ to be a cateogry with finite coproducts.

= Definitions

#definition(title:[Connected Object])[
    An object $X in cal(C)$ is called _connected_ if the functor
    $ Hom_(cal(C))(X,-) : cal(C)^opp -> Set $
    preserve finite coproducts, i.e.
    $ Hom(X,Y) cop Hom(X,Z) -->^~ Hom(X,Y cop Z) $
    is a natural isomorphism for all objects $Y,Z in cal(C)$, and $Hom(X,nothing)=nothing$.
]

Now suppose $cal(C)$ has a terminal object $1$ and have finite products.

#definition(title:[Universally Connected Object])[
    An object $X in cal(C)$ is called _universally connected_ if the functor
    $ X times - : cal(C) -> cal(C) $
    preserve connected objects, i.e. if $Y in cal(C)$ is connected, then so is $X times Y$.
]

= Scheme-Theoretic Examples

#claim[
    In $Sch$, connected objects are exactly schemes whose underlying Zariski topological space is connected.
]

#remark[
    In $Sch$, irreducible schemes are connected, but the converse is not true. For example, the scheme $Spec k[x,y]/(x y)$
    #implicit-plot(
        (x,y) => x*y,
    )
    which is the union of two lines in the affine plane, is connected but not irreducible.
]

#definition(title:[Geometrically Connected])[
    An $S$-scheme $X/S$ is called _geometrically connected_ if forall $s in S$, the fiber
    $ X_(overline(s)) = X times_S Spec overline(kappa(s)) $
    is nonempty and connected. i.e. forall geometric point
    $ overline(s) : Spec Omega -> S $
    the fiber $X_(overline(s))$ is connected.
]

#remark[
    The reason we introduce the notion of geometrically connected schemes is that connectedness is not preserved under base change. For example, $X = Spec CC$ over $RR$ is connected since it is a point, but
    $ X_CC := Spec CC times_(Spec RR) Spec CC = Spec CC cop Spec CC $
    is not connected since it is the disjoint union of two points.
]

#proposition[
    In $Sch/k$, universally connected objects are exactly geometrically connected schemes.
]

#proof[
    #Stack("0385")
]
