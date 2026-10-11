#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Profinite Group])[
    Let $FGrp$ be the category of finite groups. A _profinite group_ is an object of the #pedia("Pro Completion")[Pro-completion]
    $ PFGrp := Pro(FGrp), quad G = varprojlim(i in I)^sharp G_i, $
    with $I$ small and cofiltered and each $G_i$ finite.
] <definition>

#remark(title: [Topological Description])[
    Taking the inverse limit of the finite discrete groups $G_i$ identifies $PFGrp$ with compact Hausdorff totally disconnected topological groups and continuous homomorphisms. In particular, the underlying space is a #pedia("Profinite Set")[profinite set].

    Such a group is recovered from its finite quotients:
    $ G simeq lim_(N) G/N, $
    where $N$ runs through the open normal subgroups, with the quotient maps as transition maps.
] <topology>
