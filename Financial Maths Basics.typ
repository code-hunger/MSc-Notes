#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#set text( font: "New Computer Modern")
#set par(justify: true)
#set heading(numbering: "1.1.")

It is not a priori quite clear to the author why exactly the standard framework of measure-theoretic probability (and financial calculus, in particular) is defined as such. This article aims to derive it from common sense and not pull any insights from higher intelligence.

= Available information
A fundamental concept underlying financial mathematics is the mathematical
model of _available information_ --- the way we encode what we know and what we don't know about a real-world event or process.

== Setup
Imagine a probability experiment that can be "run" and on which "observations" can be made.

#let calF = $cal(F)$

#set enum(numbering: "1a.")
+ A single run fixes (determines) _everything_ that can be observed about the experiment. 
+ A _run_ is commonly denoted by $omega$, and the set of _all_ runs is commonly denoted by $Omega$.
+ Probabilities are assigned to sensible subsets of $Omega$, forming a $sigma$-algebra $cal(F) subset cal(P)(Omega)$ and
  a probability measure $bb(P) : cal(F) -> [0,1]$.
+ In practice, we do not know exactly which run $omega in Omega$ occurred. Instead,
  + we can only know if the run is _among whole sets_ $A$ of runs;\
  + we can usually only "look" at the experiment, and _observe_ values of projections $X: Omega -> E$ onto other sets $E$.

=== Events
Such a set of runs $A$, that we can know if $omega$ lies in, is called _an event_ and is only allowed to be in #calF. Thus it is in the domain of $PP$ and has a well-defined _probability_ $PP(A)$. The model does not really talk about whether a run is in a set not in $calF$.

=== Random variables
#import "@preview/cetz:0.4.2"
#grid(
  columns: 2, 
  column-gutter: 1em,
  [
    If we observe a particular value $e = X(omega)$ through a projection $X:Omega -> E$, then we know that the run that happened lies in $X^(-1)({e}) subset Omega.$
    But we're only allowed to know if $omega$ is in $calF$-sets, so the only (sets of) values $A subset E$ (including the case $A={e}$) we are allowed to observe from $X$ must have measurable preimages $X^(-1)(A) in calF$.
  ],

  cetz.canvas({
    import cetz.draw: *
    circle((0,2), radius: (1,.5))
    content((-.5,2), $E$)
    let xo = (0.3,1.75)
    content((0.4,2), $X(omega)$)
    circle(xo, radius: 1pt, fill: black)

    content((5.3, 1.5), [
      When we observe $e=X(omega) in E$,\
      we know that $A=X^(-1)(e)$ happened,\
      but not which $omega$ exactly.
    ])
    bezier-through((.8,.5), (1,1), xo, stroke: .5pt, mark: (end: (symbol: "stealth")))
    content((1.3,1.2), $X$)

    circle((0,0), radius: (1.7,1))
    content((-1.2,0), $Omega$)
    circle((.5,0), radius: (.7,.6), stroke: .5pt)
    content((.7,-.2), $omega$)
    circle((.4,-.2), radius: 1pt, fill: black)
    content((.6,0.2), $A$)
  })
)
Thus to model observables we use _measurable_ functions $X: Omega -> E$ into measure spaces $E$, and we call $X$ a _random variable_.

In this sense, $calF$ is a restriction on the nature of all random variables, containing the information _that is allowed to be known_ and revealed by any observables.

= Experiments that happen in time
Imagine we're observing an experiment that is laid out as a process over time $NN$. 

== Atomicity of history
A single run $omega$ of the experiment contains the whole history of the process. 
That is, from a mathematical point of view, the future is predetermined.

As time evolves in the real world, though, we can only observe what is _currently_ happening, and not the whole history, even though in theory it already "happened". Many runs of the experiment may have the same observable properties up to a particular time $n in NN$, thus we only know that the run $omega$ we're observing lies in a (probably large) measurable subset of $Omega$ containing runs of the same observed history up to now but different futures.

