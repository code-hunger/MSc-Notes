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
  + we can usually only "look" at the experiment, and _observe_ values of projections $X: Omega -> E$ onto other sets $E$.\

=== Events
Such a set of runs $A$, that we can know if $omega$ lies in, is called _an event_ and is only allowed to be in #calF. Thus it is in the domain of $PP$ and has a well-defined _probability_ $PP(A)$. The model does not really talk about whether a run is in a set not in $calF$.

=== Random variables
If we observe a particular value $e = X(omega)$ through a projection $X:Omega -> E$, then we know that the run that happened lies in $X^(-1)({e}) subset Omega.$
But we're only allowed to know if $omega$ is in $calF$-sets, so the only (sets of) values $A subset E$ (including the case $A={e}$) we are allowed to observe from $X$ must have measurable preimages $X^(-1)(A) in calF$. Thus to model observables we use _measurable_ functions $X: Omega -> E$ into measure spaces $E$, and we call $X$ a _random variable_.

In this sense, $calF$ is a restriction on the nature of all random variables, containing the information _that is allowed to be known_ and revealed by any observables.

= Experiments that happen in time
Imagine we're observing an experiment that is laid out as a process over time $NN$. 

== Atomicity of history
A single run $omega$ of the experiment contains the whole history of the process. 
That is, from a mathematical point of view, the future is predetermined.

As time evolves in the real world, though, we can only observe what is _currently_ happening, and not the whole history, even though in theory it already "happened". Many runs of the experiment may have the same observable properties up to a particular time $n in NN$, thus we only know that the run $omega$ we're observing lies in a (probably large) measurable subset of $Omega$ containing runs of the same observed history up to now but different futures.

For any $n$, let $calF_n subset calF$ contain all maximal sets of events that share a common observable property up to time $n$ or earlier. That is, $calF_n$ contains only, and all, sets of runs that a particular run can be determined to lie in, by observing it up to time $n$. Then trivially $calF_n subset calF_m$ for all $n <= m$. 

If two runs $omega$ and $omega'$ differ in no observable way up to time $n$, they are not $calF_n$-separable.

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

#import "@preview/cetz:0.4.2"
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

A _stopping time_ for a filtration $calF_(bullet)$ is a $bb(N)$-valued random variable, equivalently a random boolean sequence,
equivalently a sequence of events.

= Conditional expectation

If $cal(G) subset calF$ are $sigma$-algebras on $Omega$, and $X: Omega -> E$ is a function, then $cal(G)$-measurability is a stronger restriction on $X$ than $calF$-measurability because $X^(-1)(A) in cal(G)$ is a stronger condition than $X^(-1)(A) in cal(F)$. That is, an event $A in E$ is allowed to reveal less information on the run $omega$ in the $cal(G)$ case than in the $calF$ case, just because $cal(G)$ contains less information than $calF$.

Thus an $calF$-measurable $X$ need not be $cal(G)$-measurable. //Take an $e in E$ whose preimage under $X$ is in $calF$ but not in $cal(G)$.

Assume that $cal(G)$ is finitely generated by random variables $ cal(G) = sigma(Y,Z, thick "whatever") $

#pagebreak()

= Discrete-time market model

This section follows the first chapter of the book "Introduction to Stochastic Calculus Applied to Finance" (Lamberton & Lapeyre), whose explanations I found missing or unsatisfactory so I enhance the presentation with as much motivation as possible.

#import "@preview/ctheorems:1.1.3": *
#show: thmrules

#let definition = thmbox("definition", "Definition", inset: (x: 0pt, top: 0em))
#let notation = thmbox("definition", "Notation", inset: (x: 0pt, top: 0em))
#let remark = thmbox("definition", "Remark", inset: (x: 0pt, top: 0em))
#let prop = thmbox("theorem", "Proposition", inset: (x: 0pt, top: 0em))
#let proof = thmproof("proof", "Proof", inset: (x: 0pt))
#show: thmrules.with(qed-symbol: a => math.square)

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
    The _value of the portfolio_ defined by a strategy $phi.alt_i$ is $ V_i (phi.alt):= phi.alt_i dot S_i. $]

    Now a slight confusion may arise as to what is the time order of the quantities $S_i$ and
    $phi.alt_i$. They both use the same index $i$ so we might be under the impression that the time
    evolution is described by a sequence of pairs $(phi.alt_i,S_i)$. While not false, this may be
    deceiving when we define _self-financing_ strategies. Consider the diagram on the right. Thus we put (non-standard notation)

    #definition[
    The _adjusted value of the portfolio_ at time $i$ after the new strategy $phi.alt_(i+1)$ is applied is 
    $ V'_i (phi.alt) := phi.alt_(i+1) dot S_i $
  ]
    It is still $cal(F)_i$-measurable.
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

#align(center)[
$Delta phi.alt_i^j$
is the amount of stock $j$ that is sold (if $Delta phi.alt_i < 0$) or bought (if $Delta phi.alt_i > 0$) at time $i$.
]

#notation[
  Denote the _price changes_ that happened at time $n+1$ by $ Delta S_(n+1) := S_(n+1) - S_n. $
]

#remark[
  $Delta phi.alt_n$ was defined as the _forward_ difference (between times $n+1$ and $n$),
  while the $Delta S_n$ was defined as the _past_ difference (between times $n$ and $n-1$), so that
  both $Delta phi.alt_n$ and $Delta S_n$ are $calF_n$-measurable.
]

== Self-financing strategies

#definition[
A strategy $phi.alt_i$ is _self-financing_ if the value of the portfolio stays the same after the adjustment:
$ V_i (phi.alt) = V'_i (phi.alt) wide "for all" i, $
i.e.
$phi.alt_(i+1) dot S_i = phi.alt_i dot S_i $
for all $i$.]

#remark[
The self-financing condition $V_i = V'_i$ is equivalent to $ Delta phi.alt_i dot S_i = 0, $
i.e. all buys and sells cancel each other in value, i.e. no money is lost or needs to be brought in for the adjustment.

It should be close to mind that even for a strategy that is not self-financing,
if we were to put the quantity $Delta phi.alt_n dot S_n$ into $phi.alt_n^0$,
i.e. if we invest (borrow) the surplus (shortage) of sells-buys into (from) the riskless asset, we'd get a self-financing strategy.
]

#prop[
  Any $RR^d$-valued predictable sequence (a "strategy" only on the risky assets)
  $ (phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
  is a restriction of a unique self-financing strategy ($RR^(1+d)$-valued) 
  $ (bold(phi.alt_n^0), phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
  for any choice of an initial value $V_0(phi.alt) in RR$.
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

#prop[

]
