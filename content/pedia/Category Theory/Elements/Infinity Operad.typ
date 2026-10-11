#import "../../../template.typ": *

#show: note

An $oo$-operad encodes operations with finitely many inputs and one output, with composition and symmetry up to coherent homotopy.

= Prerequisites

Read #pedia("Nerve"), #pedia("Inner Fibration"), #pedia("Cartesian Fibration"), #pedia("Cocartesian Fibration"), and #pedia("Active and Inert Morphisms"). Write $⟨n⟩ = {*,1,dots,n}$ and let $rho^i: ⟨n⟩ -> ⟨1⟩$ select the $i$th slot.

= Definition

We use #HA[Definition 2.1.1.10 and Remark 2.1.1.14].

For $p: cal(O)^tens -> Ner(Fin_*)$, write $cal(O)^tens_(⟨n⟩)$ for its fiber over $⟨n⟩$, and put $cal(O) := cal(O)^tens_(⟨1⟩)$. Write $Map_(cal(O)^tens)^f (X,Y)$ for the space of arrows $X -> Y$ lying over a fixed base map $f$.

#definition(title: [Infinity Operad])[
    An _$oo$-operad_ is an inner fibration $p: cal(O)^tens -> Ner(Fin_*)$ satisfying:

    + *Inert lifts.* Every inert $f: ⟨m⟩ -> ⟨n⟩$ admits a $p$-coCartesian lift $X -> f_! X$ from each $X in cal(O)^tens_(⟨m⟩)$.

    + *Mapping spaces.* For any $f: ⟨m⟩ -> ⟨n⟩$, objects $X,Y$ over its endpoints, and coCartesian lifts $Y -> Y_j$ of $rho^j$, composition induces an equivalence
      $ Map_(cal(O)^tens)^f (X,Y) ->^simeq product_(j=1)^n Map_(cal(O)^tens)^(rho^j compose f) (X,Y_j). $

    + *Segal condition.* For every $n >= 0$, the inert projections induce an equivalence
      $ (rho^1_!,dots,rho^n_!): cal(O)^tens_(⟨n⟩) ->^simeq cal(O)^n. $
      For $n=0$, this means $cal(O)^tens_(⟨0⟩) simeq *$.
] <definition>

= Meaning and Operations

The objects of $cal(O)$ are _colors_; its arrows are unary operations. The Segal condition identifies objects over $⟨n⟩$ with lists of $n$ colors. Inert maps select entries, and the mapping-space condition separates an operation into one operation per output.

#definition(title: [Multimorphism Space])[
    Let $X$ represent $(X_1,dots,X_n)$ and let $mu_n: ⟨n⟩ -> ⟨1⟩$ send all inputs to $1$. For a color $Y$, define
    $ Mul_(cal(O))(X_1,dots,X_n;Y) := Map_(cal(O)^tens)^(mu_n) (X,Y). $
    This is the space of operations with inputs $X_1,dots,X_n$ and output $Y$.
] <operations>

Composition gives substitution of operations. For $n=0$, these are nullary operations, whose space may be empty even though the empty list is unique up to equivalence.
