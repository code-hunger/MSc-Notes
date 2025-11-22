#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/ctheorems:1.1.3": thmbox, thmproof, thmrules

#set text( font: "New Computer Modern")
#set par(justify: true)

#show: thmrules

#let definition = thmbox("definition", "Definition", inset: 1em, fill: aqua.transparentize(70%))
#let notation = thmbox("definition", "Notation", inset: 1em, fill: aqua.transparentize(70%))
#let remark = thmbox("definition", "Remark", inset: (x: 1em, y: 1em), fill: teal.transparentize(80%))
#let prop = thmbox("theorem", "Proposition", inset: 1em, fill: olive.lighten(80%))
#let proof = thmproof("proof", "Proof", inset: (x: 0pt))
#show: thmrules.with(qed-symbol: a => math.square)

#let phii = $phi.alt$
#let tS = $tilde(S)$
#let tV = $tilde(V)$
#let martra = $triangle.filled.small.r$
#let calF = $cal(F)$

#let iff(columns: 3, xinset: 1em, yinset: 0pt, stroke: none, left, right) = grid(
  columns: columns, inset: (x: xinset, y: yinset), align: horizon, stroke: stroke,
  left,
  [if and only if], 
  right
)

#context if query(selector(<value-is-mart-transform>).before(here())) == () [
  Let us recall a few propositions from the main _Financial Maths Basics.pdf_ notes:

  #remark[
    For a self-financing strategy with $tV_0 (phii)=0$, if each $tilde(S)^j_bullet,j=0,...,d$ were a martingale, then $tV_bullet
    (phii)$ would be a sum of the martingale transforms of the prices by the strategy,
    $ tV_bullet (phii) = scripts(sum)_j \(phii^j martra tS^j)_bullet. $
  ]<value-is-mart-transform>

  #prop[
    Let $X_bullet$ be $calF_bullet$-adapted, with a time horizon $N$.

    #align(center,iff(
      [$X_bullet$ is a martingale],
      [
        for any predictable $H_bullet$,\ $EE[(H martra X)_N]=0. $
      ]
    ))
  ]<martingale-characterization>

  #prop[
    Any $RR^d$-valued predictable sequence (a "strategy" only on the risky assets)
    $ (phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
    is a restriction of a unique self-financing strategy ($RR^(1+d)$-valued) 
    $ (bold(phi.alt_n^0), phi.alt_n^1, ..., phi.alt_n^d) wide "for " n=0,1,... $
    for any choice of an initial value $V_0(phi.alt) in RR$ (or a choice of any of $phi.alt_n^0$ for
    $n>=0$).
  ]<risky-restriction-induces-selffin>
]

== Linear algebra
#let Strat = $sans("Strategy")$
#let SelfF = $sans("SelfFinancing")$
#let Adm = $sans("Admissible")$

#remark[
  The set of strategies on $Omega$ clearly forms a vector space under pointwise addition and scalar-multiplication, denote it #Strat.\

  With a finite time horizon $N$, $#Strat = RR^((1+d) times (1+N) times Omega)$,\
  and with an infinite horizon $#Strat = RR^((1+d) times NN times Omega)$.

  Self-financing strategies are filtered from it by the linear condition $phii_(n+1) S_n = phii_n S_n$, so they form a subspace $SelfF subset Strat$.
]

Real random variables on $Omega$ form a vector space too, denote it by $RR^Omega$.

For each $n$ and each strategy $phii$, $V_n (phii)$ is a random variable, so a vector $V_n (phii) in
RR^Omega$. Now we can consider how the dependence on $phii$ looks like:

#remark[
  For any $n$, the operator $V_n (phii) = phii_n dot S_n$ is linear in $phii$. Its signature is
  $ V_n : Strat -> RR^Omega $

  Then the images of $Strat$ and $SelfF$ are linear subspaces of $RR^Omega$:
  $ V_n (SelfF) subset V_n (Strat) subset RR^Omega. $
  #text(size:8pt)[(the last inclusion might actually be an equality, TODO check)]
]

