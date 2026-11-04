#import "../../../template.typ" : *
#import "@preview/fletcher:0.5.8" : *

#show:note

#remark[
  We will skip the basics of DVR and dedekind domains in this note.
]

= Dedekind Extensions

== The $A$-$k$-$ell$-$B$ Setup

We first assume that $ell/k$ is a finite field extension (finite extension implies algebraic). $A$ is said to be a Noetherian integrally closed domain with $k$ as its field of fractions. $B$ is the integral closure of $A$ in $ell$, associated in the following diagram:

#web-diagram(diagram(spacing: 24pt, {
	node((-1, 0), [$k$])
	node((0, 0), [$ell$])
	node((-1, 1), [$A$])
	node((0, 1), [$B$])
	edge((-1, 0), (0, 0), "->")
	edge((-1, 1), (-1, 0), "->")
	edge((-1, 1), (0, 1), "->")
	edge((0, 1), (0, 0), "->")
}))

#claim[
  Assuming $A$-$k$-$ell$-$B$ setup, then if $ell/k$ is separable, then $B$ is a finitely generated $A$-module.
]

#claim[
  If $A$ is a Dedekind domain, then $B$ is also a Dedekind domain. In this case, we say that $B$ is a _Dedekind extension_ of $A$.
]

We denote $n = [ell:k]$ to be the degree of the field extension.

== Lying Over

=== Definitions

#definition(title:[Lying Over])[
  Given a Dedekind extension $A arrow.hook B$ and $frak(q) in Spec B$, we define the notion of _lying over_ as
  $ frak(q) divides frak(p) <==> frak(q) inter A = frak(p) $
  saying that $frak(q)$ lies over $frak(p)$.
]

#remark[
  By dualing to the geometric side, this gives a fintie surjection
  $ f : Spec B -> Spec A $
  the lying over is basically the fiber of $f$ over $frak(p)$, precisely the following fullback
  #web-diagram(diagram(spacing: 24pt, {
    import "@preview/fletcher:0.5.8": cetz
    let quiver-corner(mark) = cetz.draw.get-ctx(ctx => {
      let m = ctx.transform
      let angle = calc.atan2(m.at(0).at(0), m.at(1).at(0))
      let determinant = m.at(0).at(0) * m.at(1).at(1) - m.at(0).at(1) * m.at(1).at(0)
      let orientation = if determinant < 0 { -1 } else { 1 }
      let target = mark.angle + if mark.rev { 180deg } else { 0deg }
      cetz.draw.rotate((target - angle) * orientation)
      cetz.draw.line((135deg, mark.size), (0, 0), (225deg, mark.size))
    })
    node((-1, 1), [$"Spec" B$])
    node((0, 1), [$"Spec" A$])
    node((0, 0), [$"Spec" kappa(frak(p))$])
    node((-1, 0), [$F_frak(p)$])
    edge((-1, 1), (0, 1), [$f$], label-side: right, "->")
    edge((0, 0), (0, 1), [$frak(p)$], label-side: left, "->")
    edge((-1, 0), (0, 0), "->")
    edge((-1, 0), (-1, 1), "->")
    edge((-1, 0), (0, 1), marks: ((inherit: "straight", pos: 0, rev: true, size: 8, sharpness: 45deg, tip-origin: 0, tail-origin: 0, angle: 45deg, draw: quiver-corner, stroke: (cap: "round", join: "round")),), extrude: ())
  }))
  where set-theoretically
  $ abs(F_frak(p)) = {frak(q) in Spec B : frak(q) inter A = frak(p)} $
  while its also important to note that $F_frak(p)$ also carries a scheme structure.
]

=== Three Basic Theorems

The following theorems holds for the contidtion of _integral extension_ of rings, which is a more general condition than Dedekind extension.

#theorem(title:[Lying Over Theorem])[
  Suppose $A arrow.hook B$ is an integral extension of rings, then for any $frak(p) in Spec A$, there exists $frak(q) in Spec B$ such that $frak(q)$ lies over $frak(p)$, i.e. $f : Spec B -> Spec A$ is surjective.
]

#theorem(title:[Going Up Theorem])[
  Suppose $A arrow.hook B$ is an integral extension of rings, if $frak(p)_1 subset frak(p)_2$ and $frak(q)_1 divides frak(p)_1$, then there exists $frak(q)_2 in Spec B$ such that $frak(q)_1 subset frak(q)_2$ and $frak(q)_2 divides frak(p)_2$.
]

