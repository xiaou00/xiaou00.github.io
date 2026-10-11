#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [$p$-adic Numbers])[
    For a prime $p$, the field of _$p$-adic numbers_ is the fraction field of the #pedia("p-adic Integers")[$p$-adic integers]:
    $ QQ_p := Frac(ZZ_p) = ZZ_p [1/p]. $
    Every nonzero $x$ has a unique expression $x = p^n u$, with $n in ZZ$ and $u in ZZ_p^times$. Put
    $ v_p (x) := n, quad abs(x)_p := p^(-n), quad abs(0)_p := 0. $
] <definition>

#remark[
    With this absolute value, $QQ_p$ is the completion of $QQ$ for the $p$-adic metric. Its ring of integers is
    $ ZZ_p = {x in QQ_p : abs(x)_p <= 1}. $
]
