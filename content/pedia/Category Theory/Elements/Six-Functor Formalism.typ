#import "../../../template.typ": *

#show: note

All functors and tensor products are understood at the derived level; we omit $"L"$ and $"R"$ prefixes.

= Definition

#definition(title: [Six-Functor Formalism])[
    A _six-functor formalism_ (6FF) is a #pedia("Three-Functor Formalism")[3FF] for which the three operations admit right #pedia("Adjunction", <infinity>)[adjoints]:
    $ f^* tack.l f_*, quad f_! tack.l f^!, quad (- tens_X A) tack.l Hom_X (A,-). $
    The first pair exists for every $f:X -> Y$, the second for $f in E$, and the third for every $A in Dcat(X)$.
] <definition>

The directions and meanings are:

#table(
    columns: (auto, auto, 1fr),
    table.header([Operations], [Direction], [Meaning]),
    [$f^*,f^!$], [$Dcat(Y) -> Dcat(X)$], [Pullback, exceptional pullback],
    [$f_*,f_!$], [$Dcat(X) -> Dcat(Y)$], [Pushforward, exceptional pushforward],
    [$tens_X,Hom_X$], [Internal to $Dcat(X)$], [Tensor product, internal Hom],
)

Internal Hom is an object of $Dcat(X)$, characterized by
$ Map_(Dcat(X))(C,Hom_X (A,B)) simeq Map_(Dcat(X))(C tens_X A,B). $
Adjoints are unique up to a contractible choice, so their coherent composition laws are inherited from the 3FF.

For composable $X ->^f Y ->^g Z$,
$ (g compose f)^* simeq f^* g^*, quad (g compose f)_* simeq g_* f_*, $
$ (g compose f)_! simeq g_! f_!, quad (g compose f)^! simeq f^! g^!, $
with the last two formulas requiring $f,g in E$.

= Automatic Adjoints

#proposition[
    Every stable presentable 3FF is a 6FF. All six operations are exact in each of their covariant variables; internal Hom is exact contravariantly in its first variable.
] <presentable>

#proof[
    The functors $f^*,f_!$ and $- tens_X A$ preserve colimits between presentable categories, hence admit right adjoints. In stable categories, these left and right adjoints are exact.
]

An abstract 6FF gives #pedia("Six-Functor Identities")[base change, projection, Künneth and duality identities]. The identifications $p_! simeq p_*$ for proper maps and $j^! simeq j^*$ for open immersions belong to the additional #pedia("Nagata Six-Functor Formalism")[Nagata structure]. For an equivalence $f$, both identifications already follow from the abstract definition.

For geometric applications, see #pedia("Recollement")[localization] and #pedia("Compactly Supported Cohomology")[compactly supported cohomology].
