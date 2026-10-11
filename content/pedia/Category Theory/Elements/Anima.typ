#import "../../../template.typ": *

#show: note

= Definition

Write $sSet$ for the category of #pedia("Simplicial Set")[simplicial sets].

#definition(title: [Weak Equivalence])[
    A map $f: X -> Y$ of simplicial sets is a _weak equivalence_ if its geometric realization induces a bijection on $pi_0$ and isomorphisms on every $pi_n$, $n >= 1$, at every base point. Write $W$ for these maps.
] <weak-equivalence>

#definition(title: [Anima])[
    The #pedia("Infinity Category")[$oo$-category] of _anima_ (spaces, or homotopy types) is the $oo$-categorical localization
    $ Ani := sSet[W^(-1)]. $
    Every anima is represented by a #pedia("Kan Complex")[Kan complex]. The localization retains mapping spaces and higher homotopies.
] <definition>