For any $n$, let $calF_n subset calF$ contain all maximal sets of events that share a common observable property up to time $n$ or earlier. That is, $calF_n$ contains only, and all, sets of runs that a particular run can be determined to lie in, by observing it up to time $n$. Then trivially $calF_n subset calF_m$ for all $n <= m$. 

If two runs $omega$ and $omega'$ differ in no observable way up to time $n$, they are not $calF_n$-separable#footnote[I borrow that term from topology. "Two points $x,y$ are _separated_ by $calF_n$" means that there are sets $A,B in calF_n$ that contain one but not the other: $x in A,y in.not B$ and $x in B, y in.not A$.].

Thus in order to model slowly-appearing history over $Omega$ (recall, $Omega$ is a set of atoms $omega$ containing entire individual histories) we introduce a nested sequence of $sigma$-algebras in $calF$ 
$ calF_0 subset calF_1 subset ... subset calF_n subset ... $ 
called a _filtration_ over $Omega$. It is a way to _lay out in time_ the otherwise indivisible experiment runs $omega$ without actually chopping them in time pieces.
So at each step $n$ we're allowed to know only which event in $cal(F)_n$ has occurred and nothing more specific (like which run $omega$ has happened).

== Random processes
A sequence of real-world observations is then modelled by 
- projections $X_n : Omega->E$ that distinguish only properties observable up to time $n$,
- i.e. $X_n (omega) != X_n (omega')$ (with both values in disjoint measurable sets in $E$) is only allowed if $omega$ and $omega'$ differ _in an observable way up to time $n$_, so that $X_n$ does not accidentally reveal information about $omega$ that is not supposed to be known at time $n$.
- That is, the preimages of observable (sets of) values in $E$ must be maximal w.r.t. observables up to time $n$, 
- i.e. $X_n^(-1)(A)$ must be in $calF_n$ for all measurable $A subset E$. 

Or, $X_n$ must be $calF_n$-measurable for all $n$. Such a sequence $X_(bullet)$ is called a _stochastic process_.

== Filtration example diagram
Schematically we can imagine a filtration on a rectangular $Omega$ like this:

#{
  let algebras = (
    ((2,),(2,)),
    ((3,),(1,)),
    ((1,4,),(3,)),
  )

  let height = 3cm
  let width = 2cm

  let dx = width / 4
  let dy = height / 5

  let horiz(stroke, row) = place(
    dx: 0pt, dy: 0pt,
    line(
      stroke: stroke,
      start: (0cm,   row),
      end:   (width, row),
    )
  )

  let vert(stroke, col) = place(
    dx: 0pt, dy: 0pt,
    line(
      stroke: stroke,
      start: (col, 0cm),
      end:   (col, height)
    )
  )

  let drawLines(stroke, (rows,cols)) = {
    for r in rows { horiz(stroke, r*dy) }
    for c in cols { vert(stroke, c*dx) }
  }

  if false {
  grid(
    columns: 4,
    gutter: 1em,

    rect(
      width: width, height: height,
      inset: 0pt,
    ) + $cal(F)_0={emptyset, Omega}$,
    ..range(algebras.len())
    .map(n => 
       rect(
         width: width, height: height,
         inset: 0pt,
         drawLines(black, algebras.at(n)) 
         + for i in range(n) {
           drawLines((dash: "dashed", paint: gray), algebras.at(i))
         }
       ) + $ cal(F)_#(n + 1) $
    )
  )}

  let colN = 4
  let rowN = 5

  let externalBorders(x, y) = {
    let onlyIf(cond) = if cond { black + 2pt }
    (
      top: onlyIf(y == 0),
      left: onlyIf(x == 0),
      right: onlyIf(x == colN - 1),
      bottom: onlyIf(y == rowN -1),
    )
  }

  let merge(b, a) = {
    let select(key) = if key in b and b.at(key) != none { b.at(key) }
          else if key in a { a.at(key) }
    (
      left: select("left"),
      right: select("right"),
      top: select("top"),
      bottom: select("bottom"),
    ) 
  }

  let inset = .3cm
  grid(
    columns: 4, gutter: 2 * inset,
    table(rows: rowN, columns: colN, inset: inset, stroke: externalBorders)
      + $ cal(F)_0={emptyset, Omega} $,
    ..range(algebras.len())
    .map(n =>
    table(
      rows: rowN, columns: colN,
      inset: inset,
      stroke: (x,y) => {
        let bordersAt(i, stroke) = {
          let (rows,cols) = algebras.at(i)
          (
            right: if cols.contains(x+1) { stroke },
            bottom: if rows.contains(y+1) { stroke },
          )
        }

        merge(
          range(n).fold(
            bordersAt(n, black ),
            (acc, i) => 
              merge(
                acc, 
                bordersAt(i, (paint: gray, dash: "densely-dashed"))
              )
          ),
          externalBorders(x,y)
        )
      }
    ) + $ cal(F)_#(n + 1) $
  ))
}

