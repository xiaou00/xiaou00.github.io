#import "../../../template.typ" : *
#import "@preview/fletcher:0.5.8" : *

#show:note

= The Galois Action on Prime Ideals

== Constructing the Galois Action

Still we fix an $A$-$k$-$ell$-$B$-$G$ setup, requiring $ell/k$ is finite Galois, and $G = Gal(ell/k)$.

#lemma[
  For all $sigma in G$, we have $sigma(B) = B$.
]

#proof[
  $b in B$ implies $b$ is integral over $A$, meaning there existsa monic
  $ P(t) = t^n + a_(n-1) t^(n-1) + ... + a_0 in A[t] $
  suct that $P(b) = 0$, since $sigma|_A = id_A$, apply $sigma$ to $P(b) = 0$ gives $P(sigma(b)) = 0$, so $sigma(b)$ is integral over $A$, hence $sigma(b) in B$, also since $b$ is arbitrary, we have $sigma(B) subset B$. The same argument holds for $sigma^(-1)$, hence $sigma(B) = B$.
]

#remark[
  This lemma shows that the Galois group $G$ acts on $B$ through $A$-algebra automorphisms
  $ G -> Aut_(CAlg_A)(B) $
]

#claim[
  The previous group homomorphism is an isomorphism of groups, hence $G simeq Aut_(CAlg_A)(B)$. We also have $B^G = A$, this can be shown by
  $ B^G = B inter ell^G = B inter k = A $
]

== Acting On Ideals

#construction[
  Given an ideal $I ideal B$, define
  $ sigma(I) = { sigma(b) | b in I } $
  since $sigma : B -> B$ is an automorphism, $sigma(I)$ is also an ideal of $B$. Note that
  $ sigma(tau(I)) = (sigma tau)(I), quad 1_G (I) = I $
  We obtain a group action
  $ G act "Ideal"(B) $
]

#proposition[
  The previous action preserves the algebraic structure of ideals, precisely we have:

  + $sigma(I + J) = sigma(I) + sigma(J)$;
  + $sigma(I J) = sigma(I) sigma(J)$;
  + $sigma(I inter J) = sigma(I) inter sigma(J)$;
  + $sigma(I^n) = sigma(I)^n$;
  + $sigma(I : J) = sigma(I) : sigma(J)$;
  + $sigma(sqrt(I)) = sqrt(sigma(I))$;
  + For $frak(p) in Spec B$, $sigma(frak(p)) in Spec B$;
  + For $frak(m) in "Specm" B$, $sigma(frak(m)) in "Specm" B$.
]

#proof[
  The proof is left as an exercise to the reader.
]

We now identify some key features of the Galois action on prime ideals:

#proposition[
  Galois action preserves the fiber of prime ideals over a prime ideal in $A$. More precisely, for any $frak(q) in Spec B$, we have
  $ sigma(frak(q)) cap A = frak(q) cap A $
]

#proof[
  Since $sigma$ fix $A$, we have
  $ a in sigma(frak(q)) cap A <==> sigma^(-1)(a) in frak(q) <==> a in frak(q) cap A $
]

#construction[
  Now recall the construction of the fiber of a prime ideal
  $ F_(frak(p)) = Spec B times_(Spec A) Spec kappa(frak(p)) $
  set-theoretically, we have
  $ abs(F_(frak(p))) = { frak(q) in Spec B | frak(q) cap A = frak(p) } $
  this gives a $G$-set
  $ G act abs(F_(frak(p))) $
]

== Transitivity and Consequences

#theorem(title:[Transitivity of Galois Action])[
  The previous action is transitive, i.e. for all $frak(q)_1, frak(q)_2 divides frak(p)$ there exists $sigma in G$ such that $sigma(frak(q)_1) = frak(q)_2$.
]