We will talk about strategies of zero initial capital, so it is useful to have
#notation[
  Denote the subsets of the above strategy spaces of those strategies that satisfy $V_0 (phii)=0$ by
  a superscript 0: $SelfF^0, Strat^0$.\
  Clearly they form subspaces of the respective spaces.
]

These terms allow us to reformulate @risky-restriction-induces-selffin in a clearer way:

#remark[
  For any $phii = (phii^0,phii^1,...,phii^d) in Strat$, denote by $underline(phii)$ the risky part of $phii$, $underline(phii) := (phii^1,...,phii^d)$.
  Then the projection $ Strat_(1+d) &-> Strat_d \ phii &mapsto underline(phii) $ is a linear map, where the $d$ and $d+1$ subscripts denote the number of assets the space considers.

  @risky-restriction-induces-selffin establishes that the linear map
  $
  SelfF_(1+d) &tilde.equiv Strat_d times RR \
  phii &mapsto (underline(phii), V_0 (phii))
  $
  is in fact an isomorphism.

  #let codim=$op("codim")$
  This allows us to compute $dim(SelfF_d)=dim(RR^(d times (1+N) times Omega) times RR) = 1 + d times (1+N) times Omega $
  and so
  $ codim(SelfF_(1+d)) &= dim(Strat_d)                &&- dim(SelfF_(1+d))\
                       &= ( 1+d ) times (1+N) times Omega &&- ( d times (1+N) times Omega +1)\
                       &= (1+N) times Omega - 1. $
]

== Arbitrage

#definition("Admissible strategy")[
  A _self-financing_ strategy is called *admissible* if $V_n (phi.alt) >= 0$ for all $n$ (and all
  $omega in Omega$).
]

#remark[
  The set of admissible strategies is closed under addition and non-negative scalar
  multiplication, so it forms a cone $#Adm subset SelfF$.

  Its image under $V_n$ is then a cone $V_n (Adm) subset V_n (SelfF) inter RR_+^Omega$.

  Like above, denote the set of zero initial capital admissible strategies by $Adm^0$.
]

Thus we get the following chain of strategy classes (here $N$ is either a finite number or equals $NN$, and $<=$ means $subset$ but for subspaces):

#align(
  center,
  diagram(spacing: (.5em, 0pt),
  {
    let dedge(to, sym: $<=$) = edge(to, stroke: none, label: sym, label-angle: auto, label-side: center)

    node((0,1), $RR^((1+N) times (1+d) times Omega)_(>=0)$)
    dedge("ur", sym: $supset$) 
    dedge("dr", sym: $supset$) 

    node((1, 0), Adm)
    dedge("r")
    node((2, 0), SelfF)
    dedge("r")
    node((3, 0), Strat)
    dedge("dr")

    node((4,1), $RR^((1+N) times (1+d) times Omega) ,$)

    node((1, 2), $Adm^0$)
    dedge("r")
    dedge("uu", sym: $subset$)
    node((2, 2), $SelfF^0$)
    dedge("r")
    dedge("uu")
    node((3, 2), $Strat^0$)
    dedge("uu")
    dedge("ur")
  })
)

and for each $n <= N$, the corresponding chain of images under $V_n : RR^(N times Omega) -> RR^Omega$:

#align(
  center,
  diagram(spacing: (.5em, 0pt),
  {
    let dedge(to, sym: $<=$) = edge(to, stroke: none, label: sym, label-angle: auto, label-side: center)

    node((0,1), $RR^Omega_(>=0)$)
    dedge("ur", sym: $supset$) 
    dedge("dr", sym: $supset$) 

    node((1, 0), $V_n (Adm)$)
    dedge("r")
    node((2, 0), $V_n (SelfF)$)
    dedge("r")
    node((3, 0), $V_n (Strat)$)
    dedge("dr")

    node((4,1), $RR^Omega .$)

    node((1, 2), $V_n (Adm^0)$)
    dedge("r")
    dedge("uu", sym: $subset$)
    node((2, 2), $V_n (SelfF^0)$)
    dedge("r")
    dedge("uu")
    node((3, 2), $V_n (Strat^0)$)
    dedge("uu")
    dedge("ur")
  })
)