A run $omega$ is a point in the rectangle. Each of the four rectangles represents the same $Omega$ but with a different $sigma$-algebra on it. The $sigma$-algebras $calF_n$ contain all rectangles outlined in each case (both dashed and non-dashed#footnote[non-dashed borders indicate the newly introduced measurable sets that weren't measurable in the previous step]):
1. In the beginning, we know nothing (except that the run _happened_), so no subrectangles. 
2. In $calF_1$, the model allows to observe which of the four regions $omega$ lies in, but nothing more. 
3. In $calF_2$, we're allowed to observe which of the 9 (smaller!) rectangles it is in, and so on.

== Example

#grid(columns: (4fr,3fr), gutter: 1.5em,
[For an experiment with 3 consecutive coin flips we can put $ Omega = {"Heads", "Tails"}^3, $ a discrete cube in 3D. 

$calF_1$ contains only the front and back halves (apart from the whole cube and the empty set), $calF_2$ is generated by the four vertical edges, and $calF_3$ --- by all 8 corners of the cube. 

If $X_i : Omega -> {"Heads", "Tails"}$ is the outcome of the $i$th coin flip, then $X_i$ is allowed to (though does not necessarily have to) differ only on different sets from $calF_i$, which it does.

Again, keep in mind that the entire runs of the experiment are fully encoded in the actual corners. The random process $X_1,X_2,X_3$ is only a sequence revealing smaller and smaller subsets in $Omega$ around the true $omega$.
],
align(center,
cetz.canvas({
  import cetz.draw: *

  let k = 3
  let toHT(a) = if ( a==1 ) { "H" } else { "T" }

  for x in range(0, 2) {
    for y in range(0, 2) {
      line((k*x,k*y,0), (k*x,k*y,k), stroke: (thickness: .3pt, dash: "dashed") )
    }
  }

  for z in range(0, 2) {
    for y in range(0, 2) {
      line((0,k*y,k*z), (k,k*y,k*z), stroke: (thickness: .3pt, dash: "dashed") )
    }
  }

  rect((0-.5,0-.5,k/2), (k+.5,k+.5,k/2), fill:aqua.transparentize(70%))
  line((k/2,0-.5,k/2),(k/2,k+.5,k/2), stroke: (dash: "densely-dotted"))
  // set-origin((k/2,k/2,k/2))
  rotate(y: -90deg)
  // set-origin((0,0,0))
  rect((0-.5,0-.5,-k/2), (k+.5,k+.5,-k/2), fill:aqua.transparentize(70%))
  rotate(y: 90deg)

  for z in range(0, 2) {
    for x in range(0, 2) {
      line((k*x,k,k*z), (k*x,0,k*z))
      for y in range(0, 2) {
        let where = (k*x,k*y,k*z)
        circle(where, radius: 2pt)
        content((k*x,k*y + (if y > 0 {1} else{-1})/2,k*z), toHT(z) + toHT(x) + toHT(y))
      }
    }
  }

})) + [
  $calF_2$ is generated by the four vertical edges, i.e. the outcomes of the first two flips.
Both $X_1$ and $X_2$ are $calF_2$-measurable, though neither of the two on its own separates the entire $calF_2$, only the vector $(X_1,X_2)$ does.
])



= Stopping times

Here we consider a property that is present up to some time point (potentially infinite) in the observed process
(or equivalently, a property present only from some time point onward in the observed process).

