// 写法示例, 不是已收录的数学对象. 下划线开头的文件不发布.
// 新建命令: npm run new:object -- Schm0001 "对象名称"
#import "../../sheafpedia-template.typ": *

#encyclopedia(
  name: [对象 $X$],
  aliases: ("另一个名称",),
  introduction: [简述这个对象的用途或特点.],
  base: [请明确基域, 基底或相对态射, 性质在这些约定下理解.],
  definition: [写下定义或构造, 可以使用公式, 定理和交换图.],

  // 以下取值只演示参数写法, 请按对象的实际性质填写.
  smooth: true,
  proper: false,
  separated: none,
  extra-properties: ("自定义性质": true),
  properties: [补充适用条件, 证明或参考资料.],

  dimension: 0,
  numerical-invariants: ("自定义数值": -1),
  invariants: ("某个群": [$G$], "某个环": [$R$]),
  invariant-notes: [说明不变量的计算或依赖的条件.],
)
