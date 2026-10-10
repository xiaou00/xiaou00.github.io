#import "../../../template.typ": *

#show: note

= Definition

== Animated Algebras

#definition(title:[Smoothness])[
    Suppose $A in aCAlg_k$, then we say that $A$ is _smooth_ if the following conditions hold:

    + $A/k$ is of #pedia[finite presentation], and
    + $LL_(A/k)$ is a #pedia[perfect complex] of #pedia[Tor-amplitude] contained in $[0,0]$.
]

#remark[
    The second condition is equivalent to the condition that $LL_(A/k)$ is a finite projective $A$-module.
]

#proposition[
    $A/k$ is smooth iff:

    + The structure morphsim $pi_0 f : pi_0 k -> pi_0 A$ is classically smooth, and
    + $f$ is flat.
]

== $EE_oo$-Algebras

#definition(title:[Smoothness])[
    Suppose $A in CAlg_k$, then we say that $A$ is _smooth_ if the following conditions hold:

    + $A/k$ is of #pedia[finite presentation], and
    + $LL_(A/k)$ is a #pedia[perfect complex] of #pedia[Tor-amplitude] contained in $[0,0]$.
]

== Derived Scheme and Stack

#definition(title:[Smoothness])[
    Suppose $X/S$ is a morphism of derived scheme, then we say that $X/S$ is _smooth_ if the following conditions hold:

    + $X/S$ is #[locally of finite presentation], and
    + $LL_(X/S)$ is a #pedia[perfect complex] of #pedia[Tor-amplitude] contained in $[0,0]$.
]

#definition(title:[Smoothness])[
    Suppose $X/S$ is a morphism of derived stacks, then we say that $X/S$ is _smooth_ if the following conditions hold:

    + $X/S$ is #[locally of finite presentation], and
    + $LL_(X/S)$ is a #pedia[perfect complex] of #pedia[Tor-amplitude] contained in $[-n,0]$ for some $n in NN$.
    
]

== Classical Scheme-Theoretical

#definition(title:[Smooth])[
    Suppose $X/S$ is an $S$-scheme, then we say that $X/S$ is _smooth_ if the following conditions hold:

    + $X/S$ is #pedia[locally of finite presentation], and
    + $X/S$ is #pedia("Flatness")[flat], and
    + Forall $overline(s):Spec Omega->S$, the geometric fiber $X_(overline(s))$ is #pedia[regular].
]
