#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Nerve])[
    The _nerve_ of an ordinary #pedia("Category")[category] $cal(C)$ is the #pedia("Simplicial Set")[simplicial set] $Ner(cal(C))$ whose $n$-simplices are strings of composable arrows
    $ X_0 -> X_1 -> dots -> X_n. $
    Equivalently, they are functors $[n] -> cal(C)$, where the #pedia("Simplex")[ordinal] $[n]$ is a category with one arrow $i -> j$ when $i <= j$. Faces compose adjacent arrows or remove an endpoint; degeneracies insert identities.
] <definition>

#remark[
    Thus vertices are objects, edges are morphisms, and $2$-simplices record composition. Inner horns have unique fillers, so $Ner(cal(C))$ is an #pedia("Infinity Category")[$oo$-category]. This regards an ordinary category as an $oo$-category with discrete mapping spaces.
]
