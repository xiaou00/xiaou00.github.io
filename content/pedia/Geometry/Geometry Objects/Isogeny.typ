#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Isogeny])[
    Let $A,B$ be #pedia("Abelian Variety")[abelian varieties] over a field $k$. An _isogeny_ $f: A -> B$ is a surjective homomorphism of $k$-group schemes whose scheme-theoretic kernel is finite over $k$.
] <definition>

#remark[
    Here scheme-theoretic kernel means
    $ ker f = A times_(B,e_B) Spec k $
]

#definition(title: [Degree of an Isogeny])[
    The _degree_ of an isogeny $f: A -> B$ is its #pedia("Degree of Morphisms", <definition>)[degree as a morphism of integral schemes].
] <degree>

#remark[
    Since $f$ is finite locally free, this also equals
    $ deg f = h^0(ker f, cal(O)_(ker f)), $
    the length over $k$ of its scheme-theoretic kernel.
] <kernel-length>

= Elliptic Curves

#proposition[
    Let $(E,e)$ and $(E',e')$ be #pedia("Elliptic Curve")[elliptic curves] over a field $k$. A $k$-morphism $f: E -> E'$ is an isogeny if and only if it is nonconstant and $f(e) = e'$.

    Equivalently, an isogeny is a nonzero homomorphism of elliptic curves.
] <elliptic-curves>

#proof[
    A morphism preserving the origins is automatically a group homomorphism, by the #pedia("Rigidity Lemma", <homomorphisms>)[rigidity lemma]. A nonconstant morphism between smooth proper curves is finite and surjective, so its scheme-theoretic kernel is finite. The converse follows from the definition.
]

#proposition(title: [Tate Modules])[
    Let $f: E -> E'$ be an isogeny of degree $d$ and $ell != char(k)$ a prime. On #pedia("Tate Module")[Tate modules], $T_ell f$ is injective with finite cokernel killed by $d$, and
    $ V_ell f: V_ell E ->^simeq V_ell E'. $
    If $ell$ does not divide $d$, then $T_ell f$ is also an isomorphism. All maps are Galois equivariant.
] <tate-modules>

#proof[
    The #pedia("Dual Isogeny", <dual-identities>)[dual identities] give
    $ (T_ell hat(f)) compose (T_ell f) = d id, quad (T_ell f) compose (T_ell hat(f)) = d id. $
    Since Tate modules are finite free, these imply injectivity and a finite cokernel killed by $d$. Inverting $d$ gives the inverse $d^(-1) T_ell hat(f)$.
]

= Special Isogenies

== Multiplication Isogenies

#claim(title:[Isogenies $[n]$])[
    Let $(A,e)$ be an abelian variety over a field $k$, then
    $ [n]: A -> A, quad a |-> n a $
    is an isogeny for any nonzero integer $n$. 
]

#remark[
    For $n != 0$, the kernel of $[n]$ is the finite #pedia("Torsion Point", <n-torsion>)[torsion subgroup scheme]
    $ A[n] := ker([n]: A -> A). $
    For any field extension $ell/k$, its points are $A[n](ell) = {a in A(ell) : n a = e}$.
]

#proposition(title: [Multiplication Laws])[
    For integers $m,n$, the multiplication endomorphisms of $A$ satisfy
    $ [0]_A = 0, quad [1]_A = id_A, quad [-n]_A = -[n]_A, $
    $ [m+n]_A = [m]_A + [n]_A, quad [m n]_A = [m]_A compose [n]_A. $
    Here addition is pointwise, and $0$ denotes the constant map to $e$.

    Every homomorphism $f: A -> B$ of abelian varieties commutes with multiplication:
    $ f compose [n]_A = [n]_B compose f. $
] <multiplication-laws>

For elliptic curves, see also the #pedia("Dual Isogeny", <duality-laws>)[duality laws].
