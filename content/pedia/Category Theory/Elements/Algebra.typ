#import "../../../template.typ": *

#show: note

= General Operadic Algebras

#definition(title: [Algebra over an Operad])[
    For #pedia("Infinity Operad")[$oo$-operads] $cal(O)^tens$ and $cal(P)^tens$, an _$cal(O)$-algebra in $cal(P)$_ is a #pedia("Infinity Operad", <morphisms>)[morphism of operads]
    $ A: cal(O)^tens -> cal(P)^tens. $
    Thus $A$ lies over $Ner(Fin_*)$ and preserves inert arrows. Write
    $ "Alg"_(cal(O))(cal(P)) subset Fun_(Ner(Fin_*))(cal(O)^tens,cal(P)^tens) $
    for the full subcategory of these functors; morphisms are natural transformations over the base.
] <definition>

= In a Monoidal Category

#definition(title: [Relative Algebra])[
    Let $p: cal(C)^tens -> cal(B)^tens$ be a #pedia("Monoidal Category", <operadic>)[$cal(B)$-monoidal category], and fix an operad map $u: cal(O)^tens -> cal(B)^tens$. An _$cal(O)/cal(B)$-algebra_ is an operad map
    $ A: cal(O)^tens -> cal(C)^tens, quad p compose A = u. $
    These form the full subcategory $"Alg"_(cal(O)/cal(B))(cal(C))$ of functors over $cal(B)^tens$ that preserve inert arrows. For $u = id$, they are sections of $p$ preserving inert arrows.
] <relative>

#definition(title: [Associative Algebra])[
    In a monoidal category $p: cal(C)^tens -> bb(E)_1^tens$, an _associative algebra_ is such an operadic section. Write $"Alg"(cal(C))$ for their category.

    It specifies an object $A$ with
    $ mu: A tens A -> A, quad eta: bold(1) -> A, $
    together with coherent associativity and unit laws. In an ordinary monoidal category, these are the usual associative unital algebra axioms.
] <associative>

= Symmetric Monoidal Case

If $cal(C)$ is #pedia("Monoidal Category", <symmetric>)[symmetric monoidal], the canonical map $cal(O)^tens -> "Comm"^tens$ makes the relative definition agree with $"Alg"_(cal(O))(cal(C))$ above. Its operations take the form
$ Mul_(cal(O))(X_1,dots,X_r;Y) -> Map_(cal(C))(A(X_1) tens dots tens A(X_r),A(Y)), $
compatible with composition, units, and permutations, including all higher coherences. The empty tensor product is $bold(1)$. Commutative algebras form $"CAlg"(cal(C)) := "Alg"_("Comm")(cal(C))$.

See #HA[Definitions 2.1.2.7 and 2.1.3.1].
