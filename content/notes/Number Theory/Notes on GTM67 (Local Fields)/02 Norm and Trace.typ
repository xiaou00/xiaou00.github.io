#import "../../../template.typ" : *
#import "@preview/fletcher:0.5.8" : *

#show:note

= Norm and Trace

== Definition

We now define the norm and trace of an element in a finite field extension:

#definition(title:[Norm])[
  Suppose $ell/k$ is a finite field extension with degree $n$, since $ell$ is an $n$-dimensional vector space over $k$, consider the multiplication map
  $ m_x : ell -> ell, quad y |-> x y $
  which is $k$-linear, define the _norm_ of $x$ to be the determinant
  $ Nm_(ell/k) (x) := det_k (m_x) $
]

#definition(title:[Trace])[
  Similarly, we define the _trace_ of $x$ to be the trace of the linear map $m_x$:
  $ Tr_(ell/k) (x) := tr_k (m_x) $
]

Both of the construction have same form

#web-diagram(diagram(spacing: 24pt, {
	node((-1, 1), [$ell$])
	node((0, 1), [$"End"_k (ell)$])
	node((1, 1), [$k$])
	edge((0, 1), (1, 1), [$det$], label-side: left, "->", bend: 36deg)
	edge((0, 1), (1, 1), [$tr$], label-side: right, "->", bend: -36deg)
	edge((-1, 1), (0, 1), [$x|->m_x$], label-side: right, "->")
}))

here view $End_k (ell)$ as a $k$-algebra.

#example[
  Consider $k = QQ$ and $ell = QQ(i)$, then take any $z = a + b i$ with $a, b in QQ$, and take the basis $1, i$ of $ell$ over $k$, since
  $ m_z (1) = a + b i, quad m_z (i) = -b + a i $
  the matrix is
  $ M_x = mat(a,-b; b,a) $
  then we have
  $ Nm_(ell/k) (a + b i) = det M_x = a^2 + b^2 \
    Tr_(ell/k) (a + b i) = tr M_x = 2 a $
]

== Characterization when Separable

#theorem(title:[Primitive Element Theorem])[
  Suppose $ell/k$ is a finite separable field extension, then there exists an element $alpha in ell$ such that $ell = k(alpha)$.
]

#proof[
  We skip the proof here since this should be a standard result in basic algebra.
]

#remark(title:[A standard fact in algebra])[
  Every $k$-morphism $sigma : ell -> overline(k)$ determined uniquely by $sigma(alpha)$, where $ell = k(alpha)$ by the primitive element theorem, denote $m_alpha in k[x]$ the minimal polynomial of $alpha$ over $k$. We conclude that
  $ m_alpha (sigma(alpha)) = sigma(m_alpha (alpha)) = 0 $
  conversely, every root $beta in overline(k)$ of $m_alpha$ gives a unique $k$-morphism
  $ sigma_beta (f(alpha)) = f(beta) $
  since $m_alpha$ is separable, we have $n$ distinct roots in $overline(k)$, thus we have $n$ distinct $k$-morphisms from $ell$ to $overline(k)$, i.e.
  $ abs(Hom_k (ell, overline(k))) = n = [ell:k] $
  more generally, for any finite $ell/k$, we have
  $ abs(Hom_k (ell, overline(k))) = [ell:k]_s <= [ell:k] $
  where $[ell:k]_s$ is the _separable degree_ of $ell/k$.
]

#theorem[
  Suppose $ell/k$ is a finite separable field extension with degree $n$, then
  $
  Nm_(ell/k) (x) = product_(sigma in Hom_k (ell, overline(k))) sigma(x) \
  Tr_(ell/k) (x) = sum_(sigma in Hom_k (ell, overline(k))) sigma(x)
  $
]

#proof[
  Separability immediately gives a $overline(k)$-algebra isomorphism
  $ ell times.o_k overline(k) simeq product_(sigma in Hom_k (ell, overline(k))) overline(k) $
  the multiplication map $m_x$ is sent to the diagonal operator
  $ "diag"(sigma_1 (x), ..., sigma_n (x)) $
  via the isomorphism, thus completing the proof.
]

== Characterization when Galois

When $ell/k$ is Galois, we have a more explicit characterization of the norm and trace, since in this case, we have $Hom_k (ell, overline(k)) = Gal(ell/k)$, thus we have

#theorem[
  Suppose $ell/k$ is a finite Galois field extension, then
  $
  Nm_(ell/k) (x) = product_(sigma in Gal(ell/k)) sigma(x) \
  Tr_(ell/k) (x) = sum_(sigma in Gal(ell/k)) sigma(x)
  $
]

== Characteristic Polynomial

#definition(title:[Characteristic Polynomial])[
  Suppose $ell/k$ is a finite field extension, then the _characteristic polynomial_ of $x in ell$ is defined to be
  $ chi_(x,ell/k) (t) := det(t dot I - M_x) $
]

#claim[
  When $ell/k$ is separable, we have
  $ chi_(x,ell/k) (t) = product_sigma (t - sigma(x)) $
  where $sigma$ runs over all $k$-morphisms from $ell$ to $overline(k)$.
]

#remark[
  By expanding the product, we have
  $ chi_(x,ell/k) (t) = t^n - Tr_(ell/k) (x) t^(n-1) + ... + (-1)^n Nm_(ell/k) (x) $
  thus the norm and trace can be read off from the characteristic polynomial.
]

