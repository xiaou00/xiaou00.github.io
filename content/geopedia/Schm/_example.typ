// 写法示例, 下划线开头的文件不发布. 以下内容仅演示参数写法.
#import "../../geopedia-template.typ": *

#encyclopedia(
  name: [对象 $X$],
  aliases: ([另一个名称], [对象 $X$]),
  introduction: [简述这个对象的用途或特点.],
  base: [请明确基域, 基底或相对态射.],
  definition: [写下定义或构造, 可以使用公式, 定理和交换图.],
  properties: (
    [光滑],
    [紧合],
    [在 $k$ 上几何连通],
  ),
  invariants: (
    ([维数], [$n$]),
    ([某个群], [$G$]),
    ([某个环], [$R$]),
  ),
  content: [
    在这里写一般讨论.

    == 补充说明
    可以继续写公式 $X$ 或证明.
  ],
)
