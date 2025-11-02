#import "@preview/cetz:0.4.2"

== Basic solutions

Given a linear map $A: RR^n -> RR^m $ and a vector in its range $b in RR^m$,
form the linear system $A x = b$.

A basis ${e_1...e_n}$ in the domain of $A$ now gives many ways to express $b$ as a combination of the image of the
basis ${ A e_i }_i$: $ b = sum_(i in B) lambda_i A e_i $ for many choices of $m$-sized $B subset {1...n}$ and $lambda_i, i in B$.\
Not every choice for $B$ makes $b$ expressible as a combination of ${A e_i}_(i in B)$, but at least
one does.

For each such choice of $B$, we can rewrite $b = A sum_(i in B) lambda_i e_i$ and denote 
$ x_B := sum_(i in B) lambda_i e_i $
so that $b = A x_B$.

$x_B$ is now well-defined for any choice $B$ of (a subset of) basis vectors in the domain of $A$ whose images form a
basis of $A$'s range. Such $x_B$ are _special_ solutions to the system $A x=b$ and are called
_basic_ solutions.

Given $B$, those basis vectors $e_i$ that form $x_B$ are called _basic_, and the rest are called _non-basic_.
In the sketches below, we see copies of the non-basic $e_i$ attached to each basic solution $e_i$:

#let c = 30
#let rots = range(c).map(i =>(y: i * 360 / c * 1deg ))
#let rots = ((y: 180deg), (y: 84deg), (y: -132deg), (y: 156deg))

#grid(
  columns: 2, 
  inset: 1em,
  stroke: 1pt + silver,
  ..rots.map(rot=> {
    cetz.canvas(length: 2cm, {
      import cetz.draw: *

      rotate(..rot)

      line((-.8,0,0), (2,0,0), stroke: .5pt)
      line((0,-1.1,0), (0,.7,0), stroke: .5pt)
      line((0,0,-.8), (0,0,2), stroke: .5pt)

      line((1.8,.8,0), (1,0,0), (0,0,1), (0,.8,1.8), 
        fill: aqua.transparentize(60%), stroke: 1pt)

      line((1,0,0), (0,-1,0), (0,0,1), 
        stroke: (thickness: .5pt, dash: "densely-dotted"),
        fill: aqua.transparentize(90%))

      let vec(from, to, ..rest) = line(from, to, mark: (end: ">>"), stroke: .5pt, ..rest)
      vec((1,0,0), (1,.7,0))
      vec((1,0,0), (1,0, .7))
      content((rel: (0,0,-.3), to: (1,0,0)), $v_1$)

      vec((0,0,1), ( 0, .7, 1))
      vec((0,0,1), (.7,  0, 1))
      content((rel: (-.2,0,0), to: (0,0,1)), $v_2$)

      line((0,-1,0), (0 ,-1,.7), mark: (end: ">>"), stroke: (thickness: .5pt, dash: "densely-dashed"))
      line((0,-1,0), (.7,-1, 0), mark: (end: ">>"), stroke: (thickness: .5pt, dash: "densely-dashed"))
      content((rel: (0,-.2,0), to: (0,-1,0)), $v_3$)
    }) //+ [#rot]
  })
)
