#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#set text( font: "New Computer Modern")

// Finance, Risk and Uncertainty

#let defaultStroke = (x,y) => (bottom: .5pt + gray) + if x == 0 and y > 0 {(right: .5pt + gray)}
#let small = (t) => text(size:9pt, t)

= About this document
The material in this document follows directly the handwritten lecture notes from the course in "Finance, Risk and Uncertainty" at UoE. 
The last 3 diagrams are my original work and are meant to illustrate what I found unclear at first.

= Intro

What can a corporate do about risk?

+ Do nothing (unhedge)\
   Possible reasons include:
   - would be too expensive
   - high risk tolerance (e.g. high expected value)
   - risk is not _material_ (significant)
   - they "think" the underlying assets will move in their favour (speculation)
+ Internal hedging\
  Structure the bank/company so to internally remove risk.
+ Hedge, i.e. (partially) remove risk\
  Gives _certainty_ which aids planning. Some instruments are:

  #grid(
    columns: (auto, auto),
    gutter: (1em, 3em),
    align: center,
    table(
      columns:(auto, auto),
      stroke: defaultStroke,
      align: center + horizon,
      table.header([*Forwards*], [*Futures*]),
      [2 parties #linebreak() #small["Over the counter"]],
      [traded on #linebreak() Exchanges],
      [custom contract], [standardized contract],
      [limited liquidity],
      [high liquidity #linebreak() #small[can trade at any time]]
    ),
    table(
      columns: (auto), [ *Options*],
      stroke: (x,y)=>(bottom: .5pt + gray),
      align(left)[
        give certainty \
        \+ ability to benefit \
        from favourable movements
      ]
    ),
    [*Zero* cost],
    [*Non-zero* cost],
  )

= Case
#grid(
  columns: (4fr, 7fr),
  gutter: 1cm,
  align: horizon,
  rect(stroke: gray, inset: 1em)[A UK company needs to borrow £100M for 3 months in 3 months.],
  diagram(
    // debug: 2,
    spacing: (1cm, .5cm),
    edge-stroke: .7pt,
    {
      // Helper: a short vertical tick of fixed physical length centered at p
      let tick = (p, len: 4pt) => edge(
        (to: p, rel: (0pt, len)),  // up by len
        (to: p, rel: (0pt, -len)), // down by len
        stroke: .7pt,
        snap-to: (none, none),
      )

      // Timeline anchor points (elastic uv positions)
      node((0,0), name: <now>)
      node((4,0), name: <start>)
      node((8,0), name: <end>)
      tick(<now>)
      tick(<start>)
      tick(<end>)

      // Labels above the axis (absolute offsets from the anchor points)
      node((to: <now>,   rel: (0pt, 1em)),  [Now])
      node((to: <start>, rel: (0pt, 1em)),  [3 months])
      node((to: <end>,   rel: (0pt, 1em)),  [6 months])

      // Main axis with arrow
      edge(<now>, ( to: <end>, rel: (2em, 0pt) ), "->")

      let mid1 = (<now>, 50%, <start>)
      let mid2 = (<start>, 50%, <end>)

      // Risk box below the midpoint
      node(
        (to: mid1, rel: (0pt, -1em)),
        [Risk!],
        name: <risk>,
      )

      // Explanation box further below
      node(
        (to: <risk>, rel: (0pt, -1.4cm)),
        [interest rate might increase #linebreak() in this period],
        name: <expl>,
      )

      // Arrow from the Risk box border to the explanation box border
      edge(<risk.south>, "->", <expl.north>)

      node((to: mid2, rel: (0pt,-1em)), [borrow period], name: <borrow-text>)
      node((to: <borrow-text>, rel: (0pt, -1em)), [pay interest rate + repay loan ])
    }
  ))

== Official interest rates
#place(right,
  [
  #diagram(spacing: (3em, 1em),  {
    node((-.8,0), [Quoted in pairs#footnote[Sometimes quoted in opposite order. The meaning is
  always such as to benefit the party giving the rates: it sells high and buys low.]:], inset: 3pt)
    node((0,0), [$(0.65 - 0.55)$], name: <pair>, inset: 3pt)

    node((-.5, 1), [Libor#footnote[London Inter-Bank Offered Rate] #linebreak() _Borrow rate_], name:<libor>, inset: 4pt, fill: aqua.transparentize(60%))
    node((.5, 1), [Libid#footnote[London Interbank Bid Rate] #linebreak() _Investment rate_], name:<libid>, inset: 4pt, fill: aqua.transparentize(60%))
    edge(<pair>, "->", <libor>)
    edge(<pair>, "->", <libid>)
  })\
  (see handout, page 12)
]
)

- These rates are 
  - *inter-bank*, not for the public
  - *floating* / *variable*
  - given *per annum*, even those for 3 or 6 months
- *Risk* is that interest rates _increase_
- might either fall or increase in 3 months
  - Companies may _think_ they will fall --- this is a _speculation_.\
    Thus they _think_ they know better than what the market thinks (the rates in the market reflect what the
    market thinks).

Due to *higher risk of default*, the effective interest rate the UK company will pay actually is
#align(center)[
  #grid(gutter: 1em, columns: (auto,auto,auto), align: horizon,
  box[base rate #linebreak() _(reference rate)_],
  [+],
  box[risk premium #linebreak() _(default rate)_,]
  )
]
i.e. has an extra due to the *borrower's riskiness*.

== Hedge strategies
Assume #highlight(fill: aqua.transparentize(70%))[the company wants _certainty_] in the interest rate cost, i.e. a 100% hedge.
#align(right)[(it might think Libor is going to rise)]

One choice would be a _fixed-rate loan_, but these are not often offered in real life.

Two ways to achieve this are _forwards_ and _futures_. In the context of _interest
rates_#footnote[and not e.g. in the context of currency], these are
called

#align(center)[
  #grid(
    columns: (auto, auto, auto),
    align: horizon,
    gutter: 2em,
    [
      Forward Rate Agreement (FRA)\
      (Forward)
    ],
    [and],
    [
      Interest Rate Future (IRF)\
      (Future)
    ]
  )
]

