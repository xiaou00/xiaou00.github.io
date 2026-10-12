#import "../../../template.typ": *

#show: note

Fix a #pedia("Correspondence Category", <setup>)[geometric setup] $(cal(C),E)$ with finite products.

= Definition

#definition(title: [Three-Functor Formalism])[
    A _three-functor formalism_ (3FF) is a lax symmetric monoidal functor
    $ Dcat:Corr(cal(C),E)^tens -> Cat_oo^times. $
    It assigns a category $Dcat(X)$ to each $X$, functors to correspondences, and coherent external products
    $ times.square:Dcat(X) times Dcat(Y) -> Dcat(X times Y). $
] <definition>

Here _lax symmetric monoidal_ means a #pedia("Infinity Operad", <morphisms>)[map of the associated operads]: the product and unit maps need not be equivalences.

= The Three Operations <operations>

For $f:X -> Y$, the correspondence $Y <-^f X ->^(id) X$ gives
$ f^*:Dcat(Y) -> Dcat(X). $
For $f in E$, the correspondence $X <-^(id) X ->^f Y$ gives
$ f_!:Dcat(X) -> Dcat(Y). $
Consequently, a general span $X <-^p Z ->^q Y$ acts by $q_! p^*$.

The diagonal and terminal map give the internal tensor product and unit:
$ A tens_X B := Delta_X^*(A times.square B), quad bold(1)_X := p_X^* bold(1)_*, $
where $p_X:X -> *$ and $bold(1)_*$ comes from the lax unit. Thus each $Dcat(X)$ is symmetric monoidal and every $f^*$ is symmetric monoidal.

= Stable and Presentable Versions <stable>

A 3FF is _stable_ if every $Dcat(X)$ is a stable $oo$-category, the functors $f^*,f_!$ are exact, and external products are exact in each variable. Stable categories have a zero object and finite limits and colimits, with pullback squares exactly the pushout squares; exact functors preserve these.

== Presentable Version <presentable>

It is _stable presentable_ if the categories are also presentable, $f^*,f_!$ preserve colimits, and external products preserve colimits separately. Equivalently, it is a lax symmetric monoidal functor
$ Dcat:Corr(cal(C),E)^tens -> (PrL_"st")^tens. $
Here the target uses the tensor product of presentable stable categories, which represents functors preserving colimits in each variable. Presentable means accessible and admitting all small colimits.

Taking right adjoints gives a #pedia("Six-Functor Formalism")[six-functor formalism]; in the stable presentable case these adjoints exist automatically.