Again, we model the time layout of the process by a filtration $calF_bullet$.
Then the presence of a property like above is modelled by a monotonic $calF_bullet$-adapted boolean sequence $P_bullet$ (with values in $2={0,1}$ with the $cal(P)(2)$ $sigma$-algebra).

It is natural to ask now, what is the turning point? It is given by
$ T_X = inf_(P_n = 1) n = inf med { n in NN : P_n = 1 } $

At any time $n in NN$, $P_n$ tells us whether $P$ has happened up to now.
In terms of $T_X$, this is the event $T_X <= n$, so it is $calF_n$ measurable.

Conversely, for every $NN$-valued random variable $T$ with $calF_n$-measurable $T<=n$ for every $n$, we can consider a monotone boolean sequence $ X_n = bb(1)_({T<=n}) $ and then $T$ is given from $X_bullet$ as the infimum above.

A _stopping time_ for a filtration $calF_(bullet)$ is any $bb(N)$-valued random variable for which 
$ forall n: wide { T<=n } " is " calF_n"-measurable" , $
i.e. it is the time at which an observed property (in the sense of a monotonic boolean sequence) "stops" holding.

= Conditional expectation

If $cal(G) subset calF$ are $sigma$-algebras on $Omega$, and $X: Omega -> E$ is a function,
#align(center,grid(
  columns: 4,
  column-gutter: 1em,
  row-gutter: .5em,
  grid.cell(align: right,[then]),
  [$cal(G)$-measurability],
  grid.cell([is a stronger], rowspan:2, align: horizon),
  [restriction on $X$ than $calF$-measurability,],

  grid.cell(align: right,[because]),
  $X^(-1)(A) in cal(G)$, [condition than $X^(-1)(A) in cal(F)$.]
))
That is, an event $A in E$ is allowed to reveal less information on the run $omega$ in the $cal(G)$ case than in the $calF$ case, just because $cal(G)$ contains less information than $calF$.

Thus an $calF$-measurable $X$ need not be $cal(G)$-measurable. //Take an $e in E$ whose preimage under $X$ is in $calF$ but not in $cal(G)$.

//Assume that $cal(G)$ is finitely generated by random variables $ cal(G) = sigma(Y,Z, thick "whatever") $

TODO

#import "@preview/ctheorems:1.1.3": thmbox, thmproof, thmrules
#show: thmrules

#let definition = thmbox("definition", "Definition", inset: 1em, fill: aqua.transparentize(70%))
#let notation = thmbox("definition", "Notation", inset: 1em, fill: aqua.transparentize(70%))
#let remark = thmbox("definition", "Remark", inset: (x: 1em, y: 1em), fill: teal.transparentize(80%))
#let prop = thmbox("theorem", "Proposition", inset: 1em, fill: olive.lighten(80%))
#let proof = thmproof("proof", "Proof", inset: (x: 0pt))
#show: thmrules.with(qed-symbol: a => math.square)

= Martingales

Recall that an $calF_bullet$-*martingale* is an $calF_bullet$-adapted process $X_bullet$ with
zero-$calF_n$-expectation increments $Delta X_(n+1) = X_(n+1) - X_n$:

#definition("Martingale")[
  An $calF_bullet$-adapted process $X_bullet$ is a called a *martingale* if  
  $ forall n: EE[Delta X_(n+1)|calF_n]=0. $
]

I prefer that phrasing of the definition because I find it more natural than the standard one. By
writing
$ 0=EE[Delta X_(n+1)|calF_n]= EE[X_(n+1)|calF_n] - EE[X_n|calF_n] $
as $EE[X_(n+1)|calF_n] = EE[X_n|calF_n]$
and applying
$calF_n$-measurability to $X_n$, one gets equivalently

#definition("Martingale, standard")[
  An $calF_bullet$-adapted process $X_bullet$ is a called a *martingale* if  
  $ forall n: EE[X_(n+1)|calF_n]=X_n. $
]

