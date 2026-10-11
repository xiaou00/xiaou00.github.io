#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [$ell$-Invertible Scheme])[
    Let $ell$ be a prime. A scheme $X$ is _$ell$-invertible_, or _$ell$ is invertible on $X$_, if
    $ ell in Gamma(X,cal(O)_X)^times. $
    Equivalently, $ell$ is a unit in every local ring $cal(O)_(X,x)$, or
    $ char kappa(x) != ell quad "for every" x in X, $
    where $kappa(x)$ is the residue field at $x$.

    This is also equivalent to the structure morphism $X -> Spec ZZ$ factoring through $Spec ZZ[1/ell]$.
] <definition>