We fix an $N in NN$, called the _horizon_. All indices $n,i,j,k$ below vary between 0 and $N$.

#let cbox(c) = box(align(center, c))
#let small(c) = text(size: 9pt, c)

The market is said to have an *arbitrage opportunity* if some admissible strategy with zero initial value delivers a strictly positive value on a non-null set. \
That is, an arbitrage opportunity is a
#align(center,
grid(columns: 3, row-gutter: .5em, column-gutter: 1em,
  [*zero-investment*],
  [*risk-free*],
  [*chance of profit*.],
  small[($V_0=0$)],
  small[($V_n >= 0$\ for _every_ $omega$ and $n$)],
  small[($V_N gt.nequiv 0$\ on a non-null set)],
))

A market without arbitrage opportunities is called viable.

#definition("Viable/arbitrage-free market")[
  The market is called *arbitrage-free* or *viable* if every admissible strategy with $V_0 (phi.alt) = 0$ satisfies
  $V_N (phi.alt) = 0$.

  In terms of the notation above, a market is viable if $V_N (Adm^0) = 0$.

  Spelled out fully, the market is viable if for all self-financing $phii$,\
  #align(center)[
    if #h(4pt) #box(baseline: 40%)[$forall n: V_n (phi.alt)>=0$\ and $V_0 (phi.alt)=0$],
    then $V_N (phi.alt)=0$.
  ]
]

As a silly (counter)example, if 
$ 
"at " n=0, quad &S^1_0 = S^0_0 \
"at " n>0, quad &S^1_n = 2 dot S^0_n,
$
i.e. the price of risky asset 1 equals the riskless at first but then becomes twice as much as the
riskless one, then the constant strategy $phi.alt_n = (-1,1)$ has zero initial value and $V_n = -
S^0_n + S^1_n = S_n^0>0$. Thus the market defined by those $S_bullet^bullet$ is not viable.

A viable market was defined by a condition on the terminal portfolio value $V_N (phii) = 0$ for all
_admissible_ strategies, but it is equivalent to require it from all self-financing strategies:

#prop[
  The risk-freeness condition ($V_n (phii) >= 0$) for arbitrage-free markets can also be required only for horizon time $N$:
  #iff(
  [A market is viable],
  [no strategy $phii in SelfF^0$ can provide $V_N (phii) in RR_(>=0)^Omega \\ { 0 }$.]
  )
]<viable-by-self-financing>

#proof[
  The $(arrow.l.double)$ direction is trivial, just because $Adm^0 subset SelfF^0$.

  For $(arrow.r.double)$, assume that no $phii in Adm^0$ gives $V_N (phii) in RR_(>=0)^Omega \\ {0}$
  and take a $phii in SelfF^0$ to show $V_N (phii) in.not RR_(>=0)^Omega \\ {0}$.

  If $phii in Adm^0$, we're done; now assume $phii$ is not admissible, i.e. gives a negative portfolio
  value $V_n (phii) < 0$ with positive probability at some time $n$.

  If $n = N$, we're done; now take $n$ to be the last such one. Then the strategy $phii$ with
  positive probability has negative value at $n<N$ and at all later times gives $V_bullet (phii) in
  RR_(>=0)^Omega$.
  
  TODO 
  // That is, $V_n (phii) = phii_n dot S_n < 0$ with positive probability but $V_(n+1) (phii) = phii_(n+1) dot S_(n+1) >= 0$ almost surely.
]

=== Fundamental theorem of asset pricing
#prop("Fundamental theorem of asset pricing")[
  #iff(
    [A market is arbitrage-free],
    [under some equivalent measure, the discounted price processes $tS_bullet^k, k=0,1,...$ are martingales.]
  )
]

