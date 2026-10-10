#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Degree of a Line Bundle])[
    Let $X$ be a #pedia("Properness")[proper] $k$-scheme with $dim X <= 1$. The _degree_ of a #pedia("Line Bundle")[line bundle] $cal(L)$ on $X$ is
    $ deg(cal(L)) := chi(X, cal(L)) - chi(X, cal(O)_X), $
] <definition>

#remark[
    Degree is additive under tensor product:
    $ deg(cal(L) tens cal(M)) = deg(cal(L)) + deg(cal(M)). $
    In particular, $deg(cal(O)_X) = 0$ and $deg(cal(L)^*) = -deg(cal(L))$.

    If $X$ is a regular curve and $cal(L) ≅ cal(O)_X (D)$ with $D = sum_x n_x [x]$, then
    $ deg(cal(L)) = sum_x n_x [kappa(x):k], $
    where $x$ runs over closed points. Over an algebraically closed field, this is simply $sum_x n_x$.
] <degree-properties>

#remark(title: [Higher Dimensions])[
    On a projective $k$-scheme $X$ of pure dimension $n >= 1$, choosing an ample line bundle $cal(H)$ gives the _polarized degree_
    $ deg_(cal(H))(cal(L)) := (cal(L) dot cal(H)^(n-1) dot X), $
    the intersection number. For $n > 1$, this generally depends on $cal(H)$; the difference $chi(X, cal(L)) - chi(X, cal(O)_X)$ is no longer generally additive under tensor product.
] <higher-dimensions>
