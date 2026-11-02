#import "../../template.typ": *
#import "@preview/fletcher:0.5.8" :*

#show:note

= Setups

== $A$-$k$-$ell$-$B$ setup

A typical $A$-$k$-$ell$-$B$ setup is a square in $CAlg$ in form of

#web-diagram(diagram(spacing: 24pt, {
	node((1, 1), [$ell$])
	node((0, 1), [$k$])
	node((0, 0), [$A$])
	node((1, 0), [$B$])
	edge((0, 0), (0, 1), "->")
	edge((0, 1), (1, 1), "->")
	edge((1, 0), (1, 1), "->")
	edge((0, 0), (1, 0), "->")
}))

where $ell/k$ is a Galois extension, preferably finite. $A$ is a Dedekind domain with fraction field $k$, and $B$ is the integral closure of $A$ in $ell$.

== Geometric $A$-$k$-$ell$-$B$ setup

For the previous $A$-$k$-$ell$-$B$ setup, consider
$ frak(q) in Spec B, quad frak(p) = frak(q) inter A in Spec A $
gives a geometric $A$-$k$-$ell$-$B$ setup

#web-diagram(diagram(spacing: 24pt, {
	node((1, 1), [$"Spec" kappa(frak(q))$])
	node((0, 1), [$"Spec" kappa(frak(p))$])
	node((0, 0), [$"Spec" A$])
	node((1, 0), [$"Spec" B$])
	edge((0, 1), (0, 0), "->")
	edge((1, 1), (0, 1), "->")
	edge((1, 1), (1, 0), "->")
	edge((1, 0), (0, 0), "->")
}))

where $kappa(frak(q))$ is the residue field of $frak(q)$, and $kappa(frak(p))$ is the residue field of $frak(p)$. The extension $kappa(frak(q))/kappa(frak(p))$ is a Galois extension, and the Galois group $Gal(kappa(frak(q))/kappa(frak(p)))$ is a subquotient of $Gal(ell/k)$.

#remark[
  When we select the generic point $frak(q) = (0)$ in $Spec B$, we have $frak(p) = (0)$ in $Spec A$, and the residue fields are $kappa(frak(q)) = ell$ and $kappa(frak(p)) = k$. In this case, the Galois group $Gal(kappa(frak(q))/kappa(frak(p)))$ is exactly the Galois group $Gal(ell/k)$.
]

= Galois Group

== The Definition of Galois Group

The _Galois group_ is basically the group of squares in form

#web-diagram(diagram(spacing: 24pt, {
	node((0, 0), [$ell$])
	node((1, 0), [$ell$])
	node((0, 1), [$k$])
	node((1, 1), [$k$])
	edge((0, 1), (1, 1), [$id$], label-side: right, "->")
	edge((0, 0), (1, 0), [$sigma$], label-side: left, "->")
	edge((1, 1), (1, 0), [$iota$], label-side: right, "->")
	edge((0, 1), (0, 0), [$iota$], label-side: left, "->")
}))

== $G$-torsors

We now denote $G = Gal(ell/k)$. A _$G$-torsor_ is a $k$-scheme $X$ with a $G$-action such that

+ $X -> Spec k$ is faithfully flat and locally of finite presentation.
+ The canonical map $G times_k X -> X times_k X$ is an isomorphism.

Since there is a classical equivalence of finite Galois extension
$ ell times.o_k ell simeq product_(sigma in G) ell $
scheme-theoretically, this gives
$ Spec ell times_(Spec k) Spec ell simeq G times Spec ell $
Hence $Spec ell -> Spec k$ is a finite étale $G$-torsor.

= Étale Fundamental Group

== The Anima $hat(Pi^et_oo)(X)$

We can define the _étale fundamental complete anima_ $hat(Pi^et_oo)(X)$ of a scheme $X$ to be the shape of the étale topos $X_et^top$ of $X$. This is a pro-finite anima.


