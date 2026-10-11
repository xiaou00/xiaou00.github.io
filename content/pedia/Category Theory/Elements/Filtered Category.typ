#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Filtered Category])[
    An #pedia("Infinity Category")[$oo$-category] $I$ is _filtered_ if every diagram $p: K -> I$ from a finite #pedia("Simplicial Set")[simplicial set] extends to a cocone
    $ p': K^triangle.r -> I. $
    Here $K^triangle.r$ adjoins a cone point receiving arrows from $K$. The empty diagram is included, so $I$ is nonempty.
] <definition>

#definition(title: [Cofiltered Category])[
    An $oo$-category $I$ is _cofiltered_ if $I^opp$ is filtered. Equivalently, every finite diagram $K -> I$ extends to a cone $K^triangle.l -> I$, with arrows from the new cone point to $K$.
] <cofiltered>

#remark[
    For small $I$, filteredness is equivalent to $I$-indexed #pedia("Limit", <colimit>)[colimits] in #pedia("Anima")[$Ani$] commuting with finite limits.

    For an infinite regular cardinal $kappa$, replacing finite by $kappa$-small gives _$kappa$-filtered_ and _$kappa$-cofiltered_. Here $kappa$-small means fewer than $kappa$ nondegenerate simplices; the usual case is $kappa = omega$.
] <cardinal-variant>