#proof[
  We can give a proof using prime avoidance. Suppose $frak(q)_2$ is not contained in the orbit of $frak(q)_1$, then for all $sigma in G$, we have
  $ frak(q)_1 != sigma^(-1)(frak(q)_2) $
  since these are all maximal ideals over $frak(p)$, by prime avoidance, we can find an element $b in frak(q)_1$ such that
  $ b in.not sigma^(-1)(frak(q)_2), quad forall sigma in G $
  then consider the norm of $b$
  $ Nm_(ell/k)(b) = product_(sigma in G) sigma(b) in A $
  because $b in frak(q)_1$, this product belongs to $frak(q)_1$, causing
  $ Nm_(ell/k)(b) in frak(q)_1 cap A = frak(p) $
  meaning that $Nm_(ell/k)(b) in frak(q)_2$. But by the choice of $b$, we have $sigma(b) in.not frak(q)_2$ for all $sigma in G$, since $frak(q)_2$ is a prime ideal, this implies $product_(sigma in G) sigma(b) in.not frak(q)_2$, a contradiction.
]

Consider
$ frak(p)B = product_(i=1)^g frak(q)_i^(e_i) $
because $sigma$ fixes $frak(p)B$, we have
$ frak(p)B = sigma(frak(p)B) = product_(i=1)^g sigma(frak(q)_i)^(e_i) $
recall the unique factorization of ideals in a Dedekind domain, and the transitivity of the Galois action, we conclude that all $e_i$ are equal. On the other hand, the Galois action induce isomorphism of residue fields
$ kappa(frak(q)) simeq kappa(sigma(frak(q))) $
and fixing $frak(p)$, so all $f_i$ are equal, too. In summary, we claim

#claim[
  If $ell/k$ is a finite Galois extension, then for any $frak(p) in Spec A$, and any prime ideal $frak(q)_1, frak(q)_2 divides frak(p)$, we have
  $ e(frak(q)_1/frak(p)) = e(frak(q)_2/frak(p)), quad f(frak(q)_1/frak(p)) = f(frak(q)_2/frak(p)) $
  thus the fundamental equality becomes
  $ n = [ell : k] = e f g, quad e_1 = ... = e_g = e, quad f_1 = ... = f_g = f $
]

#corollary[
  For the Galois Dedekind $A$-$k$-$ell$-$B$-$G$ setup, we have
  $ abs(G) = e f g $
]

#proof[
  Recall that forall Galois extension $ell/k$, we have $[ell : k] = abs(G)$.
]

= Decomposition and Inertia

== The Decomposition Group

Since the Galois action on prime ideals is transitive, we can fix one of the $frak(q) divides frak(p)$ and 

#definition(title:[Decomposition Group])[
  Define the _decomposition group_ of $frak(q)$ over $frak(p)$ to be
  $ D_(frak(q)) = "Stab"_G (frak(q)) = { sigma in G : sigma(frak(q)) = frak(q) } $
  this is a subgroup of $G$, not always normal.
]

#remark[
  Using the orbit-stabilizer theorem, we have canonical bijection between $G$-sets
  $ G/D_(frak(q)) simeq abs(F_(frak(p))), quad sigma D_q |-> sigma(frak(q)) $
  this immediately gives
  $ g = [G : D_(frak(q))] $
]

#corollary[
  $abs(D_(frak(q))) = e f$ since $abs(G) = e f g$ and $g = [G : D_(frak(q))]$.
]

== Localizing the Decomposition Group

We already know that $sigma(B) = B$ and $Gal(ell/k)$ acts on $B$ through $A$-algebra automorphisms, so we can localize the decomposition group to get a group action. First we observe that $sigma_(frak(q))$ induces a unique morphism of local rings
$ sigma_(frak(q)) : B_(frak(q)) -> B_(sigma(frak(q))), quad frac(b,s) |-> frac(sigma(b), sigma(s)) $
When $sigma(frak(q)) = frak(q)$, this is an automorphism of the local ring $B_(frak(q))$. Hence we get an action
$ D_(frak(q)) -> Aut_(A_(frak(p)))(B_(frak(q))) $
and similarly this morphism is an isomorphism of groups.

For $frak(p) in Spec A$, denote $B^((frak(p))) = B times.o_A A_(frak(p))$. Suppose $frak(q)_1,..., frak(q)_g$ are all the prime ideals of $B$ lying over $frak(p)$, then we have

