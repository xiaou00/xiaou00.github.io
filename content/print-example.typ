#import "print-template.typ": *

#show: note.with(
  title: "Mathematical notes",
  subtitle: "The SLATE print template",
  author: "xiaou0",
  series: [MATHEMATICS],
  edition: [First edition],
  year: [2026],
)

= Basic ideas <basics>

This example demonstrates the PDF version of the writing template. Replace the text and metadata with your own material.

== Definitions and proofs

#definition(title: [Even integer])[
  An integer $n$ is even if $n = 2 k$ for an integer $k$.
] <even>

#theorem[The sum of two even integers is even.] <sum>

#proof[
  Write the integers as $2 m$ and $2 n$. Their sum is $2 (m + n)$, so @even applies.
]

== Equations

Fractions use native Typst typesetting, as in $A/B$. Only labeled display equations receive a number:

$ frac(1, 2) + frac(1, 3) = frac(5, 6) $ <fractions>

Refer to @fractions. An unlabeled equation does not consume a number:

$ (a + b)^2 = a^2 + 2 a b + b^2 $

= Writing tools

#fold(title: [Additional details])[
  Folded material is shown in full when printed. Equations and references such as @sum remain available.
]

#function-plot(x => x*x, x-range: (-2, 2), y-range: (-1, 4), caption: [A quadratic function])

#exercise[Write a related example of your own.]
#answer[Replace this paragraph with your solution.]
