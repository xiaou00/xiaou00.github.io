#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Pregeometry])[
    A _pregeometry_ is an #pedia("Infinity Category")[$oo$-category] $cal(T)$ with finite products, a class $E$ of _admissible morphisms_, and a Grothendieck topology $tau$, satisfying:

    + $E$ contains all equivalences and is closed under composition and retracts in $Fun(Delta^1,cal(T))$.
    + For $u:U -> X$ in $E$ and any $Y -> X$, the pullback exists and $U times_X Y -> Y$ lies in $E$.
    + For composable $f,g$, if $g,g compose f in E$, then $f in E$.
    + Every covering sieve contains a covering family of admissible arrows.
] <definition>

A family is a _cover_ when the sieve it generates is covering. The data $(E,tau)$ form an _admissibility structure_.

= Structures

#definition(title: [$cal(T)$-Structure])[
    On an #pedia("Infinity Topos")[$oo$-topos] $cal(X)$, a _$cal(T)$-structure_ is a #pedia("Functor")[functor] $cal(O):cal(T) -> cal(X)$ which:

    + preserves finite products;
    + preserves pullback squares along admissible morphisms;
    + sends each admissible cover ${U_i -> U}$ to an effective epimorphism
      $ product.co_i cal(O)(U_i) -> cal(O)(U). $
] <structure>

An _effective epimorphism_ is a map whose target is the colimit of its Čech nerve.

See #link("https://people.math.harvard.edu/~lurie/papers/DAG-V.pdf")[Lurie, DAG V, Definitions 1.2.1, 3.1.1, and 3.1.4].