#claim[
  $B^((frak(p)))$ is a semi-local ring with maximal ideals $frak(q)_1 B^((frak(p))),..., frak(q)_g B^((frak(p)))$. And the group homomorphism
  $ G -> Aut_(A_(frak(p)))(B^((frak(p)))) $
  is an isomorphism of groups, and
  $ lr((B^((frak(p)))))^G = A_(frak(p)) $
]

If we only consider one of the prime ideals $frak(q)_i$ gives the argument of decomposition group.

#theorem[
  Since $B_(frak(q))$ is a DVR, corresponding to a discrete valuation $v_(frak(q)) : ell^times -> ZZ$, we have
  $ D_(frak(q)) = { sigma in G : v_(frak(q)) compose sigma = v_(frak(q)) } $
]

#proof[
  This is because
  $
  sigma in D_(frak(q)) <==> sigma(B_(frak(q))) = B_(frak(q)) <==> v_(frak(q))(sigma(x)) = v_(frak(q))(x), quad forall x in ell^times
  $
]

#construction[
  Now we define the completion of the two following DVRs
  $
  hat(A_(frak(p))) = varprojlim(n) A_(frak(p))/frak(p)^n A_(frak(p)) \ 
  hat(B_(frak(q))) = varprojlim(n) B_(frak(q))/frak(q)^n B_(frak(q))
  $
  and take the fraction fields
  $
  k_(frak(p)) = "Frac"(hat(A_(frak(p)))), quad ell_(frak(q)) = "Frac"(hat(B_(frak(q))))
  $
  They are complete local fields.
]

#theorem(title:[Local Galois Correspondence])[
  There is a canonical isomorphism of groups
  $ D_(frak(q)) simeq Gal(ell_(frak(q))/k_(frak(p))) $
]

#proof[
  Since forall $sigma in D_(frak(q))$ we have $v_(frak(q))(sigma(x)) = v_(frak(q))(x)$, meaning $sigma$ is an isometry under the metric induced by the discrete valuation, extending uniquely to the completion
  $ hat(sigma) : ell_(frak(q)) -> ell_(frak(q)) $
  also $sigma$ fixes $k$, hence $hat(sigma)$ fixes $k_(frak(p))$, so we have a group injection
  $ D_(frak(q)) arrow.hook Gal(ell_(frak(q))/k_(frak(p))) $ 

  Conversely, every $k_(frak(p))$-automorphism sends elements in $ell$ to a root of its minimal polynomial over $k$, since $ell/k$ is regular, the roots of the minimal polynomial are all in $ell$, so the local automorphism belongs to $G$ after localization, also it preserves the valuation, hence it belongs to $D_(frak(q))$.
]

== The Inertia Group

We now study the structure of the decomposition group $D_(frak(q))$. Since $sigma in D_(frak(q))$ fixes $frak(q)$, it induces a automorphism of the residue field
$ overline(sigma) : kappa(frak(q)) -> kappa(frak(q)), quad b mod frak(q) |-> sigma(b) mod frak(q) $
This gives a group homomorphism
$ rho_(frak(q)) : D_(frak(q)) -> Aut_(kappa(frak(p)))(kappa(frak(q))), quad sigma |-> overline(sigma) $

#definition(title:[Interia Group])[
  The kernel of the previous group homomorphism is called the _inertia group_ of $frak(q)$ over $frak(p)$, denoted by
  $ I_(frak(q)) = ker(rho_(frak(q))) = { sigma in D_(frak(q)) : overline(sigma) = id } $
]

#corollary[
  Exists a short exact sequence of groups
  $ 1 -> I_(frak(q)) -> D_(frak(q)) -> Aut_(kappa(frak(p)))(kappa(frak(q))) -> 1 $
  assuming $kappa(frak(q))/kappa(frak(p))$ is separable, by Galois residue field therem, this extension is Galois. Since
  $ abs(Gal(kappa(frak(q))/kappa(frak(p)))) = f(frak(q)/frak(p))=f $
  This gives $[D_(frak(q)):I_(frak(q))] = f$, while $abs(D_(frak(q))) = e f$, hence $abs(I_(frak(q))) = e$, gives group-theoretical meaning to all of the three indices $e, f, g$ in the fundamental equality.
]
