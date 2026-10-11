#import "../../../template.typ": *

#show: note

= Definition

#definition(title: [sInd Completion])[
    Let $cal(C)$ be a small #pedia("Infinity Category")[$oo$-category] and $PShv(cal(C)) := Fun(cal(C)^opp,Ani)$ its #pedia("Anima")[anima-valued] presheaf category.

    The _sInd-completion_ (sifted completion) $sInd(cal(C))$ is the smallest full subcategory of $PShv(cal(C))$ containing the representables $j(c) = Map_(cal(C))(-,c)$ and closed under all small #pedia("Sifted Category")[sifted colimits].
] <definition>

#remark(title: [Universal Property])[
    It freely adjoins sifted colimits: for any $cal(D)$ admitting them,
    $ Fun^"sift" (sInd(cal(C)),cal(D)) simeq Fun(cal(C),cal(D)), $
    by restriction along $j$. Here $Fun^"sift"$ consists of functors preserving small sifted colimits.
] <universal-property>

#remark[
    Every filtered category is sifted, so #pedia("Ind Completion")[Ind-completion] sits inside:
    $ Ind(cal(C)) subset sInd(cal(C)) subset PShv(cal(C)). $
    If $cal(C)$ has finite coproducts, then
    $ sInd(cal(C)) simeq Fun^times (cal(C)^opp,Ani), $
    the full subcategory of functors preserving finite products, including the empty product. It is also denoted $PShv_Sigma (cal(C))$.
] <product-preserving>
