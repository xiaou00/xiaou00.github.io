#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Category])[
    A _category_ $cal(C)$ consists of objects, morphisms with specified sources and targets, identities $id_X: X -> X$, and composites $g compose f: X -> Z$ for $f: X -> Y$ and $g: Y -> Z$.
    Composition is associative and identities act as units:
    $ h compose (g compose f) = (h compose g) compose f, $
    $ id_Y compose f = f = f compose id_X. $
    Morphisms from $X$ to $Y$ are denoted by $Hom_(cal(C))(X,Y)$. The category is _locally small_ if each such collection is a set.
] <definition>

#remark[
    The _opposite category_ $cal(C)^opp$ has the same objects, with arrows and composition reversed; thus $Hom_(cal(C)^opp)(X,Y) = Hom_(cal(C))(Y,X)$.
] <opposite>

For example, $Set$ is the category of sets and functions.