Note that we can always decompose a process into the sum of its increments up a given time, i.e.
$ forall n: X_n = X_0 + sum_(i=1)^n Delta X_i. $
Here again $Delta X_i$ denotes the "backwards" increment, $Delta X_(i+1)=X_(i+1) - X_i$.

Now it is natural to ask, what happens if we scale the increments of a martingale, i.e. multiply
each term in the above sum by some factor.

#let martra = $dot.circle$

#definition("Martingale transform")[
  For an $calF_bullet$-martingale $X_bullet$ and a predictable $H_bullet$, the martingale
transform of $X_bullet$ by $H_bullet$ is denoted by $(H martra X)_bullet$ and defined by
      $ (H martra X)_n := sum_(i=1)^n H_i Delta X_i. $
]

Using this notion, a martingale can be characterized not only by having its _individual_ 
increments-means vanish, but by having (only) the final expectation of of all of its increments-transforms vanish:

#let iff(xinset: 1em, left, right) = grid(
  columns: 3, inset: (x: xinset), align: horizon,
  left,
  [if an only if], 
  right
)

#prop[
  Let $X_bullet$ be $calF_bullet$-adapted.

  #align(center,iff(
    [$X_bullet$ is a martingale],
    [
      for any predictable $H_bullet$, $EE[(H martra X)_N]=0. $
    ]
  ))
]

#pagebreak()

= Discrete-time market model

This section follows the first chapter of the book "Introduction to Stochastic Calculus Applied to Finance" (Lamberton & Lapeyre), whose explanations I found missing or unsatisfactory so I enhance the presentation with as much motivation as possible.

