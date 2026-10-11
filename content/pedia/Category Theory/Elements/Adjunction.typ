#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Adjunction])[
    For #pedia("Functor")[functors] $F: cal(C) -> cal(D)$ and $G: cal(D) -> cal(C)$, an _adjunction_ $F ⊣ G$ is a family of bijections
    $ Hom_(cal(D))(F(X),Y) simeq Hom_(cal(C))(X,G(Y)), $
    natural in $X in cal(C)$ and $Y in cal(D)$. We call $F$ a _left adjoint_ of $G$, and $G$ a _right adjoint_ of $F$.
] <definition>

#example(title: [Free and Forgetful Functors])[
    Let $F: Set -> Grp$ send a set $S$ to the free group on $S$, and let $U: Grp -> Set$ forget the group structure. Then $F ⊣ U$:
    $ Hom_(Grp)(F(S),H) simeq Hom_(Set)(S,U(H)). $
    Every function $S -> U(H)$ extends uniquely to a group homomorphism $F(S) -> H$.
] <free-forgetful>

= Infinity Categories

#definition(title: [Adjunction of Infinity Categories])[
    For #pedia("Functor", <infinity>)[functors] $F: cal(C) -> cal(D)$ and $G: cal(D) -> cal(C)$ of #pedia("Infinity Category")[$oo$-categories], an _adjunction_ $F ⊣ G$ is a natural equivalence of mapping spaces
    $ Map_(cal(D))(F(X),Y) simeq Map_(cal(C))(X,G(Y)). $
    Naturality is an equivalence of functors $cal(C)^opp times cal(D) -> Ani$, where #pedia("Anima")[$Ani$] is the $oo$-category of anima. Thus it includes all higher homotopies.
] <infinity>
