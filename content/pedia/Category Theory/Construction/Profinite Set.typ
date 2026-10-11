#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Profinite Set])[
    Let $Fin$ be the category of finite sets. A _profinite set_ is an object of its #pedia("Pro Completion")[Pro-completion]
    $ ProFin := Pro(Fin). $
    Thus it is a formal cofiltered limit $X = varprojlim(i in I)^sharp X_i$ of finite sets.
] <definition>

#remark(title: [Topological Description])[
    Taking the #pedia("Projective Limit")[inverse limit] of the discrete spaces $X_i$ identifies $ProFin$ with the category of compact Hausdorff totally disconnected spaces and continuous maps. Such spaces are also called _Stone spaces_.
] <topology>
