#import "@preview/cetz:0.4.2"

#set page("a4")

#let c = 30
#let rots = range(c).map(i =>(y: i * 360 / c * 1deg ))
// #let rots = ((y: -132deg), (y: 180deg), (y: 84deg), (y: 156deg))

Given a linear map $A: RR^n -> RR^m $ and a vector in its range $b in RR^m$,
form the linear system $A x = b$.

A basis ${e_1...e_n}$ in the domain of $A$ now gives many ways to express $b$ as a combination of the image of the
basis ${ A e_i }_i$: $ b = sum_(i in B) lambda_i A e_i $ for many choices of $m$-sized $B subset {1...n}$ and $lambda_i,
i in B$.

For each such choice of $B$, we can rewrite $ b = A sum_(i in B) lambda_i e_i $ and denote 
$ x_B := sum_(i in B) lambda_i e_i. $

$x_B$ is now well-defined for any choice of (a subset of) basis vectors in the domain of $A$ whose images form a
basis of $A$'s range. Such $x_B$ are _special_ solutions to the system $A x=b$ and are called
_basic_ solutions.

A general solution $x$ can be decomposed as $ x = x_B + x_N $ which defines $x_N$. 
Put $N = {1...n}\\B$. 
Since $x$ is a combination of ${e_1...e_n}$ and $x_B$ is a (unique) combination of the $B$
subset of the basis vectors, $x_N$ is then a (unique) combination of the rest of the basis vectors.

#grid(
  columns: 2, 
  inset: 1em,
  stroke: 1pt + silver,
  ..rots.map(rot=> {
    cetz.canvas(length: 2cm, {
      import cetz.draw: *

      rotate(..rot)

      line((-1,0,0), (2,0,0), stroke: .5pt)
      line((0,-1,0), (0,.7,0), stroke: .5pt)
      line((0,0,-1), (0,0,2), stroke: .5pt)

      line((1.8,.8,0), (1,0,0), (0,0,1), (0,.8,1.8), 
        fill: aqua.transparentize(60%), stroke: 1pt)

      line((1,0,0), (0,-1,0), (0,0,1), 
        stroke: (thickness: .5pt, dash: "densely-dotted"),
        fill: aqua.transparentize(90%))

      line((1,0,0), (1,.7,0), mark: (end: ">"), stroke: .5pt)
      line((1,0,0), (1,0, .7), mark: (end: ">"), stroke: .5pt)

      line((0,0,1), (0, .7,1), mark: (end: ">"), stroke: .5pt)
      line((0,0,1), ( .7,0,1), mark: (end: ">"), stroke: .5pt)

      line((0,-1,0), (0 ,-1,.7), mark: (end: ">"), stroke: (thickness: .5pt, dash: "densely-dashed"))
      line((0,-1,0), (.7,-1, 0), mark: (end: ">"), stroke: (thickness: .5pt, dash: "densely-dashed"))
    }) + [#rot]
  })
)