== Property Checklist

#proposition[
  The trace $Tr_(ell/k) : ell^+ -> k^+$ is a $k$-linear map, such that $Tr_(ell/k)(a) = n a$ for any $a in k$.
]

#proposition[
  The norm $Nm_(ell/k) : ell^times -> k^times$ is a group homomorphism, such that $Nm_(ell/k)(a x) = a^n Nm_(ell/k)(x)$ and $Nm_(ell/k)(a) = a^n$ for any $a in k^times$.
]

= Norm and Trace in $A$-$k$-$ell$-$B$ setup

== Integral Elements under Norm and Trace

#theorem[
  Assuming $A$-$k$-$ell$-$B$ setup, the norm and trace preserve integrality, i.e. if $x in B subset ell$, then $Nm_(ell/k)(x) in A subset k$ and $Tr_(ell/k)(x) in A subset k$.
]

#proof[
  Since $x in B$, $x$ is integral over $A$, and every $k$-morphism $sigma : ell -> overline(k)$ fixes $A$, thus $sigma(x)$ is integral over $A$, and
  $ Nm_(ell/k)(x) = product_sigma sigma(x), quad Tr_(ell/k)(x) = sum_sigma sigma(x) $
  are integral over $A$ since the set of integral elements over $A$ is closed under multiplication and addition. On the other hand, $Nm_(ell/k)(x), Tr_(ell/k)(x) in k$, since $A$ is integrally closed in $k$, we conclude that $Nm_(ell/k)(x), Tr_(ell/k)(x) in A$.
]

#remark[
  This allows us to define the restricted norm and trace maps
  $ Nm_(B/A) : B -> A, quad Tr_(B/A) : B -> A $
]

#remark[
  Even for schemes, e.g.
  $ pi : Y = Spec B -> X = Spec A $
  we can define the norm and trace maps
  $ Nm_(Y/X) : pi_*cal(O)_Y -> cal(O)_X \
    Tr_(Y/X) : pi_*cal(O)_Y -> cal(O)_X $
]

#theorem(title:[Valuation Formula])[
  We have
  $ v_(frak(p))(Nm_(ell/k)(x)) = sum_(frak(q)_i divides frak(p)) f_i v_(frak(q)_i)(x) $
]

#proof[
  By the Smith normal form on a DVR, we have
  $ v_(frak(p))(Nm_(ell/k)(x)) = lg_(A_(frak(p))) (B times.o_A A_(frak(p))/ x dot B times.o_A A_(frak(p)))\
    = sum_(frak(q)_i divides frak(p)) lg_(A_(frak(p))) (B_(frak(q)_i)/x dot B_(frak(q)_i)) $
  since $B_(frak(q)_i)$ is a DVR, we have
  $ lg_(B_(frak(q)_i)) (B_(frak(q)_i)/x dot B_(frak(q)_i)) = v_(frak(q)_i)(x) $
  each $kappa(frak(q)_i)$ have length $f_i$ as an $A_(frak(p))$-module, thus we have
  $ v_(frak(p))(Nm_(ell/k)(x)) = sum_i f_i v_(frak(q)_i)(x) $
]

== Ideal Norm

#remark[
  We write $"Div"(R)$ as the set of nonzero fractional ideals via correspondence
  $ product_i frak(p)_i^(n_i) <-> sum_i n_i [frak(p)_i] $
  where
]

#definition(title:[Ideal Norm])[
  We define the _ideal norm_ $Nm_(B/A) : Div(B) -> Div(A)$. For $frak(q) divides frak(p)$ define
  $ Nm_(B/A)(frak(q)) = frak(p)^(f(frak(q)/frak(p))) $
  extended multiplicatively to all nonzero fractional ideals
  $ Nm_(B/A)lr((product_i frak(q)_i^(n_i))) = product_i Nm_(B/A)(frak(q)_i)^(n_i) = product_i frak(p)_i^(n_i f_i), quad frak(p)_i = frak(q)_i inter A $
]

#remark[
  In fact, this is exactly the same as the pushfoward of divisors under the finite morphism $Spec B -> Spec A$. See #note-ref("./01 Dedekind Extensions.typ",<prop-pushforward-divisor>)[this proposition].
]

#claim[
  Taking norm is the same as pushing forward cycles. More precisely, we have
  $ f_* "div"_B (x) = "div"_A (Nm_(B/A)(x)) $
]

#theorem[
  The ideal norm compatible with the element norm, i.e. for any $x in B$, we have
  $ Nm_(B/A)((x)) = (Nm_(ell/k)(x)) $
]

#proof[
  For all nonzero prime ideal $frak(p) ideal A$, the $frak(p)$-idex of the LHS is
  $ v_(frak(p))(Nm_(B/A)((x))) = sum_(frak(q)_i divides frak(p)) f_i v_(frak(q)_i)(x) $
  by the valuation formula, which is exactly the $frak(p)$-index of the RHS, thus we conclude that
  $ Nm_(B/A)((x)) = (Nm_(ell/k)(x)) $
]

== Trace Pairing

#definition(title:[Trace Pairing])[
  Define the _trace pairing_ to be the bilinear map
  $
  chevron.l -,- chevron.r_Tr : ell times ell &-> k \
  (x,y) &|-> Tr_(ell/k)(x y)
  $
  which is a symmetric $k$-bilinear form on $ell$.
]
