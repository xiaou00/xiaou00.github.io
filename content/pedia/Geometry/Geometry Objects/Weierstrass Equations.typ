#import "../../../template.typ": *

#show: note

= General Form

#definition(title: [Weierstrass Equation])[
    Over a field $k$, a _Weierstrass equation_ has the form
    $ y^2 + a_1 x y + a_3 y = x^3 + a_2 x^2 + a_4 x + a_6, $
    with $a_i in k$. Its projective closure in $PP^2_k$ is
    $ Y^2 Z + a_1 X Y Z + a_3 Y Z^2 = X^3 + a_2 X^2 Z + a_4 X Z^2 + a_6 Z^3, $
    with the unique point at infinity $e = [0:1:0]$.
] <definition>

#theorem[
    Every #pedia("Elliptic Curve")[elliptic curve] $(E,e)$ over $k$ admits a smooth Weierstrass model with $e = [0:1:0]$. Conversely, a smooth Weierstrass cubic, pointed at $e$, is an elliptic curve.
] <weierstrass-model>

#proofsketch[
    Riemann--Roch gives $h^0 (E, cal(O)_E (n e)) = n$ for $n >= 1$. Choose functions $x,y$ with poles of orders $2,3$ at $e$ and no other poles. The linear system $|3e|$ embeds $E$ as a plane cubic, whose equation takes the above form after normalizing coefficients. Conversely, a smooth plane cubic has genus $1$.
]

= Short Form

#proposition[
    If $char k in.not {2,3}$, completing the square in $y$ and translating $x$ puts the equation into _short Weierstrass form_
    $ y^2 = x^3 + A x + B, quad A,B in k. $
    Its projective closure is smooth exactly when
    $ Delta := -16(4 A^3 + 27 B^2) != 0. $
    Thus this condition makes the curve, with $e = [0:1:0]$, an elliptic curve.
] <short-form>

In characteristics $2$ and $3$, use the general form; the short form is not available in general.
