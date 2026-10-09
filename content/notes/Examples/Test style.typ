#import "../../template.typ": *

#show: note

A specimen of the SLATE template: quiet typography, chapter numbering, and mathematical statements.

= Foundations <foundations>

== Definitions and results <results>

#definition(title: [Even integer])[
  An integer $n$ is even when $n = 2 k$ for some integer $k$.
] <even>

#theorem(title: [Closure under addition])[
  The sum of two even integers is even.
] <addition>

#proof[
  Write the integers as $2 m$ and $2 n$. Their sum is $2 (m + n)$.
]

#lemma[The negative of an even integer is even.] <negative>
#proposition[The even integers form a subgroup of the integers.]
#corollary[Every integer multiple of an even integer is even.]

#remark[Theorem, lemma, proposition, and corollary share one counter.]
#example[$2$, $4$, and $6$ are even integers.]
#construction[Take all integer multiples of $2$.]
#claim[Zero belongs to this collection.]

=== Equations and references

Only labeled display equations receive a number:

$ (a + b)^2 = a^2 + 2 a b + b^2 $ <square>

$ (a - b)^2 = a^2 - 2 a b + b^2 $

Refer to @addition, @negative, and @square. Inline fractions such as $a/b$ use the same native mathematical typesetting as the print template.

#question[Is the sum of two odd integers even?] <question>
#answer(to: <question>)[Yes. Write them as $2 m + 1$ and $2 n + 1$.]
#exercise[Show that the product of two odd integers is odd.]

Use `#theorem(title: [A name])[A statement.]` to write a named result.

= A new chapter <next-chapter>

Counters restart at the beginning of a numbered chapter.

#theorem[The integer $2 k$ is even for every integer $k$.] <restart>

$ 2 k + 2 l = 2 (k + l) $ <sum>

The previous chapter contains @square; this chapter contains @sum.