#theorem(title:[Going Down Theorem])[
  Suppose $A arrow.hook B$ is an integral extension of rings, and $A$ is integrally closed, if $frak(p)_1 subset frak(p)_2$ and $frak(q)_2 divides frak(p)_2$, then there exists $frak(q)_1 in Spec B$ such that $frak(q)_1 subset frak(q)_2$ and $frak(q)_1 divides frak(p)_1$.
]

#remark[
  Going up and going down theorems are basically claiming for the folling commutative diagram
  #web-diagram(diagram(spacing: 24pt, {
    node((-1, 0), [$frak(q)_1$])
    node((0, 0), [$frak(q)_2$])
    node((-1, 1), [$frak(p)_1$])
    node((0, 1), [$frak(p)_2$])
    edge((-1, 0), (0, 0), [$subset$], label-fill: false, label-angle: right, label-side: center, " ")
    edge((-1, 1), (0, 1), [$subset$], label-fill: false, label-angle: right, label-side: center, " ")
    edge((0, 0), (0, 1), "|->")
    edge((-1, 0), (-1, 1), "|->")
  }))
  if one of $frak(q)_1$ or $frak(q)_2$ is known, then the other one can be found.
]

#theorem(title:[Incomparability])[
  If $frak(q)_1$ and $frak(q)_2$ are two prime ideals in $Spec B$ lying over the same prime ideal $frak(p)$ in $Spec A$, if $frak(q)_1 subset frak(q)_2$, then $frak(q)_1 = frak(q)_2$.
]

The proof of the above theorems can be found in ordinary commutative algebra textbooks, so we will skip the proof here.

= The Three Indices

== The Partition of $frak(p) B$

We now assume a Dedekind $A$-$k$-$ell$-$B$ setup. Since $frak(p)B$ is a nonzero ideal of $B$, we obtain
$ frak(p)B = product_(i=1)^g frak(q)_i^(e_i) $
where $frak(q)_i$ are the distinct prime ideals, and $e_i$ are the corresponding multiplicities $>=1$. Note that for any $frak(q) in Spec B$
$ frak(q) divides frak(p) <==> frak(q) inter A = frak(p) <==> frak(p) B subset frak(q) <==> frak(q) = frak(q)_i quad "for some" i $
herre the second step is because any prime ideal of a Dedekind is maximal. Therefore set-theoretically
$ f^(-1)(frak(p)) = {frak(q)_1,...,frak(q)_g} $
where $g$ is said to be the _splitting number_ of $frak(p)$ in $B$.
Now recall the scheme-theoretic fiber $F_frak(p)$, we have
$ F_frak(p) = Spec B times_(Spec A) Spec kappa(frak(p)) $
since $A$ is Dedekind and $frak(p) != 0$, $frak(p)$ is maximal, hence $kappa(frak(p)) = A/frak(p)$. Thus we have
$ F_(frak(p)) simeq Spec (B times.o_A kappa(frak(p))) simeq Spec(B / frak(p)B) $
applying the primary decomposition and CRT, we have
$ Spec(B / frak(p)B) simeq Spec lr((B / product_(i=1)^g frak(q)^(e_i)_i)) simeq Spec product_(i=1)^g B/frak(q)^(e_i)_i simeq product.co_(i=1)^g Spec(B/frak(q)^(e_i)_i) $
where $e_i$ measures the order of vanishing of $frak(p)$ along $frak(q)_i$, and is called the _ramification index_ of $frak(q)_i$ over $frak(p)$, often denoted as $e(frak(q)_i/frak(p))$, or briefly $e_i$ if there is no ambiguity. 

=== Characterization using DVR

#proposition[
  Assume the Dedekind $A$-$k$-$ell$-$B$ setup, with
  $ frak(p)B = product_(i=1)^g frak(q)_i^(e_i) $
  Since $A_(frak(p))$ and $B_(frak(q)_i)$ are DVRs, and $pi.alt_(frak(p)), pi.alt_(frak(q)_i)$ are corresponding uniformizers, then
  $ pi.alt_(frak(p)) = u pi.alt_(frak(q)_i)^(e_i), quad u in B_(frak(q)_i)^times $
  via normalized valuations $v_(frak(p)):k^times->ZZ$ and $v_(frak(q)_i):ell^times->ZZ$, we have
  $ v_(frak(q)_i)(a) = e_i v_(frak(p))(a) quad forall a in k^times $
]

