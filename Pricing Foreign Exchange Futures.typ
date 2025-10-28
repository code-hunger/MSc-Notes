#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
// #set text( font: "New Computer Modern")
#let defaultStroke = (x,y) => (bottom: .5pt + gray) + if x == 0 and y > 0 {(right: .5pt + gray)}

= Foreign exchange futures

Now we look at how foreign exchange futures can be priced, and thus how an arbitrage strategy can be
applied if the price is inappropriate.

== Setup

For ease of notation we assume two currencies #sym.pound, and #sym.dollar, related by a (time-dependent) exchange rate $alpha$: $ pound &=
alpha dollar \ dollar &= 1 / alpha pound $

We are given 
- the interest rates in both currencies for a particular time period, $r_pound$ and $r_dollar$ 
- the exchange rate now, $alpha_0$ (the rate at the end of the period, $alpha_1$, is unknown)
- a dealing limit of $pound X$
and we are interested in the potential profit of borrowing from the lower interest currency and
investing into the higher interest currency.

== Strategies
At time zero, we can either UK-borrow $pound X$, convert to #sym.dollar and US-invest that $dollar alpha X$, or do the converse -- US-borrow and UK-invest. 
To talk about the two cases uniformly, we introduce a parameter $epsilon = +1$ or $epsilon = -1$. 

In the table below, a trade of positive value means we _borrow_ that amount, and conversely, a negative
value traded denotes an _investment_.

#grid(columns: 2,
gutter: 1em,
table(columns: 3, 
  stroke: defaultStroke,
  align: center + horizon,
  table.header(
    [],
    sym.pound,
    sym.dollar,
  ),
  [ Trade\ now ],
  $   pound epsilon X $,
  $ - dollar alpha_0 epsilon X $,
  [ Trade\ in 1 year ],
  $ - pound epsilon X e^(r_pound) $,
  $   dollar alpha_0 epsilon X e^(r_dollar) $,
),
[
  At time zero, we trade $pound epsilon X$ and $-dollar alpha_0 epsilon X$, so $epsilon = +1$ means we
  borrow $pound X$, convert to $dollar alpha_0 X$ and invest in dollars; and conversely for $epsilon =
  -1$.

  In one year, we (must) trade the interest-accumulated values in the opposite direction -- repay
  the loan and receive on the investment.
]
)

== Profit
The difference in the trades in one year symbolically is 
$ 
    Delta equiv dollar alpha_0 epsilon X e^(r_dollar) 
  - pound epsilon X e^(r_pound).
$

This value only has meaning if we can can convert between future dollars and pounds at some rate $alpha_1$. 
Put $dollar = 1 / alpha_1 pound$ to get a 
difference expressed solely in pounds of
$
Delta = pound epsilon (
  alpha_0 / alpha_1
  e^(r_dollar) 
  - e^(r_pound)
) X.
$

If this expression does not vanish, the strategy results in a profit/loss, so is an arbitrage
opportunity (as we started with zero initial wealth).

$Delta$ vanishes only if $ alpha_0 / alpha_1 = e^(r_pound) / e^(r_dollar) wide "i.e." quad alpha_1 =
alpha_0 e^(r_dollar) / e^(r_pound). $
If a dealer trades foreign exchange futures at any other rate $alpha_1$ that results in
$Delta != 0$ (thus allowing us to actually perform the currency exchange between the traded values in 1 year), we can set
$ epsilon = "sign"( alpha_0 / alpha_1 - e^(r_pound) / e^(r_dollar) ) $
and ensure profit by following the resulting strategy:

#align(
  center,
  grid(
    columns: 2,
    align: center,
    inset: 1em,
    stroke: .5pt,
    grid.cell(colspan: 2)[When a dealer provides a price that is],
    [too high $ alpha_1 > alpha_0 e^(r_dollar - r_pound) $],
    [too low $ alpha_1 < alpha_0 e^(r_dollar - r_pound) $],
    [Set $epsilon = -1$],
    [Set $epsilon = +1$],
    diagram({
      node((0,0), [Borrow $pound X$])
      edge("r", "==>", [Convert])
      edge("d", "=>")
      node((1,0), [Invest $dollar alpha_0 X$])
      edge("d", "=>")
      node((0,1), [Repay $pound e^(r_pound) X$])
      node((1,1), [Receive $dollar e^(r_dollar) X$])
      edge("l", "==>", [Convert])
      node((0.5,1), outset: 2pt, snap: 2)
      edge((0.5,1), "==>", "d")
      node((0.5,2))[Profit $( pound e^(r_pound) - dollar e^(r_dollar) )X$]
    }),
    diagram({
      node((0,0), [Invest $pound X$])
      edge("r", "<==", [Convert])
      edge("d", "=>")
      node((1,0), [Borrow $dollar alpha_0 X$])
      edge("d", "=>")
      node((0,1), [Receive $pound e^(r_pound) X$])
      node((1,1), [Repay $dollar e^(r_dollar) X$])
      edge("l", "<==", [Convert])
      node((0.5,1), outset: 2pt, snap: 2)
      edge((0.5,1), "==>", "d")
      node((0.5,2))[Profit $( dollar e^(r_dollar) - pound e^(r_pound) )X$]
    }),
    grid.cell(colspan: 2)[
      In both cases, profit comes from _the higher amount of converted currency_,\
      not from the higher interest rate! ($r_pound > r_dollar$ or $r_dollar > r_pound$)
    ]
  )
)

It is remarkable that the choice on which of the two strategies to apply depends on $alpha_1$, but
not on which of the rates $r_pound$, $r_dollar$ is higher. As a function of $alpha_1$, 
$ epsilon_(r_pound, r_dollar) (alpha_1) = "sign"( alpha_0 / alpha_1 - e^(r_pound) / e^(r_dollar) ) $
is always monotonic (non-increasing), and e.g. even interchanging $r_pound, r_dollar$ will only move the
threshold at which it changes sign. 
So for sufficiently large deviations of $alpha_1$ from the theoretical rate (when $Delta = 0$), we
might end up borrowing from the high-interest currency (expensive) and invest in the low-interest
currency (cheap), which is counter-intuitive.