We now look at both.

=== Forward Rate Agreements
#place(right,
table(columns: 2, stroke: defaultStroke, align: center,
table.header(table.cell(colspan: 2, [*FRA Dealer*\ Offers sample])),
"3 v 6", "0.6% --- 0.5%",
"6 v 9", "0.74% --- 0.62%",
"9 v 12", "0.8% --- 0.7%",
))
- An agreement on the future rate (Libor)
- Signed with another party, usually an intermediate\
  Not necessarily the loan issuer!
- Firm and binding\
  Cannot change your mind if odds are not in your favour!
- A *gamble on its own*, a speculation.\
  There's a _winner_ and a _loser_.

#let good = (c) => text(fill: green.darken(40%), c)
#let bad = (c) => text(fill: red.darken(60%), c)

Combined, though, (FRA + borrow) is *a hedge*: the #good[gain]/#bad[loss] of the borrowing is offset by the #bad[loss]/#good[gain] of the FRA. See @fra-simple for how that works in our case with a FRA rate of 0.6% in two scenarios: rates falling to 0.5% and rising to 1% at point of payment.

#let transparent = white.transparentize(100%)

#figure(//placement: auto,
caption: [FRA as a hedge mechanism],
{ // simple FRA pic
  let loan = 5cm
  let agreed = 3cm
  let loss = 0.5cm
  let gain = 1.2cm
  let height = 3em

  let pat = (colours, width) => {
    let size = colours.len() * width * calc.sqrt(2) 
    tiling(
      size: (size, size),
      relative: "parent",
      rotate(
        45deg, 
        for i in range(-colours.len(), colours.len()) {
          let c = colours.at(calc.rem(i, colours.len()))
          place(
            dy: i * width,
            rect(
              width: size * 2,
              height: width,
              fill: c,
            )
          )
        }
      )
    )
  }

  let excessPat = c => pat((transparent, transparent, c.transparentize(40%)), 1.5pt)

  align(
    center,
    diagram(
      node((-loan/2 - 1.5cm, 0pt))[Agreed rate],
      node(
        (0cm,0cm),
        rect(stroke: gray, width: loan, height: height)[$pound 100$M]
      ),
      node(
        (loan / 2 + agreed / 2, 0cm),
        rect(stroke: (paint: gray, dash: "dashed"),  width: agreed, height: height)[0.6%]
      ),

      node((-loan/2 - 1.5cm, -height))[If rate falls #linebreak() #small[pays #good[less] to bank...]],
      node(
        (0cm, -height),
        rect(stroke: gray, width: loan, height: height, fill: aqua.transparentize(50%))[$pound 100$M]
      ),
      node(
        (loan / 2 + (agreed - loss) / 2, -height),
        rect(stroke: none, width: agreed - loss, height: height, fill: aqua.transparentize(50%))[0.5%]
      ),
      node(
        (loan / 2 + (agreed - loss) + loss / 2, -height),
        rect(stroke: (paint: gray, dash: "dashed"), fill: excessPat(green.transparentize(40%)), width: loss, height: height),
        name: <loss>
      ),
      edge(<loss.center>, "*->", <loss-text>, stroke: 1pt, layer: 2),
      node((10cm, -height), name: <loss-text>)[... but #bad[must pay] 0.1% #linebreak() #small[to FRA dealer]],

      node((-loan/2 - 1.5cm, -2*height))[If rate rises #linebreak() #small[pays #bad[more] to bank...]],
      node(
        (0cm, -2*height),
        rect(stroke: gray, width: loan, height: height, fill: aqua.transparentize(50%))[$pound 100$M]
      ),
      node(
        (loan / 2 + (agreed + gain) / 2, -2*height),
        rect(stroke: (paint: gray, dash: "dashed"),  width: agreed + gain, height: height, fill: aqua.transparentize(50%))[1%]
      ),
      node(
        (loan / 2 + agreed + gain / 2, -2*height),
        rect(stroke: (paint: gray, dash: "dashed"), fill: excessPat(red),  width: gain, height: height),
        name: <win>
      ),
      node((10cm, -2*height), name: <win-text>)[... but #good[gets back] $0.4%$ #linebreak() #small[from FRA dealer]],
      edge(<win.center>, "*->", <win-text>, stroke: 1pt, layer: 2),
    )
  )
})<fra-simple>

In both cases, the UK company pays the loan back at the market rate --- 0.5% or 1% (plus risk premium), blued out, the net cash flow is 0.6% fixed in the FRA.

The setup of the hedge is spelled out fully as
#align(center, table(
  columns: 2,
  stroke: defaultStroke,
  align: (x,y) => if x == 0 { right } else { left },
  table.header(table.cell(colspan: 2, strong[Forward Rate Agreement setup])),
  [ Buy or Sell ] , [ *Buy* #small[(see below)] ],
  [ Amount ], [ *£100M* #linebreak() #small[due to 100% hedging policy] ],
  [ Rate ], [ *$0.6%$* ],
  [ Time period ], [ *3 versus 6* #linebreak() #small[_start month_ v _end month_] ],
))

See @fra-borrower for the cash flows spelled explicitly in the two cases: when the actual rate falls to 0.5% and rises to 1%, the agreed one being 0.6%:

#figure(caption: [FRA cash flows from (UK company) borrower's point of view],
// placement: auto,
diagram(spacing:(1em, 1em), 
  node((1,0), strong[Case $arrow.b$ #linebreak() rates fall]),
  node((3,0), strong[Case $arrow.t$ #linebreak() rates rise]),
  node((2,-.7), [*0.6%*#linebreak()rate in FRA], name: <title>),
  edge(<title>, ">-->", (1,1)),
  edge(<title>, ">-->", (3,1)),
  node((2,1), [Actual interest rate]),
  edge("r","..>"),
  edge("l","..>"),
  node((1,1), [0.5%]),
  node((3,1), [1%]),

  node(
    enclose:(<fra-lost>, (1, 0)),
    inset: 4pt,
    fill: teal.transparentize(96%),
    stroke: 1pt + teal,
    snap: -1,
  ),

  node(
    enclose:(<fra-won>, (3, 0)),
    inset: 4pt,
    fill: teal.transparentize(96%),
    stroke: 1pt + teal,
    snap: -1,
  ),

  node((0,3), [Paid to #linebreak() loan giver:]),

  node(
    enclose: (<loan-left>,<loan-right>),
    fill: aqua.transparentize(80%), 
    inset: 4pt
  )[
    #emoji.bank loan issuer (bank)#linebreak()
    #small[always operates at *market* rate]
  ],
  node((1,3), name: <loan-left>)[
    $(1+0.5%) dot pound 100$M #linebreak()
    #small[+risk premium]
  ],
  node((3,3), name: <loan-right>)[
    $(1+1.0%) dot pound 100$M #linebreak()
    #small[+risk premium]
  ],

  node((1,4), [pays #good[0.1% *less*] #linebreak()#small[than FRA rate]],
    fill: white.transparentize(20%)),

  // sits in the center
  node(enclose: (<comp-left>,<comp-right>), fill: color.luma(245), stroke: silver, layer: -2),
  node((2,5), [UK case company], name: <comp>, outset: 4pt),

  node((1,5), emoji.person, name: <comp-left>, inset: 2pt),
  edge("uu", "<=<"),
  edge("dd", ">=>"),

  node((3,5), emoji.person, name: <comp-right>, inset: 2pt),
  edge("dd", "<=<"),
  edge("uu", ">=>"),

  node((3,4), [pays #bad[0.4% *more*] #linebreak()#small[than FRA rate]],
    fill: white.transparentize(20%)),

  node((0,7), [Paid to#linebreak() FRA dealer:]),
  node((1,7), [$Delta = bold(-) 0.1% dot pound 100$M], name: <fra-lost>),
  node((3,7), [$Delta = bold(+) 0.4% dot pound 100$M], name: <fra-won>),

  node(
    enclose: (<fra-lost>, <fra-won>),
    [FRA dealer #linebreak() #small[usually a different bank]],
    inset: 4pt,
    fill: aqua.transparentize(80%),
  ),

  node(
    (1,6),
    fill: white.transparentize(20%),
  )[
    #bad[*lost*] the FRA bet#linebreak()#small[must compensate]
  ],
  node(
    (3,6), 
    fill: white.transparentize(20%)
  )[
    #good[*won*] the FRA bet#linebreak()#small[gets compensation]
  ],
)
)<fra-borrower>

#align(
  center,
  rect(width: 120%, stroke: none)[
    #let two = c => box(baseline: 40%, c)
    The party compensated for #two[*Rise\ Fall*] 
    of interest rates is said to #two[*Buy\ Sell*] the FRA contract,
    usually a #two[*Borrower\ Investor*].
  ]
)

#figure(placement: bottom, 
  caption: [FRA all players and cash flows],
{ // 4-player pic
  let playerColor = olive.transparentize(60%)
  let strokeThickness = .8pt
  let extrudeRadius = 4
  let wedge = (..args) => edge(
    ..args,
    extrude: (-extrudeRadius,extrudeRadius),
    stroke: (thickness: strokeThickness),
    mark-scale: 180%
  )

  let big = c => text(size: 12pt, strong(c))

  diagram(
    spacing: (.5em, 2em),
    // Transpose: swap axes so u is vertical (ttb) and v is horizontal (ltr)
    axes: (ttb, ltr),

    node((to: (-1,4), rel: (5.5cm,0cm)), name:<bank-loan>, inset: .8em)[Gives loans\ at rate $r^+$],
    node((to: (+1,4), rel: (5.5cm,0cm)), name:<bank-dep>, inset: .8em)[Accepts\ deposits\ at rate  $r^-$],

    node(
      big("Bank"),
      enclose: (<bank-loan>, <bank-dep>),
      stroke: aqua.transparentize(20%),
      fill: aqua.transparentize(90%),
      name: <the-bank>,
    ),

    wedge(<bank-loan>, "->", (-1,1), shift: -1pt * (extrudeRadius + 3), snap-to: (<the-bank>,auto))[$pound$100M],
    wedge((-1,3), "->", <bank-loan>, shift: -1pt * (extrudeRadius + 3), snap-to: (auto,<the-bank>), label-side:right, align(right, [$pound(100 + r^+)$M\ #small[(+risk)]])),

    wedge((+1,3), "->", <bank-dep>, shift: 1pt * (extrudeRadius + 3), snap-to: (auto,<the-bank>))[$pound$100M],
    wedge(<bank-dep>, "->", (+1,3), shift: 1pt * (extrudeRadius + 3), snap-to: (<the-bank>,auto), label-side:left)[$pound(100 + r^-)$M],

    node((0,0))[
      #big[FRA Dealer]\
      Offer: $a$ --- $b$
    ],
    node((0,1), snap: 1, outset: strokeThickness * extrudeRadius),
    node((0,3), snap: 1, outset: strokeThickness * extrudeRadius),
    node((0,3), snap: -1, name: <fra-end>, inset: 1em),
    node(
      enclose: ((0,0), (to:<fra-end>, rel:(4em,0pt))),
      fill: aqua.transparentize(90%),
      stroke: aqua.transparentize(20%)
    ),

    node((-1,0), inset: 1em, big("Borrower")),
    node(enclose: ((-1,0), (to: (-1,3), rel: (4em,0pt))), stroke: playerColor, fill: playerColor.transparentize(70%)),
    node((1,0), inset: 1em, big("Investor")),
    node(enclose: ((+1,0), (to: (+1,3), rel: (4em,0pt))), stroke: playerColor, fill: playerColor.transparentize(70%)),

    node((-2,1))[*Case $arrow.b$*\ $r^+<a$],
    node((2,1))[*Case $arrow.b$*\ $r^-<b$],
    node(enclose: ((-2,1),(-1,1),(2,1)), stroke: teal, fill: teal.transparentize(95%), layer: -2),

    node((-2,3))[*Case $arrow.t$*\ $r^+>a$],
    node((2,3))[*Case $arrow.t$*\ $r^- >b$],
    node(enclose: ((-2,3),(1,3),(2,3)), stroke: teal, fill: teal.transparentize(95%), layer: -2),

    node((-1, 1), name: <left-fall>, inset: 3pt)[#small[must compensate]\ $a-r^+$],
    node((1, 1), name: <right-fall>, inset: 3pt)[$b-r^-$\ #small[gets compensation]],
    node((-1, 3), name: <left-rise>, inset: 3pt)[#small[gets compensation]\ $r^+-a$],
    node((1, 3), name: <right-rise>, inset: 3pt)[$r^--b$\ #small[must compensate]],

    wedge(<left-fall>, "r", "-"),
    wedge(<right-fall>, "l", "<-"),
    edge(<left-fall>, "rr", "-", extrude: (-extrudeRadius), stroke: (thickness: strokeThickness)),

    wedge(<left-rise>, "r", "<-"),
    wedge(<right-rise>, "l", "-"),
    edge(<right-rise>, "ll", "-", extrude: (-extrudeRadius), stroke: (thickness: strokeThickness)),

    node((0,2), name: <spread>, outset: -6pt)[$(a-b) - (r^+-r^-)$],
    node((0,2), snap: -1, small[Spread earned\ \ in both cases]),
    wedge("u", "<-"),
    wedge("d", "<-"),
  )
})<fra-full-diagram>

=== Interest Rate Futures 
#place(right,
  rect(
    stroke: .5pt,
    table(
    columns: 4,
    stroke: none,
    align: left,
    table.header(table.cell("Interest rates futures sample 2004", colspan: 4, stroke: (bottom: 1pt))),
    [],            "Start", "Open",  "Sett",
    "Sterling 3m", "Mar",   [99.44], [99.44],
    "Sterling 3m", "Jun",   [99.43], [99.43],
    "Sterling 3m", "Nov",   [99.42], [99.41],
    table.footer(
      table.cell(align: right, colspan: 4)[
        Contract size: $pound 500 thin 000$ #linebreak()
        Spread: 2.8%
      ],
      table.cell("(see handout, page 14)", align: right, colspan: 4)
    ),
  )))

Same principle as FRAs.\
Traded on exchanges, contracts with standardized
- time period\
  fixed start month and length
- contract size\
  #small[notional amount covered by the contract]
- rates\
  - shown value is $(100 - "rate")$ instead,\ and is colloquially called "price"#footnote[though no
    such amount of money is actually exchanged. Thus the "price" term here is more like a figure of speech.]
  - usually shown is the _average_ between buy/sell\
    #small[have to take the _spread_ into account]

Assume the example case is set in January, so the $pound 100$M borrow lasts Mar-Jun.
For the UK case company we are interested in the _Sterling 3m March_ future, column Sett.

With a quoted price of 99.4 and spread 2.8, the meaning of the prices is as follows:
#align(center,
table(
  columns: 3,
  stroke: defaultStroke,
  align: center,
  table.header(
    table.cell(align:right)[At the price], [99.3], [99.58]
  ),
  table.cell(align:right)[Exchange is said to], [*buy* (cheap)], [*sell* (expensive)],
  table.cell(align:right+horizon,rowspan:2)[The exchange\ compensates], 
  [*fall* of\ IRF price], [*rise* of\ IRF price],
  [*rise* in\ interest rates],
  [*fall* in\ interest rates],
))

#grid(
  gutter: 1.5cm, columns: 2,
  table(
    columns: 2, stroke: defaultStroke,
    align: center,
    table.header(
      table.cell(
        [*Hedge setup* #linebreak() 
         Interest Rate Futures], colspan: 2)),
    "Buy or sell", strong("Sell"),
    "Amount",      strong("200 contracts"),
    "Length",      strong("3 months"),
    "Start",       strong("March"),
    "Price",       strong("99.3"),
  ),

  [
    Thus the case UK company that seeks compensations for *rising* rates needs to *sell* futures to the exchange and will use the _lower_ price, *99.3*.

    The future's contract size in $pound 500$k, so 100% hedging is achieved by buying $ (pound 100"M") / (pound 500"k") = 200 "contracts." $
  ],
)

*Note:* If the available periods or amounts do not fit,
we have to split/partition.