#grid(
  columns: (3fr, 3fr),
  gutter: 1em,
  [
    The market price vector is a stochastic process $ S_i, space i=0,... $
    with values in $RR^(1+d)$
    adapted to a filtration $ cal(F_i), space i=0,... $ of the market state known at time $i$.
    We consider $d in NN$, $calF_bullet$ and $S_bullet$ fixed from now on.

    The number $1+d$ reflects that we track $d$ risky assets and one riskless asset (the time-value of money) in the first component of $RR^(1+d)$.

    #definition[
    A _trading strategy_ is any $RR^(1+d)$-valued _predictable_ sequence $ phi.alt_i, space i=0,... $ with respect to that filtration.]
    Predictable means that $phi.alt_(i+1)$ is $calF_i$-measurable, i.e. the information used (revealed) by the _next_ portfolio $phi.alt_(i+1)$ is restricted to the information provided by the current market state $cal(F)_i$, which is only guaranteed to contain the current stock prices (because $S_i$ is $cal(F)_i$-measurable) and past stock prices (because $cal(F)_i subset cal(F)_(i+1)$).

    #definition[
    The _value of the portfolio_ defined by a strategy $phi.alt_bullet$ is $ V_i (phi.alt):= phi.alt_i dot S_i. $]

    Now a slight confusion may arise as to what is the time order of the quantities $S_i$ and
    $phi.alt_i$. They both use the same index $i$ so we might be under the impression that the time
    evolution is described by a sequence of pairs $(phi.alt_i,S_i)$. While not false, this may be
    deceiving when we define _self-financing_ strategies. Consider the diagram on the right.
  ],
  diagram(
    edge-stroke: .9pt,
    spacing: (.4cm, 1cm),
    // debug: 1,
    {
      let dimmed = luma(16*10) + .5pt
      node((0,0.3), $cal(F)$)
      node((1,0.3), $phi.alt$)
      node((2,0.3), $S$)
      node((4,0.3), $V$)

      // F_0
      node((0,1.5), $cal(F_0)$)
      node(enclose: ((0,1.5),(2,1), (2,2)), fill: aqua.transparentize(60%), snap: -1)

      node((1,1), $phi.alt_0$)
      edge("d", "->")
      node((2,1), $S_0$)
      edge("d", "=", stroke: dimmed)
      node((2,2), text(fill: dimmed.paint, $S_0$))
      edge("d", "->")
      node((1,2), $phi.alt_1$)
      edge("d", "=", stroke: dimmed)
      edge("dr", "..>", stroke: .4pt)
      node((3,1), "Init")
      node((3,2), [Adjust\ portfolio])
      node((4,1), $V_0=phi.alt_0 dot S_0$)
      node((4,2), $V'_0=phi.alt_1 dot S_0$)

      //  F_1
      node((0,3.5), $cal(F_1)$)
      node(enclose: ((0,3.5),(2,3), (2,4)), fill: aqua.transparentize(60%), snap: -1)

      node((1,3), text(fill: dimmed.paint, $phi.alt_1$))
      edge("d", "->")
      node((2,3), $S_1$)
      edge("d", "=", stroke: dimmed)
      edge("dl", "..>", stroke: .4pt)
      node((2,4), text(fill: dimmed.paint, $S_1$))
      edge("d", "->")
      node((1,4), $phi.alt_2$)
      edge("d", "=", stroke: dimmed)
      edge("dr", "..>", stroke: .4pt)
      node((3,3), [Change\ prices])
      node((3,4), [Adjust\ portfolio])
      node((4,3), $V_1=phi.alt_1 dot S_1$)
      node((4,4), $V'_1=phi.alt_2 dot S_1$)

      // F_2
      node((0,5.5), $cal(F_2)$)
      node(enclose: ((0,5.5),(2,5), (2,6)), fill: aqua.transparentize(60%), snap: -1)

      node((1,5), text(fill: dimmed.paint, $phi.alt_2$))
      edge("d", "->")
      node((2,5), $S_2$)
      edge("d", "=", stroke: dimmed)
      edge("dl", "..>", stroke: .4pt)
      node((2,6), text(fill: dimmed.paint, $S_2$))
      edge("d", "..")
      node((1,6), $phi.alt_3$)
      edge("d", "..")
      node((3,5), [Change\ prices])
      node((3,6), [Adjust\ portfolio])
      node((4,5), $V_2=phi.alt_2 dot S_2$)
      node((4,6), $V'_2=phi.alt_3 dot S_2$)
    }) + [

Here, in each timebox $cal(F)_i$, first prices change and then the portfolio is adjusted,
so we have an alternating sequence of price and portfolio changes.\
The strategy $phi.alt$ is then self-financing iff the portfolio value doesn't change within a
timebox ($V_i = V'_i$), but only responds to stock price changes $S_i -> S_(i+1)$.

Diagonal dotted arrows indicate the causal relationship between the time-evolution of the strategy and the stock prices in the process $(phi.alt_0, S_0), (phi.alt_1, S_1), ...$.
])

#notation[
Denote the _portfolio adjustment_ (again, non-standard terminology) performed at time $i$ by $ Delta phi.alt_i := phi.alt_(i+1) - phi.alt_i. $
(consider the diagram above to convince yourself that $Delta phi.alt_i$ is $calF_i$-measurable)]
It is a vector of the sells/buys of each stock performed at time $i$. That is,

#align(center,box(stroke:.3pt, inset: 8pt)[
$Delta phi.alt_i^j$
is the amount of stock $j$ that is sold (if $Delta phi.alt_i < 0$) or bought (if $Delta phi.alt_i > 0$) at time $i$.
])

#notation[
  Denote the _price changes_ that happened at time $n+1$ by $ Delta S_(n+1) := S_(n+1) - S_n. $
]

#remark[
  $Delta phi.alt_n$ was defined as the _forward_ difference (between times $n+1$ and $n$),
  while the $Delta S_n$ was defined as the _past_ difference (between times $n$ and $n-1$), so that
  both $Delta phi.alt_n$ and $Delta S_n$ are $calF_n$-measurable.
]

#import "@preview/mannot:0.3.0": mark, annot

