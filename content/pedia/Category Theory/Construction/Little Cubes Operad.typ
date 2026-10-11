#import "../../../template.typ": *

#show: note

= Definition

Fix $n >= 1$ and put $I = (0,1)$. A _little $n$-cube_ is an embedding
$ c: I^n -> I^n, quad c(x_1,dots,x_n) = (a_1 x_1+b_1,dots,a_n x_n+b_n), $
with $a_i > 0$ and $0 <= b_i <= 1-a_i$: a translation and positive rescaling in each coordinate.

#definition(title: [Little Cubes Operad])[
    The _little $n$-cubes operad_ $cal(C)_n$ has as its space of $r$-ary operations the ordered configurations
    $ cal(C)_n (r) := {(c_1,dots,c_r) : c_i (I^n) inter c_j (I^n) = emptyset " for " i != j}, $
    where each $c_i$ is a little $n$-cube. Give this space the subspace topology on its coefficients in $RR^(2n r)$.

    The symmetric group $Sigma_r$ acts by permuting the cubes. Composition inserts configurations inside cubes:
    $ gamma((c_i);(d_(i,j))) := (c_i compose d_(i,j))_(i,j), $
    for $(d_(i,1),dots,d_(i,k_i)) in cal(C)_n (k_i)$, with the output ordered first by $i$, then by $j$.

    The unit is $id_(I^n) in cal(C)_n (1)$, and $cal(C)_n (0) = *$ is the empty configuration.
] <definition>

See #link("https://www.math.uchicago.edu/~may/BOOKS/geom_iter.pdf#page=21")[May, Definition 4.1].

= As an Infinity Operad

Form a topological category $cal(C)_n^tens$ with objects the #pedia("Active and Inert Morphisms", <finite-pointed-sets>)[finite pointed sets] $⟨r⟩$, for $r >= 0$. Over a pointed map $f: ⟨r⟩ -> ⟨s⟩$, its morphism space is
$ Map_(cal(C)_n^tens)^f (⟨r⟩,⟨s⟩) := product_(j=1)^s cal(C)_n (abs(f^(-1)({j}))). $
The full mapping space is the disjoint union over $f$. Each output $j$ receives cubes labelled by $f^(-1)({j})$ in increasing order; inputs sent to $*$ are discarded. Compose by inserting cubes, retaining the original input labels. The projection to $Fin_*$ forgets the cubes.

#definition(title: [Little Cubes Infinity Operad])[
    The _little $n$-cubes #pedia("Infinity Operad")[$oo$-operad]_ is
    $ p: bb(E)_n^tens := Ner^"hc" ("Sing" cal(C)_n^tens) -> Ner(Fin_*). $
    Here $"Sing"$ replaces each mapping space by its singular #pedia("Kan Complex")[Kan complex], whose $q$-simplices are continuous maps from the topological $q$-simplex. The symbol $Ner^"hc"$ denotes the homotopy-coherent nerve of this simplicial category.
] <infinity-operad>

#pedia("Active and Inert Morphisms", <inert>)[Inert maps] have coCartesian lifts given by identity cubes. The product formula gives the mapping-space and Segal conditions. The $r$-ary operation space is the homotopy type of $cal(C)_n (r)$. See #HA[Definition 5.1.0.2 and Proposition 5.1.0.3].