Before we present the proof, this theorem deserves a bit of discussion.

#remark[
  Now the L&L book proceeds to prove this directly. I find the presentation of the proof there far
  from pedagogical, because they combined 4 distinct concepts in the same proof without clear
  indication which one is used where and how they are connected:
  + Interpreting viability in terms of only at-the-end lack of risk;
  + Treating martingales as processes having all their increments-transforms of zero-mean;
  + Relationship between value of self-financing strategies and martingale transforms;
  + Separation of a convex set from a linear subspace;
  They use all (1),(2),(4) only in the $(arrow.r.double)$ direction, and (3) only for $(arrow.l.double)$, and
  to me that makes the easy direction's (the one that does not use convex separation) proof look mysterious.
  But if we notice that (1) and (2) concern exclusively the left and right side of the equivalence,
  respectively, and (3) applies to each side individually, we can apply them upfront and make the
  proof conceptually shorter.

  (1) and (2) were already discussed as propositions above, so we can readily install them in the two
  sides of the theorem statement.
]

Applying the equivalence from @viable-by-self-financing and the characterization of martingales in @martingale-characterization, the proposition reads
#iff(stroke: (x,y)=> if(x != 1) {.5pt}, yinset: .5em,
  [
    #set par(justify: false)
    For any $phii in SelfF^0$,

    if $V_N (phii) >=0$, then $V_N (phii)= 0$.
  ],
  [
    #set par(justify: false)
    there exists $PP^*$ equivalent to $PP$,
    such that for any predictable $H_bullet$,
    $ EE^*[(H martra tS^j)_N]=0 quad "for all" j. $
  ]
)

#remark[
I find this phrasing illuminating, because by @value-is-mart-transform we know that self-financing
strategies of zero initial value, when applied on martingale prices, act like martingale transforms.
And here on the left side we have exactly such strategies, and on the right side - martingale
transforms of the prices.
]

In fact, can we rewrite the right side in terms of portfolio values of zero-investment
self-financing strategies then? That is, can we say that

#import "@preview/mannot:0.3.0": mark, annot

#prop[
  The way predictable $RR$-valued sequences act on process increments and the portfolio value of
  self-financing strategies with zero initial capital are related by the equivalence
  #set par(justify: false)
  #iff(
    [
      For all predictable $mark(H, tag: #<H>) #annot(<H>, [($RR$-valued)], pos: top)$ and each
      $mark(j, tag:#<j>) #annot(<j>, "(asset)", pos: top)$,
      $ EE[(H martra tS^j)_N]=0 $
    ],
    [for all $phii in SelfF^0$, $ EE[tV_N (phii)]=0 $]
  )
]<value-mean-zero-when-mart-transform-mean-zero>
(notice the similarity between the first lines on each side as well as between the second lines)

#proof[
  As discussed in @value-is-mart-transform, for a self-financing strategy, the discounted portfolio
  value is a martingale transform of the market prices,
  $ tV_N (phii)=sum_(j=0)^d (phii^j martra tS^j)_N,$
  so by linearity of $EE$ the right side condition can be replaced by $sum_j EE[(phii^j martra tS^j)_N]=0$.
  We prove the rest in the next proposition.
]

#prop[
  #iff(
    [
      For all predictable $mark(H, tag: #<H>) #annot(<H>, [($RR$-valued)], pos: top)$ and each
      $mark(j, tag:#<j>) #annot(<j>, "(asset)", pos: top)$,
      $ EE[(H martra tS^j)_N]=0 $
    ],
    [for all $phii in SelfF^0$, $ sum_j EE[phii^j martra tS^j]=0 $]
  )
]<predict-mean-zero-when-selff-mean-zero>

#proof($(arrow.r.double)$)[
  Assume the left side and take a $phii in SelfF^0$.
  All $phii^j$ are surely predictable, so each $(phii^j martra tS^j)_N$ has zero
  mean and the total gain expectation vanishes:
  $ EE^*[tV_N] 
  = EE^*[sum_j (phii^j martra tS^j)_N] 
  = sum_j underbrace(EE^*[(phii^j martra tS^j)_N],0) = 0. $
]

