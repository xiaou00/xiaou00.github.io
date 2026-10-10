#import "../../../template.typ": *

#show: note

= Definition

== Classical Schemes <classical>

#definition(title: [Proper Morphism])[
    A morphism of schemes $f: X -> S$ is _proper_ if it is:

    + of finite type,
    + separated, and
    + universally closed.

    See #Stack("01W1").
] <classical-proper>

== Derived and Spectral Geometry <derived>

#definition(title: [Proper Morphism])[
    A morphism $f: X -> S$ of derived schemes or spectral algebraic spaces is _proper_ if
    $ t_0 f: t_0 X -> t_0 S $
    is classically proper.
] <derived-proper>

#remark[
    Some conventions additionally require $f$ to be almost of finite presentation; this condition is not included here.
] <finiteness-convention>
