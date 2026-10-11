#import "../../../template.typ": *

#show: note

= Operadic Definition

#definition(title: [Operadic Monoidal Category])[
    Let $cal(O)^tens$ be an #pedia("Infinity Operad")[$oo$-operad]. An _$cal(O)$-monoidal $oo$-category_ is a #pedia("Cocartesian Fibration")[coCartesian fibration]
    $ p: cal(C)^tens -> cal(O)^tens $
    whose composite with $cal(O)^tens -> Ner(Fin_*)$ is an $oo$-operad.
] <operadic>

#definition(title: [Monoidal Category])[
    A _monoidal $oo$-category_ is an $bb(E)_1$-monoidal $oo$-category, using the #pedia("Little Cubes Operad", <infinity-operad>)[little intervals operad] $bb(E)_1^tens$ to encode ordered multiplication.
] <definition>

#definition(title: [Symmetric Monoidal Category])[
    A _symmetric monoidal $oo$-category_ is a $"Comm"$-monoidal $oo$-category, where
    $ "Comm"^tens := Ner(Fin_*) $
    has the identity projection to $Ner(Fin_*)$.
] <symmetric>

= Tensor Product and Unit

In either case, let $cal(C)$ be the fiber over the unique color. The inert projections identify the fiber over a list of $r$ copies of that color with $cal(C)^r$. CoCartesian transport along binary and nullary operations gives
$ tens: cal(C) times cal(C) -> cal(C), quad bold(1) in cal(C). $
For $bb(E)_1$, choose two intervals ordered from left to right. Composition supplies coherent associativity and unit laws; $"Comm"$ also supplies symmetry. Ordinary monoidal categories are the case where the underlying mapping spaces are discrete.

See #HA[Definition 2.1.2.13, Example 2.1.2.18, and Example 5.1.0.7]. For objects carrying multiplication, see #pedia("Algebra").