Before showing the other direction, a brief comment:
#remark[
  Notice that $tS^0$ is constant, so trivially $H martra tS^0 = 0$ and the condition on the left
  side here matters only for $j>0$. This is why in the proof in the book, instead of self-financing
  strategies, they consider predictable processes in $RR^d$ (and not $RR^(d+1)$). But I find this
  unnecessarily confusing, as we can reuse terms already established ($Adm^0$) and just point out that
  the $j$ on the right hand side can vary from 1 onwards.
]

#proof($(arrow.l.double)$)[
  Take a predictable $H$ and an asset $j$,
  we have to prove that $EE^*[(H martra tS^j)_N]=0$.

  If $j=0$, we are done by the preceding remark, so now $H$ can be regarded as a strategy operating
  only on a risky asset $j>0$.\
  By @risky-restriction-induces-selffin we can extend $H$ to a (unique) self-financing strategy
  $phii$ with $V_0 (phii) = 0$.

  But for $phii in SelfF^0$ we've assumed $ sum_j EE[phii^j martra tS^j]=0. $
  All sum terms except $i=j$ vanish because for $i=0$, $tS^i$ is constant; while for $i>0$ and
  $i!=j$, $phii^j$ is zero. And $phii^j$ is just $H$, so the sum consists simply of the term $EE (H martra S^j)_N$ and it is zero.
]

#let RRp = $RR_(>=0)$
Now we can rephrase the right side of the fundamental theorem of asset pricing again:
#iff(
  [
    #set par(justify: false)
    For any $phii in SelfF^0$,

    if $V_N (phii) >=0$, then $V_N (phii)= 0$.
  ],
  [
    #set par(justify: false)
    there exists $PP^*$ equivalent to $PP$, s.t. for any $phii in SelfF^0$,
    $ EE^*[tV_N (phii)]=0. $
  ]
)

Assuming that $calF=cal(P)(Omega)$ and $PP(omega)>0$ for all outcomes $omega in Omega$,
the equivalence $PP^*~PP$ means $forall omega: PP^*(omega) > 0$ as well. A mere geometrical
observation should now make the statement almost obvious:

#remark[
  Considering the object $PP^*$ as a vector in $RR^Omega$, for any $phii$ the mean $EE^* [tV_N
  (phii)]$ is just the dot product $PP^* dot tV_N (phii)$. 
  Then the condition $EE^* [tV_N (phii)] = 0$ for all $phii in SelfF^0$ means just that
  $PP^*$ must be orthogonal to $tV_N (SelfF^0)$. // $PP^* perp SelfF^0$.
]<geometric-remark>

So the theorem statement can be equivalently phrased as 

#prop("Fundamental theorem of asset pricing, again")[
  #align(center,
  iff(
    xinset: .5em,
    [$ V_N (SelfF^0) inter RRp^Omega = {0} $],
    [$ exists PP^* in RRp^Omega: PP^* perp tV_N (SelfF^0) $]
  )
)
]

Now _that_ phrasing should be geometrically quite clear.

#proof[
  #grid(
    columns: (auto,auto),
    inset: (x: .5em),
    [
      $(arrow.l.double).$ Assume $PP^*$ equivalent to $PP$ such that $ PP^* perp tV_N (SelfF^0). $
      Take an element 
      $
      f in underbrace(V_N (SelfF^0)) inter underbrace(RRp^Omega) \
       "Then" wide PP^* perp f quad "and" quad f >= 0,
      $
      i.e. $EE^*(f) = 0$ and $f>=0$, so $f=^(PP^*)0$.
    ],
    grid.vline(),
    [
      $(arrow.r.double).$ Assume $ tV_N (SelfF^0) inter RRp^Omega = {0}. $
      The left term is a linear space and the right term is convex, so by a standard separation
      theorem there exists a separating functional $EE^*$ on $RR^Omega$ vanishing on
      $tV_N (SelfF^0)$ and positive on $RRp^Omega$, or --- a unit (by $||dot||_1$) vector 
      $PP^* in RRp^Omega$ orthogonal to $tV_N (SelfF^0)$. 
    ]
  )
]

