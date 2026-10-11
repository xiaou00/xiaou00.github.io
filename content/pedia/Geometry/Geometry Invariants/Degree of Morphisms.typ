#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Degree of a Morphism])[
    Let $f: X -> Y$ be a dominant, generically finite morphism of integral schemes, locally of finite type. Write $eta_X, eta_Y$ for their generic points. The _degree_ of $f$ is
    $ deg f := [kappa(eta_X) : f^* kappa(eta_Y)]. $
    Here $kappa(x)$ denotes the residue field at $x$; in particular, $kappa(eta_X)$ is the function field of $X$.
] <definition>

#remark(title: [Finite Locally Free Morphisms])[
    If $f$ is finite locally free, then for every $y in Y$,
    $ deg f = rk_(cal(O)_Y)(f_* cal(O)_X) = h^0(X_y, cal(O)_(X_y)), $
    where $X_y = X times_Y Spec kappa(y)$ and $h^0$ is computed over $kappa(y)$. Thus the degree measures fibre length, including multiplicities.
] <fibre-degree>
