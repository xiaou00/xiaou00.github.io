#import "template.typ": *
#show: note

= Function plots

Import the template and call `function-plot` in the body.

#function-plot(
  x => x * x,
  x-range: (-3, 3), y-range: (-1, 9),
  caption: [A quadratic function], alt: "The parabola y equals x squared",
) <square-function>

As @square-function shows, plots use a black frame, light grid points, thin axes, and a red curve. Coordinate numbers, axis labels, and arrows are omitted by default.

== Multiple curves

#function-plot(
  (calc.sin, calc.cos),
  x-range: (-calc.pi, calc.pi), y-range: (-1.5, 1.5),
  labels: ($sin x$, $cos x$),
  caption: [Sine and cosine], alt: "Sine and cosine from negative pi to pi",
)

== Discontinuities and domains

#function-plot(
  x => 1 / x,
  breaks: (0,), width: 240pt, height: 164pt,
  caption: [The reciprocal function], alt: "Two branches of the reciprocal function, separated at zero",
)

#function-plot(
  x => if x < 0 { none } else { calc.sqrt(x) },
  x-range: (-1, 5), y-range: (-0.5, 3),
  labels: ($sqrt(x)$,), grid: true,
  alt: "The square root function on its nonnegative domain",
)

== Implicit equations

Write $F(x, y) = 0$ as a two-variable function returning the left side minus the right side.

#implicit-plot(
  ((x, y) => x*x + y*y - 4, (x, y) => x*x / 4 + y*y - 1),
  x-range: (-3, 3), y-range: (-3, 3),
  labels: ($x^2 + y^2 = 4$, $frac(x^2, 4) + y^2 = 1$),
  caption: [A circle and an ellipse], alt: "A circle and an ellipse with equal axis scales",
) <implicit-curves>

@implicit-curves uses equal axis scales by default to preserve the proportions of the shapes.

Functions can also be listed on separate lines; each one draws a curve:

#implicit-plot(
  (
    (x, y) => x + y,
    (x, y) => x - y,
  ),
  x-range: (-3, 3), y-range: (-3, 3),
  labels: ($x + y = 0$, $x - y = 0$),
  caption: [Two lines],
)

#implicit-plot(
  (x, y) => x*y - 1,
  x-range: (-3, 3), y-range: (-3, 3),
  caption: [A hyperbola], alt: "Two branches of the implicit equation xy equals 1",
)
