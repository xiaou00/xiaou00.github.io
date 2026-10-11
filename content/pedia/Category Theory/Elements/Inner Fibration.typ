#import "../../../template.typ": *
#import "@preview/fletcher:0.5.8": *

#show: note

= Definition

#definition(title: [Inner Fibration])[
    A map $p: cal(E) -> cal(B)$ of #pedia("Simplicial Set")[simplicial sets] is an _inner fibration_ if every commutative square below admits a lift, for $n >= 2$ and $0 < i < n$:

    #web-diagram(diagram(spacing: 32pt, {
        node((0, 0), [$Lambda_i^n$])
        node((1, 0), [$cal(E)$])
        node((0, 1), [$Delta^n$])
        node((1, 1), [$cal(B)$])
        edge((0, 0), (1, 0), [$u$], "->")
        edge((0, 0), (0, 1), "->")
        edge((1, 0), (1, 1), [$p$], "->")
        edge((0, 1), (1, 1), [$v$], "->")
        edge((0, 1), (1, 0), [$tilde(u)$], "..>")
    }))

    Here $Lambda_i^n subset Delta^n$ is the union of all faces except the $i$th. The lift satisfies $tilde(u)|_(Lambda_i^n) = u$ and $p compose tilde(u) = v$. This is the _right lifting property_ for inner horn inclusions. See #HTT[Definition 2.0.0.3].
] <definition>

#remark(title: [Meaning])[
    An inner horn specifies part of a compositional diagram in $cal(E)$. Its filler must lie over the prescribed simplex in $cal(B)$. For $n=2$, this lifts a specified composition triangle; higher dimensions include its coherences.

    If $cal(B)$ is an #pedia("Infinity Category")[$oo$-category], so is $cal(E)$. Each fiber $cal(E)_b := cal(E) times_(cal(B)) {b}$ is also an $oo$-category. In particular, $cal(E) -> *$ is an inner fibration exactly when $cal(E)$ is an $oo$-category.
] <meaning>

#remark[
    Every functor from an $oo$-category to the #pedia("Nerve")[nerve] of an ordinary category is an inner fibration: the filler in the target is uniquely determined by its inner horn.
] <ordinary-base>
