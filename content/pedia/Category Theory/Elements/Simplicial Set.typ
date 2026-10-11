#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Simplicial Set])[
    A _simplicial set_ is a functor $X: Delta^opp -> Set$, where $Delta$ is the #pedia("Simplex")[simplex category]. These form $sSet := Fun(Delta^opp,Set)$.

    Elements of $X_n := X([n])$ are called _$n$-simplices_. The standard $n$-simplex is the representable $Delta^n := Hom_Delta (-,[n])$.
] <definition>