=== Summary
We summarize the proof and the preceding rewrites of the Fundamental theorem of asset pricing (FTAP).

#prop("Fundamental theorem of asset pricing")[
  For a market defined by the $RR^(1+d)$-valued process $S_bullet$, the following equivalences hold:

  #align(
    center,
    diagram(
      spacing: (2cm, 2em),
      {
        let eqq(to, label) = edge((0,to/3), "<->", stroke: .7pt, extrude: (-2.5,2.5), label: label, label-side: right)

        node((0,0), [The market is\ arbitrage-free])
        eqq(5, "By definition")
        edge("r", extrude: (-2.5,2.5), "<->", label: "FTAP", stroke: 1pt)
        node((0,5/3), $ forall phii in Adm^0\ V_N (phii) = 0 $)
        eqq(10, [@viable-by-self-financing])
        node((0,10/3), $ forall phii in SelfF^0\ V_N (phii) >= 0 => V_N = 0 $)
        eqq(15, "Syntactical")
        node((0,5), $V_N (SelfF^0) inter RRp^Omega\ ={0} $)
        edge("r", "=>",shift: 3pt, label: "Hahn-Banach")

        let eqq(label) = edge("d", "<->", stroke: .7pt, extrude: (-2.5,2.5), label: label, label-side: left)
        let uu = [Under some $PP^*$ equivalent to $PP$,];

        node((1,0), uu + [\ all $tS^j_bullet$ are martingales.])
        eqq([@martingale-characterization])
        node((1,1), $ exists PP^*~PP: med forall H "predictable" forall j\ EE^*[(H martra tS^j)_N]=0 $)
        eqq([@value-mean-zero-when-mart-transform-mean-zero])
        node((1,2), $ exists PP^*~PP: forall phii in SelfF^0:\ sum_j EE^*[phii^j martra tS^j]=0 $)
        eqq([@predict-mean-zero-when-selff-mean-zero])
        node((1,3), $ exists PP^*~PP: med forall phii in SelfF^0 \ EE^*[V_N (phii)]=0 $)
        eqq([@geometric-remark])
        node((1,4), $ exists PP^*~PP: med forall phii in SelfF^0\ PP^* dot V_N (phii) = 0 $)
        eqq("Syntactical")
        node((1,5), $ exists PP^*~PP:\ med PP^* perp V_N (SelfF^0) $)
        edge((1,5), "l", "=>", label: [Measure-theoretic], label-sep: 7pt, label-angle: 0deg, shift: 3pt, label-side: left)
      })
    )
  ]

=== Example for $|Omega|=2$

The Fundamental theorem of asset pricing is essentially a statement about the space $RR^Omega$, in
which portfolio terminal values lie. $RR^Omega$ is the space of all possible random choices for a random real number.

That space is $|Omega|$-dimensional, so we can visualise graphically it when the probability space
is as simple as $Omega = {omega_1, omega_2}$, i.e. there are only two possible outcomes. 

// Then each strategy's portfolio value at time 1, $V_1 (phii)$, can take at most two values.
An arbitrage strategy will have its portfolio value lie in the first quadrant of $RR^{omega_1,
omega_2}$ (that is, ${(x,y): x>=0, y>=0}$), so that in no case of the two outcomes it induces a loss.

Equivalently, a no-arbitrage self-financing strategy of zero-investment will have its final
portfolio value _outside_ of that quadrant, so for a viable market all terminal values of $SelfF^0$
form a line through the origin that does not enter the first quadrant. Then that line induces a
unit normal lying in that quadrant so gives positive probabilities to both outcomes (i.e. is
an equivalent probability measure).
