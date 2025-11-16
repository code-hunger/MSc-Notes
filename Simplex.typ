#import "@preview/cetz:0.4.2"
#import "@preview/mannot:0.3.0": mark, annot

== Basic solutions

#let c = 30
#let rots = range(c).map(i =>(y: i * 360 / c * 1deg ))
#let rots = ( (y: 180deg)
            , (y: 84deg)
            , (y: -132deg)
            // , (y: 156deg)
)

#grid(
  columns: ( auto, auto ),
  gutter: 1em,
  [
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
    basis of $A$'s range. Such $x_B$ are special solutions to the system $A x=b$ and are called
    *basic* solutions.

    Given $B$, those basis vectors $e_i$ that form $x_B$ are called *basic*, and the rest are called *non-basic*.
    In the sketches to the side, we see copies of the non-basic $e_i$ attached to each basic solution $e_i$.

    The solutions of $A x=b$ are in general of the form 
    #align(
      center,
      grid(gutter: 1em, columns: (auto,auto,auto), align: horizon,
      [one particular solution\ of $A x=b$] , $+$ , [a solution of\ the homogeneous system\ $A x=0$])
    )
    $ x_0 + x $

    Different choices for $x_0$ give rise to different representations of the solution space. Next,
    we'll see what happens when we put _basic_ solutions for $x_0$.
  ],
  for rot in rots [
    #cetz.canvas(length: 2cm, {
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
  ]
)

== Basic and non-basic variables

Given $B$ and $x_B = sum_(i in B) lambda_i e_i$, we get two natural decompositions of an arbitrary solution $x= sum_i lambda_i e_i$, $A x = b$:

#grid(
  columns: (1fr, 1fr),
  inset: (x: 1em),
  block(breakable: false)[
    1. Its basic and its non-basic parts, 
    $ x = underbrace(sum_(i in B) mu_i e_i, "basic part") 
    + underbrace(sum_(i in.not B) mu_i e_i, "non-basic part"). $
    Keeping $B$ fixed and varying $x$, we call $lambda_i, i in B$ the _basic_ variables, and $lambda_i, i in.not B$ --- the non-basic
    variables.
  ],
  grid.vline(),
  [
    2. The basic solution plus a direction, $ x = x_B + (x-x_B). $
    We can see $x-x_B$ as the direction pointing from $x_B$ to $x$; it lies in the kernel of $A$.

    Keeping $x_B$ fixed and varying $x$, we get different directions $x-x_B$ out of $x_B$.
  ]
)

TODO show how the two are related

== Feasibility
The above discussion may looks as if it is about a general linear system, but it also presupposes a
_choice of basis_ is given, ${e_1...e_n}$. The definition of basic solutions, though, is invariant to
scaling the basis vectors, i.e. it only depends on the choice of $n$ independent _lines_.

In linear problems we also have inequality constraints, which in standard form take the shape of
$x>=0$, meaning that all components of $x$ _in the given basis_ should be non-negative. 

That is, the choice of basis determines a cone of positivity (in the 3D pictures above --- an octant in the coordinate system), and solutions to $A x=0$ are called _feasible_ only if they lie in that cone.

In particular, basic solutions, too, fall into two classes: basic feasible solutions and basic
infeasible solutions. In the sketches above, $v_1,v_2$ are feasible and $v_3$ is infeasible.

== Reduced cost
#let an(c) = $angle.l #c angle.r$
#let la = $angle.l$
#let ra = $angle.r$
Given a $B$, we represent an arbitrary solution in the form $x = x_B + (x-x_B)$. Then an objective
function given by $f(x)= la c,x ra$ acts on an arbitrary $x$ by
$ f(x) = f(x_B+(x-x_B)) = la c, x_B ra + la c, x-x_B ra $

When $x=x_B$, then $f(x) = la c, x_B ra$, i.e. the left term above is the value of $f$ at that basic solution.

TODO show how $la c, x-x_B ra$ is computed.
