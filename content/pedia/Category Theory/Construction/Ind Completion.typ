#import "../../../template.typ": *

#show: note

= Definition

Let $cal(C)$ be a small #pedia("Infinity Category")[$oo$-category]. Its #pedia("Anima")[anima-valued] presheaves form
$ PShv(cal(C)) := Fun(cal(C)^opp,Ani). $
Write $j(c) := Map_(cal(C))(-,c)$ for the $oo$-categorical #pedia("Infinity Yoneda", <embedding>)[Yoneda embedding].

#definition(title: [Ind Completion])[
    The _Ind-completion_ $Ind(cal(C)) subset PShv(cal(C))$ is the full subcategory of small #pedia("Inductive Limit")[filtered colimits] of representables:
    $ X simeq colim_(i in I) j(c_i), quad I "filtered". $
    These colimits are taken in $PShv(cal(C))$, without requiring them to exist in $cal(C)$.
] <definition>

#remark(title: [Universal Property])[
    It freely adjoins filtered colimits: if $cal(D)$ admits them, restriction along $j$ gives
    $ Fun^"filt" (Ind(cal(C)),cal(D)) simeq Fun(cal(C),cal(D)), $
    where $Fun^"filt"$ consists of functors preserving small filtered colimits.
] <universal-property>

#remark[
    If $cal(C)$ has finite colimits, then
    $ Ind(cal(C)) simeq Fun^"lex" (cal(C)^opp,Ani), $
    where $"lex"$ means preserving finite limits. Replacing filtered by #pedia("Filtered Category", <cardinal-variant>)[$kappa$-filtered] defines $Ind_kappa (cal(C))$; thus $Ind = Ind_omega$.
] <left-exact>
