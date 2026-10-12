#import "../../../template.typ": *

#show: note

Let $(cal(C),omega)$ be a #pedia("Galois Category")[Galois category].

= Definition

Let $I$ be the category of pairs $(A,a)$ with $A$ connected and $a in omega(A)$. A morphism to $(B,b)$ is $f:A -> B$ with $omega(f)(a) = b$. This category is #pedia("Filtered Category", <cofiltered>)[cofiltered]: in a finite limit, take the connected component containing the specified point.

#definition(title: [Fundamental Pro-Object])[
    The _fundamental pro-object_ is the formal limit
    $ P_omega := varprojlim((A,a) in I)^sharp A in Pro(cal(C)). $
    It pro-represents the fiber functor:
    $ Hom_(Pro(cal(C)))(P_omega,B) simeq omega(B). $
] <definition>

#proof[
    By the #pedia("Pro Completion", <mapping-spaces>)[pro-mapping formula], the left side is the filtered colimit of $Hom_(cal(C))(A,B)$, mapped to $omega(B)$ by $f |-> omega(f)(a)$. Every point lies in a connected component of $B$. Two representatives of the same point agree after refinement through the corresponding component of their fiber product over $B$.
]

= Galois Quotients

Restricting the limit to pointed #pedia("Galois Object")[Galois objects] gives the same pro-object. Under reconstruction, with $G = pi_1 (cal(C),omega)$, this is
$ P_omega simeq varprojlim(N)^sharp G/N, $
over open normal subgroups of $G$. Precomposition reverses composition, giving
$ pi_1 (cal(C),omega) simeq Aut_(Pro(cal(C)))(P_omega)^opp. $
