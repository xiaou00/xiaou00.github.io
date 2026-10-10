#import "../../../template.typ": *

#show: note

= Definition

== Classical Ring-Theoretical

#definition(title:[Finite Presentation])[
    A morphism of commutative rings $f: A -> B$ is said to be of _finite presentation_ if there exists
    $ B simeq A[x_1,...,x_n]/(f_1,...,f_m) $
    identifying $B$ as a quotient of a polynomial algebra over $A$ in finitely many variables by a finitely generated ideal. 
]

== Derived Ring-Theoretical

#definition(title:[Finite Presentation])[
    An animated or $EE_oo$ algebra $A/k$ is said to be of _finite presentation_ if $A/k$ is an #pedia[compact object] in $CAlg_k$.
]

#proposition[
    $A/k$ is of finite presentation iff:

    + $pi_0 A/pi_0 k$ is of finite presentation, and
    + $LL_(A/k)$ is a #pedia[perfect complex].
]
