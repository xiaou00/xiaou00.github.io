#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Galois Category])[
    A _Galois category_ is an essentially small ordinary category $cal(C)$ with a _fiber functor_ $omega: cal(C) -> Fin$ such that:

    + $cal(C)$ has finite limits and finite colimits.
    + Every object is a finite, possibly empty, coproduct of connected objects.
    + $omega$ preserves finite limits and finite colimits and reflects isomorphisms.

    Here _connected_ means noninitial with no subobjects except itself and the initial object.
] <definition>

The fiber functor is faithful: if $omega(f) = omega(g)$, preservation of equalizers and reflection of isomorphisms force $f = g$.

= Fundamental Group and Reconstruction

#definition(title: [Fundamental Group])[
    The _fundamental group_ is the natural automorphism group
    $ pi_1 (cal(C),omega) := Aut(omega). $
    Give it the subspace topology in $product_(A in cal(C)) Aut(omega(A))$, using a small skeleton and finite discrete permutation groups. Naturality defines a closed subgroup, so it is #pedia("Profinite Group")[profinite].
] <fundamental-group>

#theorem(title: [Galois Reconstruction])[
    Put $G = pi_1 (cal(C),omega)$. The natural action $g dot a := g_A (a)$ gives an equivalence
    $ cal(C) ->^simeq Fin_G^"cont", quad A |-> omega(A), $
    where the target consists of finite sets with continuous $G$-action. Connected objects correspond to transitive actions.
] <reconstruction>

See #Stack("0BMQ"). The fiber functor is pro-represented by the #pedia("Fundamental Pro-Object")[fundamental pro-object]; #pedia("Galois Object")[Galois objects] describe the finite quotients.

= Basic Examples

For connected pointed $X in Ani$, the category #pedia("Covering Space", <finite>)[$FCov(X)$] with $omega_x(Y) = Y_x$ is Galois. Its group is the profinite completion
$ pi_1 (FCov(X),omega_x) simeq hat(pi_1 (X,x)) := varprojlim(N) pi_1 (X,x)/N, $
over normal finite-index subgroups $N$. This follows from #pedia("Covering Space Classification")[finite monodromy].

For a field $k$, take the opposite category of finite étale $k$-algebras (finite products of finite separable extensions $ell/k$), with $omega(A) = Hom_(k"-alg")(A,k^sep)$. Its fundamental group is $Gal(k^sep/k)$. For a connected scheme, the same construction with finite étale covers defines its #pedia("Etale Fundamental Group")[étale fundamental group].