We also get a Leibniz rule for $V_bullet$ ($dif V = dif phi.alt dot S + dif S dot phi.alt$).
#remark[
  The two increments let us express the portfolio value with a recursive formula:
  $ mark(V_(n+1) (phi.alt), tag: #<next>) =
  mark(V_n (phi.alt), tag: #<prev>) 
  + mark(Delta phi.alt_n dot S_n, tag: #<strat>)
  + mark(phi.alt_(n+1) dot Delta S_n, tag: #<price>).

  #annot(<next>, align(center)[next\ value])
  #annot(<prev>, align(center)[prev\ value])
  #annot(<strat>, align(center)[changes in\ strategy])
  #annot(<price>, align(center)[changes in\ prices])
  $
  #v(1em)
  That is, the next value is the previous value plus the changes from the strategy and the changes in the prices.
]

== Self-financing strategies

#let phii = $phi.alt$
When the second term in the sum on the right in the remark above, $Delta phi.alt_n dot S_n$, vanishes for all $n$, we get a very important type of
strategies. Denote the first part of recursive formula by
$ V'_n (phi.alt) = V_n (phi.alt) + Delta phi.alt_n dot S_n, $
so that $ V_(n+1)(phi.alt)=V'_n (phi.alt) + phi.alt_(n+1) dot Delta S_n. $

Those two mutually-recursive formulas reflect the structure of the alternating sequence $V_0, V'_0, V_1, V'_1, ...$ in the diagram above, so
#remark[
  $V'_n (phi.alt)$ is the _adjusted value_ of the portfolio *after* the next strategy choices
  $phi.alt_(n+1)$ are applied but *before* the prices have been updated. 
]

Now the condition that the second term in the earlier recursive formula for $V(phii)$ vanishes for
all $n$ can be phrased simply as the equality $V(phii)=V'(phii)$ (as processes). A direct expression for
$V'$ is $ V'_n (phi.alt) := phi.alt_(n+1) dot S_n. $

#definition[
A strategy $phi.alt_i$ is _self-financing_ if the value of the portfolio stays the same after the strategy adjustment:
$ V_i (phi.alt) = V'_i (phi.alt) wide "for all" i, $
i.e.
$ phi.alt_(i+1) dot S_i = phi.alt_i dot S_i wide "for all" i. $
]

Now we can get back to the condition on the vanishing second term in the recursive formula for $V$:

#remark[
The self-financing condition $V_i = V'_i$ is equivalent to $ Delta phi.alt_i dot S_i = 0, $
i.e. all buys and sells cancel each other in value, i.e. no money is lost or needs to be brought in for the adjustment.
That is, a self-financing strategy is one where the recursive formula above for the portfolio value has a vanishing second term, and then
  $ V_(n+1) (phi.alt) = V_n (phi.alt) + phi.alt_(n+1) dot Delta S_n. $
]

It should be close to mind that even for a strategy that is not self-financing,
if we were to put the quantity $Delta phi.alt_n dot S_n$ into $phi.alt_n^0$,
i.e. if we invest (borrow) the surplus (shortage) of sells-minus-buys into (from) the riskless asset, we'd get a self-financing strategy.

#prop[
  Any $RR^d$-valued predictable sequence (a "strategy" only on the risky assets)
  $ (phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
  is a restriction of a unique self-financing strategy ($RR^(1+d)$-valued) 
  $ (bold(phi.alt_n^0), phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
  for any choice of an initial value $V_0(phi.alt) in RR$ (or a choice of any of $phi.alt_n^0$ for
  $n>=0$).
]

In other words, the self-financing strategies restricting to a given $(phi.alt_n^1, ..., phi.alt_n^d)_n$ are a one-parameter family indexed by $V_0$.

#proof[
  Fix $underline(phi.alt)_n = (phi.alt_n^1, ..., phi.alt_n^d)$ for all $n >= 0$.
  Any strategy $phi.alt_bullet$ that (on the risky assets) restricts to this process is determined
  by the choices of bank account amounts $phi_bullet^0$.

  The self-financing condition $Delta phi.alt_n dot S_n = 0$ imposes a restriction on
  $phi_bullet^0$, though, and reads 
  $
  underbrace((phi.alt_(n+1)^0 - phi.alt_n^0)) dot S_n^0 + sum_(i=1)^d (phi.alt_1^i - phi.alt_n^i) dot S_n^i = 0 wide "for all" n=0,1,... .
  $

  Here a choice of any element of the sequence $phi.alt_bullet^0$ determines the rest, so the self-financing
  strategies restricting to $underline(phi.alt)_n$ are a one-parametric family indexed by (e.g.) $phi.alt_0^0$. 

  Since $V_0 equiv phi.alt_0^0 dot S_0 + sum_(i=1)^d phi.alt_0^i dot S_0^i$ establishes a 1:1
  relation between $V_0$ and $phi.alt_0^0$ (given $underline(phi.alt)_0$),
  we can also consider this parameter to be $V_0$.
]

