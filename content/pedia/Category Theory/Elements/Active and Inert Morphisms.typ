#import "../../../template.typ": *

#show: note

= Finite Pointed Sets

#definition(title: [Finite Pointed Sets])[
    Write $Fin_*$ for the category of finite pointed sets and maps preserving the basepoint $*$. We use the representatives
    $ ⟨n⟩ := {*,1,dots,n}, quad n >= 0. $
    In particular, $⟨0⟩ = {*}$, and $⟨n⟩^∘ = {1,dots,n}$ is the set of non-basepoint elements. Its #pedia("Nerve")[nerve] $Ner(Fin_*)$ is the base of Lurie's #pedia("Infinity Operad")[$oo$-operads].
] <finite-pointed-sets>

View the non-basepoint elements as slots. A pointed map $f: ⟨m⟩ -> ⟨n⟩$ assigns each input to an output slot or sends it to $*$, discarding it.

= Inert and Active Maps

#definition(title: [Inert Morphism])[
    A pointed map $f: ⟨m⟩ -> ⟨n⟩$ is _inert_ if $f^(-1)({j})$ has exactly one element for each $1 <= j <= n$.

    It selects one distinct input for each output and discards the remaining inputs. The basic projections are
    $ rho^i: ⟨n⟩ -> ⟨1⟩, quad rho^i (i)=1, $
    with every other element sent to $*$, for $1 <= i <= n$.
] <inert>

#definition(title: [Active Morphism])[
    A pointed map $f: ⟨m⟩ -> ⟨n⟩$ is _active_ if
    $ f^(-1)({*}) = {*}. $
    Every input is used. Several inputs may enter the same output, and an output may have no inputs. In particular, active does not mean surjective.
] <active>

The fold $mu_n: ⟨n⟩ -> ⟨1⟩$, sending every non-basepoint element to $1$, is active, including $n=0$. It indexes an operation with $n$ inputs and one output. A map is both active and inert exactly when it is a pointed bijection. See #HA[Definitions 2.1.1.8 and 2.1.2.1].

= Factorization

#proposition(title: [Inert-Active Factorization])[
    Every pointed map $f: ⟨m⟩ -> ⟨n⟩$ factors as an inert map followed by an active map, uniquely up to unique isomorphism of the intermediate pointed set.

    Set $I := f^(-1)({1,dots,n})$ and $I_+ := I union {*}$, with a disjoint basepoint. The factorization is
    $ ⟨m⟩ -> I_+ -> ⟨n⟩. $
    The first map fixes $I$ and sends all other inputs to $*$; the second is the restriction of $f$. Thus one first discards unused inputs, then groups the remaining inputs by output.
] <factorization>
