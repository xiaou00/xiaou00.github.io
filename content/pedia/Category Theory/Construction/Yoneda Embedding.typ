#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Yoneda Embedding])[
    For a locally small #pedia("Category")[category] $cal(C)$, the _Yoneda embedding_ is the functor
    $ y: cal(C) -> Fun(cal(C)^opp,Set), quad X |-> h_X := Hom_(cal(C))(-,X). $
    A morphism $f: X -> Y$ induces $y(f): h_X -> h_Y$ by postcomposition:
    $ y(f)_T (g) := f compose g quad (g: T -> X). $
    Here $Fun(cal(C)^opp,Set)$ is the #pedia("Natural Transformation")[functor category].
] <definition>

By the #pedia("Yoneda Lemma", <yoneda>)[Yoneda lemma], $y$ is _fully faithful_: for all $X,Y$, the map
$ Hom_(cal(C))(X,Y) -> Nat(h_X,h_Y), quad f |-> y(f) $
is a bijection. In particular, $h_X simeq h_Y$ if and only if $X simeq Y$.

For the $oo$-categorical version, see #pedia("Infinity Yoneda", <embedding>)[Infinity Yoneda].