== Arbitrage

#definition[
  A _self-financing_ strategy is called *admissible* if $V_n (phi.alt) >= 0$ for all $n$ (and all
  $omega in Omega$).
]

We fix an $N in NN$, called the _horizon_.

#let cbox(c) = box(align(center, c))
#let small(c) = text(size: 9pt, c)

The market is said to have an *arbitrage opportunity* if some admissible strategy with zero initial value delivers a strictly positive value on a non-null set. \
That is, an arbitrage opportunity is a
#align(center,
grid(columns: 3, row-gutter: .5em, column-gutter: 1em,
  [*zero-investment*],
  [*risk-free*],
  [*profit*.],
  small[($V_0=0$)],
  small[($V_n >= 0$\ for _every_ $omega$ and $n$)],
  small[($V_N gt.nequiv 0$\ on a non-null set)],
))

A market without arbitrage opportunities is called viable.

#definition[
  The market is called *viable* if every admissible strategy with $V_0 (phi.alt) = 0$ satisfies
  $V_N (phi.alt) = 0$.
]

As a silly (counter)example, if 
$ 
"at " n=0, quad &S^1_0 = S^0_0 \
"at " n>0, quad &S^1_n = 2 dot S^0_n,
$
 i.e. the price of risky asset 1 is the same at first but then becomes
twice as much as the riskless one, then the constant strategy $phi.alt_n = (-1,1)$ has zero initial value and $V_n = - S^0_n + S^1_n = S_n^0>0$. Thus the market defined by those $S_bullet^bullet$ is not viable.

== Perfect hedging (attainable claims)

#show sym.emptyset: set text(font: "") // makes emptyset appear the proper way, and not squished

A *contingent claim* is a promise to pay some amount $h$ at a _maturity time_ $T$, the amount depending on the market state.
We model it by a non-negative real random variable $h$ that is only $calF_T$-measurable, so the
amount might not be known in advance.

#remark[
  Consider a contingent claim $h$ at a maturity time $T$.

  If all admissible strategies $phi.alt$ induce a portfolio value at $T$ that is 
  - _less_ than $h$, the contingent claim is essentially "free money" for the receiver;
  - _greater_ than $h$, 
]

#definition[
  An $RR$-valued random variable $h$ is called *attainable* if there exists an admissible strategy $phi.alt$ that results in the end in a portfolio of value exactly $h$:
  $ V_N (phi.alt)=h. $
]

#remark[
  If $h$ is a constant $h(omega) = M in RR_+$, it is trivially attainable by the strategy 
  with $phi.alt_N^0 = M$ that is the constant zero on the risky assets 
  (exists uniquely by the proposition above, and is obviously admissible).

  Even if $h$ is only _bounded_ by a constant, $h<=M$, we could attain the (higher) value $M$ by the same approach.
  Thus attainability is _not_ essentially about reaching _at least_ some value --- we are allowed to
  start with as much cash in advance as we need.

  In the case of a finite $Omega$ (which is assumed in the book), $h$ is bounded anyway. 
  Attaining $h$, and not just $M$, is more difficult. 
  If $h$ is not $calF_0$-measurable, we cannot just prepare the cash in advance, because we are not
  allowed (by $calF_0$) to know exactly how much we will need (even if know it won't exceed $M$).

  For example, if $calF_0 = {emptyset, Omega}$, the initial cash $phi.alt_0^0$ is only allowed to be
  constant (by $calF_0$-measurability). Thus even in the bounded case we have to make use of the
  risky assets to achieve the precise target $h$, and we have to abide by $calF_n$-measurability all
  the way $n=0,...,N$.
]

#definition[
  The market is called _complete_ if every non-negative $h$ is attainable.
]
