#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [Pro Completion])[
    For a small #pedia("Infinity Category")[$oo$-category] $cal(C)$, its _Pro-completion_ is
    $ Pro(cal(C)) := Ind(cal(C)^opp)^opp, $
    using #pedia("Ind Completion")[Ind-completion]. It freely adjoins small #pedia("Projective Limit")[cofiltered limits]. The canonical embedding $j: cal(C) -> Pro(cal(C))$ is fully faithful.

    A _pro-object_ is represented by a small cofiltered diagram $X: I -> cal(C)$, written
    $ X = varprojlim(i in I)^sharp X_i := lim_(i in I) j(X_i). $
    The superscript $sharp$ indicates a formal limit in $Pro(cal(C))$; no limit in $cal(C)$ is required.
] <definition>

#remark(title: [Mapping Spaces])[
    For $X = varprojlim(i in I)^sharp X_i$ and $Y = varprojlim(j in J)^sharp Y_j$,
    $ Map_(Pro(cal(C)))(X,Y) simeq lim_(j in J) colim_(i in I^opp) Map_(cal(C))(X_i,Y_j). $
    The inner index is $I^opp$ because the source variable is contravariant. These limits and colimits lie in #pedia("Anima")[$Ani$].
] <mapping-spaces>

#remark(title: [Universal Property])[
    If $cal(D)$ admits small cofiltered limits, restriction gives
    $ Fun^"cofilt" (Pro(cal(C)),cal(D)) simeq Fun(cal(C),cal(D)), $
    with $Fun^"cofilt"$ denoting functors preserving them. If $cal(C)$ has finite limits, then $Pro(cal(C)) simeq (Fun^"lex" (cal(C),Ani))^opp$.
] <universal-property>
