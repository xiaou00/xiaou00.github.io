#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Invariant Differential])[
    Let $f: G -> S$ be a #pedia("Smoothness")[smooth] group scheme with identity section $e: S -> G$. A relative $1$-form $eta in H^0(G, Omega^1_(G/S))$ is _left-invariant_ if
    $ L_g^* eta_T = eta_T $
    for every $S$-scheme $T$ and every $g in G(T)$, where $eta_T$ is the base change of $eta$ and $L_g: G_T -> G_T$ is left translation by $g$.

    The _sheaf of invariant differentials_ on $S$ is
    $ omega_(G/S) := e^* Omega^1_(G/S). $
] <definition>

#lemma(title: [#Stack("047I")])[
    Let $f: G -> S$ be a group scheme with identity section $e: S -> G$. There is a canonical isomorphism
    $ Omega^1_(G/S) simeq f^* e^* Omega^1_(G/S). $
    In particular, if $S = Spec k$ for a field $k$, then
    $ Omega^1_(G/k) simeq cal(O)_G times.o_k e^* Omega^1_(G/k). $
] <differentials>

#remark[
    Restriction along $e$ identifies left-invariant forms with $H^0(S, omega_(G/S))$: each section extends uniquely by left translation.
    For commutative $G$, left and right invariance agree.
]
