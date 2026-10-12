#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Recollement])[
    A _recollement_ of stable $oo$-categories is a diagram
    $ cal(A) ->^(i_*) cal(B) ->^(j^*) cal(E) $
    with adjoint triples
    $ i^* tack.l i_* tack.l i^!, quad j_! tack.l j^* tack.l j_*, $
    such that $i_*,j_!,j_*$ are fully faithful and
    $ "im"(i_*) = ker(j^*) := {F in cal(B) : j^* F simeq 0}. $
] <definition>

Thus objects of $cal(A)$ identify with objects of $cal(B)$ vanishing after restriction to $cal(E)$.

= Localization Sequences

#proposition[
    Every $F in cal(B)$ fits into natural fiber-cofiber sequences
    $ j_! j^* F -> F -> i_* i^* F, $
    $ i_* i^! F -> F -> j_* j^* F. $
    The arrows are the adjunction counits and units.
] <localization>

#proof[
    The cofiber of the first arrow and the fiber of the last arrow vanish under $j^*$, hence lie in the image of $i_*$. Applying $i^*$ and $i^!$, respectively, identifies them with $i_* i^* F$ and $i_* i^! F$.
]

= Local Six-Functor Formalisms

Suppose a #pedia("Nagata Six-Functor Formalism")[Nagata setup] has an initial object $emptyset$ and a specified notion of open immersions with closed complements. Write such a decomposition as
$ Z ->^i X <-^j U, quad i in P, quad j in I, quad U times_X Z simeq emptyset. $
The complement structure is additional data on the setup.

#definition(title: [Local Stable Nagata Formalism])[
    A stable presentable Nagata 6FF is _local_ if $Dcat(emptyset) simeq 0$ and every open-closed decomposition gives a recollement
    $ Dcat(Z) ->^(i_*) Dcat(X) ->^(j^*) Dcat(U). $
] <local>

Here $i_! simeq i_*$ and $j^! simeq j^*$. After applying global sections, the second localization sequence identifies #pedia("Cohomology with Supports")[cohomology with supports] as
$ Gamma_Z (X,K) simeq Gamma(X,i_* i^! K). $
Applying pushforward with proper support to the first gives the localization sequence for #pedia("Compactly Supported Cohomology")[compactly supported cohomology].
