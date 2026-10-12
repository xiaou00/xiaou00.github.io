#import "../../../template.typ": *

#show: note

= The Small Étale Site

Let $X$ be a scheme. A morphism $U -> X$ is _étale_ if it is smooth of relative dimension zero; equivalently, it is flat, locally of finite presentation, and $Omega^1_(U/X) = 0$.

#definition(title: [Small Étale Site])[
    The _small étale site_ $X_et$ has étale morphisms $U -> X$ as objects and $X$-morphisms as arrows. Its covering families are jointly surjective families of étale morphisms $U_i -> U$.
] <site>

= The Small Étale Topos

#definition(title: [Small Étale Infinity Topos])[
    The _small étale $oo$-topos_ of $X$ is
    $ cal(X) := X_et^top := Shv(X_et,Ani). $
    Its objects are functors $F:X_et^opp -> Ani$ satisfying descent for étale covers, with all homotopies included. Its ordinary topos of 0-truncated objects is
    $ cal(X)_(<=0) simeq Shv(X_et,Set). $
] <definition>

This is an #pedia("Infinity Topos")[$oo$-topos] by sheafification. For a cover $U -> V$, descent says
$ F(V) simeq lim_([n] in Delta) F(U_n), quad U_n := underbrace(U times_V dots times_V U, n+1), $
with $U$ the disjoint union of the members of a covering family. The simplicial object on the right is the Čech nerve.

Write $Gamma_* F = Map_(cal(X))(1,F) simeq F(X)$ and $underline(K) = Gamma^* K$. We use ordinary sheaf descent here; imposing descent for all hypercovers gives the _hypercompletion_. This does not change truncated objects or the cohomology of abelian sheaves.

= Points and Finite Local Systems <geometric-point>

A _geometric point_ $overline(x):Spec Omega -> X$, with $Omega$ algebraically closed, induces a geometric morphism $overline(x):Ani -> cal(X)$. Its inverse image $overline(x)^* F = F_(overline(x))$ is the stalk, computed by the filtered colimit over pointed étale neighborhoods.

#definition(title: [Finite Locally Constant Object])[
    A 0-truncated object $F in cal(X)$ is _finite locally constant_ if, after an étale cover, it is a constant finite set. Write $LocSys_"fin" (cal(X))$ for their full subcategory.
] <finite-local-systems>

Representable sheaves identify
$ FEt/X simeq LocSys_"fin" (cal(X)), quad Y |-> Hom_X (-,Y), $
where $FEt/X$ consists of finite étale morphisms. Under this equivalence, $F_(overline(x))$ is the finite set $Hom_X (overline(x),Y)$.

These give the #pedia("Etale Fundamental Group")[étale fundamental group]. Taking global sections of abelian objects gives #pedia("Etale Cohomology")[étale cohomology], while the shape of $cal(X)$ gives the #pedia("Etale Homotopy Type")[étale homotopy type].
