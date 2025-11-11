#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
// #set text( font: "New Computer Modern")
#let defaultStroke = (x,y) => (bottom: .5pt + gray) + if x == 0 and y > 0 {(right: .5pt + gray)}

= Foreign exchange futures: pricing and arbitrage

Here we derive how foreign exchange futures can be priced based on interest rates, and thus how an
arbitrage strategy can be applied if the price is inappropriate.

Then we show how the same approach can be used to _recreate_ futures in markets where they are not
readily available.

== Setup

For ease of notation we assume two currencies #sym.pound, and #sym.dollar, related by a (time-dependent) exchange rate $alpha_t$: $ pound_t &=
alpha_t dollar_t \ dollar_t &= 1 / alpha_t pound_t $

We are given 
- the interest rates in both currencies for a particular time period, $r_pound$ and $r_dollar$ 
- the exchange rate now, $alpha_0$ (the rate at the end of the period, $alpha_1$, is unknown)
- a dealing limit of $pound_0 X$
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

= Hedging foreign exchange with money market
In currencies where foreign exchange futures are not as developed, we can use the same procedure
above to recreate a future manually and hedge a foreign exchange with it.

== Setup 
We want to convert a future amount between two currencies at a known rate, where
- the _foreign_ currency amount is specified,
- while the _home_ currency amount is unknown, because the future exchange rate is unknown, and that is the risk. 
so that the total amount spent or received in the home currency is known _now_.

We could also consider the converse: a fixed _home_ currency amount and an unknown foreign one, but
that is uninteresting because here we only care about _our_ currency and there would be nothing to
hedge.

Still, there are two possible scenarios, depending on the direction of the conversion:
#align(center,grid(
  columns: 3,
  inset: (.5em, .5cm),
  stroke: (x,y)=> (if y>0 {(top: .5pt,)} else {(:)}) + (if x>0 {(left: .5pt)} else {(:)}),
  align: (x,y)=> horizon + if x==0 { right } else {center},
  grid.header(
    [Want to convert:], [home $|->$ foreign], [foreign $|->$ home]),

  [Risk is:], 
  [foreign is strong,\ home is weak], 
  [foreign is weak,\ foreign is strong],

  [...in which case\ we will:],
  [have to use too much\ of the local currency\ to cover the foreign amount],
  [receive too little\ in the local currency\ after the conversion],

  [This role\ is played by], 
  [an importer who\ has to pay for foreign goods],
  [an exporter who\ will be payed for exported goods]
))

Say we want to convert the foreign future amount $dollar_1 A$ into local pounds (we play a British
importer). Interest rates for the period til the exchange are $r_pound$ and $r_dollar$, and the
current exchange rate is $alpha_0$. 

== Strategy
Again, we borrow in one currency and invest in the other, but now we also have the future amount
$dollar_1 A$ that we want to turn into an $alpha_1$-independent pound value in the future.

Copying directly the table from earlier:

#align(center,table(columns: 3, 
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
))

In the previous section, the future total included gaining from the investment and repaying the
loan; this time we also have the $dollar_1 A$ to convert, so the future total is 
$
  Delta = underbrace(- pound epsilon X e^(r_pound), "pounds result") +
  underbrace(dollar alpha_0 epsilon X e^(r_dollar), "dollar result") +
  underbrace(dollar A, "amount" #linebreak() "to convert").
$

Now we want the local currency value of $Delta$ to be independent of the future exchange rate. That
means that we want the dollar parts to cancel out, i.e. we want that 
$ dollar alpha_0 epsilon X e^(r_dollar) + dollar A = 0, $
i.e. the dollar result of the borrow-invest strategy should completely compensate the amount $A$
that is to be converted. So we want to _pay_ dollars, meaning _now_ we have to borrow them.

The last equation immediately implies that $epsilon = -1$ and $X = 1/(alpha_0 e^(r_dollar)) A$.
Looking back at the table, that means that 
+ _now_ we have to _borrow_ dollars having a future value of $dollar A$
+ convert the borrowed to pounds and invest the pounds, 
+ _then_, repay the dollar loan with the future amount $dollar A$ that will be available, thus
  getting rid of all dollars,
+ and earn on the pounds investment at the known pounds interest rate. 
