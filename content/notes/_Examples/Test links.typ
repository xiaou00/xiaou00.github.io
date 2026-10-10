#import "../../template.typ": *

#show: note

This example checks links between notes and encyclopedia entries.

= References <references>

- Open #note-ref[Test note].
- Jump to #note-ref("Test note", <even-sum>).
- Read #pedia("Test entry", target: <example>)[the encyclopedia example].

= A short calculation

$ (a + b)^2 = a^2 + 2 a b + b^2 $

The References and Referenced by sections below are generated automatically.
