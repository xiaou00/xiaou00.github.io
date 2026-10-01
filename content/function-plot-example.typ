#import "template.typ": *
#show: note

= 函数图像

只需导入模板, 在正文中调用 `function-plot`.

#function-plot(
  x => x * x,
  x-range: (-3, 3), y-range: (-1, 9),
  caption: [平方函数], alt: "抛物线 y 等于 x 的平方",
) <square-function>

如 @square-function 所示, 图形使用带刻度的黑色矩形外框、淡灰格点、细实线坐标轴与红色曲线, 不标注坐标数字、轴名称或箭头.

== 多条曲线

#function-plot(
  (calc.sin, calc.cos),
  x-range: (-calc.pi, calc.pi), y-range: (-1.5, 1.5),
  labels: ($sin x$, $cos x$),
  caption: [正弦与余弦], alt: "正弦与余弦函数在负 π 到 π 之间的图像",
)

== 间断点与定义域

#function-plot(
  x => 1 / x,
  breaks: (0,), width: 240pt, height: 164pt,
  caption: [反比例函数], alt: "反比例函数的两个分支在零点断开",
)

#function-plot(
  x => if x < 0 { none } else { calc.sqrt(x) },
  x-range: (-1, 5), y-range: (-0.5, 3),
  labels: ($sqrt(x)$,), grid: true,
  alt: "平方根函数, 只绘制非负数的定义域",
)

== 隐式方程

方程 $F(x, y) = 0$ 写成两个变量的函数, 返回等号左边减右边的数值.

#implicit-plot(
  ((x, y) => x*x + y*y - 4, (x, y) => x*x / 4 + y*y - 1),
  x-range: (-3, 3), y-range: (-3, 3),
  labels: ($x^2 + y^2 = 4$, $frac(x^2, 4) + y^2 = 1$),
  caption: [圆与椭圆], alt: "等比例坐标下的圆与椭圆",
) <implicit-curves>

@implicit-curves 默认采用等比例坐标, 保持图形原本的比例.

函数列表也可以分行书写, 每一项分别绘制一条曲线:

#implicit-plot(
  (
    (x, y) => x + y,
    (x, y) => x - y,
  ),
  x-range: (-3, 3), y-range: (-3, 3),
  labels: ($x + y = 0$, $x - y = 0$),
  caption: [两条直线],
)

#implicit-plot(
  (x, y) => x*y - 1,
  x-range: (-3, 3), y-range: (-3, 3),
  caption: [双曲线], alt: "隐式方程 xy 等于 1 的两个分支",
)