#proof[
  Fix $frak(q)_i$ and localize the previous equation at $frak(q)_i$ gives
  $ frak(p) B_(frak(q)_i) = product_(j=1)^g (frak(q)_j B_(frak(q)_i))^(e_j) $
  recall that any nonzero prime ideal of a DVR is maximal, hence
  $ frak(q)_j B_(frak(q)_i) = B_(frak(q)_i), quad j != i $
  thus $frak(p) B_(frak(q)_i) = frak(q)_i^(e_i) B_(frak(q)_i)$, and since $A_(frak(p))$ is a DVR, we can write $frak(p)A_(frak(p)) = (pi.alt_(frak(p)))$. Extending to $B_(frak(q)_i)$ gives $frak(p)B_(frak(q)_i) = (pi.alt_(frak(p)))$. $B$ is also a DVR, hence $frak(q)_i^(e_i) B_(frak(q)_i) = (pi.alt_(frak(q)_i)^(e_i))$, thus $(pi.alt_(frak(p)))=(pi.alt_(frak(q)_i)^(e_i))$. In a integral domain, two principal ideals are equal if and only if their generators differ by a unit, gives the desired result.

  Recalling the definition of normalized valuation gives the last statement.
]

#proposition[
  Assume the Dedekind $A$-$k$-$ell$-$B$ setup, with $phi : Spec B -> Spec A$ the induced map, $frak(p)B = product_(i=1)^g frak(q)_i^(e_i)$, then the pullback divisor satisfies
  $ phi^* [frak(p)] = sum_(i=1)^g e_i [frak(q)_i] $
]

#proof[
  This is basically re-writing the correspondence between fractional ideals and divisors.
]

== The Residue Degree

Again we look at the Dedekind $A$-$k$-$ell$-$B$ setup, with $frak(p)B = product_(i=1)^g frak(q)_i^(e_i)$. For each $frak(q)_i divides frak(p)$, we have the following field extension $kappa(q_i) / kappa(frak(p))$ identified with
#web-diagram(diagram(spacing: 24pt, {
	node((-1, 1), [$A$])
	node((0, 1), [$B$])
	node((-1, 0), [$kappa(frak(p)) = A/frak(p)$])
	node((0, 0), [$kappa(frak(q)_i) =A/frak(q)_i$])
	edge((-1, 1), (0, 1), "->")
	edge((-1, 1), (-1, 0), "->")
	edge((-1, 0), (0, 0), "->")
	edge((0, 1), (0, 0), "->")
}))
Geometrically, this is the following fiber diagram
#web-diagram(diagram(spacing: 24pt, {
	node((-1, 1), [$"Spec" A$])
	node((0, 1), [$"Spec" B$])
	node((-1, 0), [$"Spec "kappa(frak(p))$])
	node((0, 0), [$"Spec" kappa(frak(q)_i)$])
	edge((0, 1), (-1, 1), [$f$], label-side: left, "->")
	edge((-1, 0), (-1, 1), "->")
	edge((0, 0), (-1, 0), "->")
	edge((0, 0), (0, 1), "->")
}))
define the _residue degree_ of $frak(q)_i$ over $frak(p)$ as
$ f_i = f(frak(q)_i/frak(p)) = [kappa(frak(q)_i) : kappa(frak(p))] $
this is gauranteed to be finite since $B$ is a finitely generated $A$-module.

#proposition[
  Assume the Dedekind $A$-$k$-$ell$-$B$ setup, with $phi : Spec B -> Spec A$ the induced map, $frak(p)B = product_(i=1)^g frak(q)_i^(e_i)$, then the pushfoward divisor satisfies
  $ phi_* [frak(q)_i] = f_i [frak(p)] $
] <prop-pushforward-divisor>

#proof[
  This is actually the definition of pushforward of divisors (algebraic cycles).
]

#theorem(title:[The Fundamental Identity])[
  Assume the Dedekind $A$-$k$-$ell$-$B$ setup, we have
  $ sum_(i=1)^g e_i f_i = [ell:k] = n $
] <thm-fundamental-identity>

#proof(title:[Proof via divisors])[
  Recall that for finite flat morphism $phi : X -> Y$, push-pulling divisors satisfies $phi_* phi^* D = deg(phi) D$ for any divisor $D$ on $Y$. Applying this to the divisor $[frak(p)]$ gives
  $ phi_* phi^* [frak(p)] = sum_(i=1)^g e_i phi_* [frak(q)_i] = lr((sum_(i=1)^g e_i f_i)) [frak(p)] = deg(phi) [frak(p)] $
  thus
  $ sum_(i=1)^g e_i f_i = deg(phi) = [ell:k] = n $
]

