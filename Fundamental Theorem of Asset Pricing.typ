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
#let martra = $dot.circle$
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
  With a finite time horizon $N$, $#Strat = RR^(N times Omega)$, and with an infinite horizon $#Strat = RR^(NN times Omega)$.

  Self-financing strategies are filtered from it by the linear condition $phii_(n+1) S_n = phii_n S_n$, so they form a subspace $SelfF subset Strat$.
]

Real random variables on $Omega$ form a vector space too, denote it by $RR^Omega$.

For each $n$ and each strategy $phii$, $V_n (phii)$ is a random variable, so a vector $V_n (phii) in
RR^Omega$. Now we can consider how the dependence on $phii$ looks like:

#remark[
  For any $n$, the operator $V_n (phii) = phii_n dot S_n$ is linear in $phii$. Its signature is
  $ V_n : Strat -> RR^Omega $

  Then the images of $Strat$and $SelfF$ are linear subspaces of $RR^Omega$:
  $ V_n (SelfF) subset V_n (Strat) subset RR^Omega. $
  #text(size:8pt)[(the last inclusion might actually be an equality, TODO check)]
]

We will talk about strategies of zero initial capital, so it is useful to have
#notation[
  For the above defined sets of strategies, denote the subset of those strategies that satisfy $V_0
  (phii)=0$ by a subscript 0: $SelfF_0, Strat_0$.\
  Clearly they form subspaces of the respective spaces.
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

  Like above, denote the set of zero initial capital admissible strategies by $Adm_0$.
]

Thus we get the following chain of strategy classes (here $N$ is either a finite number or equals $NN$, and $<=$ means $subset$ but for subspaces):

#align(
  center,
  diagram(spacing: (.5em, 0pt),
  {
    let dedge(to, sym: $<=$) = edge(to, stroke: none, label: sym, label-angle: auto, label-side: center)

    node((0,1), $RR^(N times Omega)_(>=0)$)
    dedge("ur", sym: $supset$) 
    dedge("dr", sym: $supset$) 

    node((1, 0), Adm)
    dedge("r")
    node((2, 0), SelfF)
    dedge("r")
    node((3, 0), Strat)
    dedge("dr")

    node((4,1), $RR^(N times Omega) ,$)

    node((1, 2), $Adm_0$)
    dedge("r")
    dedge("uu", sym: $subset$)
    node((2, 2), $SelfF_0$)
    dedge("r")
    dedge("uu")
    node((3, 2), $Strat_0$)
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

    node((1, 2), $V_n (Adm_0)$)
    dedge("r")
    dedge("uu", sym: $subset$)
    node((2, 2), $V_n (SelfF_0)$)
    dedge("r")
    dedge("uu")
    node((3, 2), $V_n (Strat_0)$)
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

  In terms of the notation above, a market is viable if $V_N (Adm_0) = 0$.

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
  [no strategy $phii in SelfF_0$ can provide $V_N (phii) in RR_(>=0)^Omega \\ { 0 }$.]
  )
]<viable-by-self-financing>

#proof[
  The $(arrow.l.double)$ direction is trivial, just because $Adm_0 subset SelfF_0$.

  For $(arrow.r.double)$, assume that no $phii in Adm_0$ gives $V_N (phii) in RR_(>=0)^Omega \\ {0}$
  and take a $phii in SelfF_0$ to show $V_N (phii) in.not RR_(>=0)^Omega \\ {0}$.

  If $phii in Adm_0$, we're done; now assume $phii$ is not admissible, i.e. gives a negative portfolio
  value $V_n (phii) < 0$ with positive probability at some time $n$.

  If $n = N$, we're done; now take $n$ to be the last such one. Then the strategy $phii$ with
  positive probability has negative value at $n<N$ and at all later times gives $V_bullet (phii) in
  RR_(>=0)^Omega$.
  
  TODO 
  // That is, $V_n (phii) = phii_n dot S_n < 0$ with positive probability but $V_(n+1) (phii) = phii_(n+1) dot S_(n+1) >= 0$ almost surely.
]

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
    For any $phii in SelfF_0$,

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

#prop[
  #set par(justify: false)
  #iff(
    [
      #import "@preview/mannot:0.3.0": mark, annot
      For all predictable $mark(H, tag: #<H>) #annot(<H>, [(real-valued)], pos: top)$ and each asset $j$,

    $ EE[(H martra tS^j)_N]=0 $],
    [for all $phii in SelfF_0$, $ EE[tV_N (phii)]=0 $]
  )
]<value-mean-zero-when-mart-transform-mean-zero>
(notice the similarity between the first lines on each side as well as between the second lines)

#proof($(arrow.r.double)$)[
  Assume the left side and take a $phii in SelfF_0$.
  As discussed in @value-is-mart-transform, for a self-financing strategy, the discounted portfolio
  value is a martingale transform of the market prices,
  $ tV_N (phii)=sum_(j=0)^d (phii^j martra tS^j)_N, $
  and each $(phii^j martra tS^j)_N$ was assumed to have zero mean (all $phii^j$ are surely
  predictable), so the total gain expectation vanishes:
  $ EE^*[tV_N] 
  = EE^*[sum_j (phii^j martra tS^j)_N] 
  = sum_j underbrace(EE^*[(phii^j martra tS^j)_N],0) = 0. $
]

Before showing the other direction, a short comment:
#remark[
  Notice that $tS^0$ is constant, so trivially $H martra tS^0 = 0$ and the condition on the left
  side here matters only for $j>0$. This is why in the proof in the book, instead of self-financing
  strategies, they consider predictable processes in $RR^d$ (and not $RR^(d+1)$). But I find this
  unnecessarily confusing, as we can reuse terms already established ($Adm_0$) and just point out that
  the $j$ on the right hand side can vary from 1 onwards.
]

#proof($(arrow.l.double)$)[
  Take a predictable $H$ and an asset $j$,
  we have to prove that $EE^*[(H martra tS^j)_N]=0$.

  If $j=0$, we are done by the preceding remark, so now $H$ can be regarded as a strategy operating
  only on a risky asset $j>0$.\
  By @risky-restriction-induces-selffin we can extend $H$ to a (unique) self-financing strategy
  $phii$ with $V_0 (phii) = 0$.

  But for $phii in SelfF_0$, the portfolio value is a martingale transform of the prices, so 
  $ tV_N (phii) = sum_i (phii^i martra tS^i)_N $
  All sum terms except $i=j$ vanish because for $i=0$, $tS^i$ is constant; while for $i>0$ and
  $i!=j$, $phii^j$ is zero. And $phii^j$ is just $H$, so $tV_N (phii) = (H martra S^j)_N$, but by
  the right side that was assumed to have zero mean.
]

Now we can rephrase the right side of the fundamental theorem of asset pricing again:
#prop("Fundamental theorem of asset pricing, again")[
  #iff(
    yinset: .5em,
    [
      #set par(justify: false)
      For any $phii in SelfF_0$,

      if $V_N (phii) >=0$, then $V_N (phii)= 0$.
    ],
    [
      #set par(justify: false)
      there exists $PP^*$ equivalent to $PP$, s.t. for any $phii in SelfF_0$,
      $ EE^*[tV_N (phii)]=0. $
    ]
  )
]

This phrasing renders one direction of the proof nearly trivial:

#proof($(arrow.l.double)$)[
  We assume a $PP^*$ equivalent to $PP$, take an $phi.alt in SelfF_0$ and now we have to show it gives
  no profit at the end, i.e. that $V_N>=0$ implies $V_N =0$.

  But under $PP^*$, we've assumed $EE^*[tV_N (phii)]=0$, and the lack of risk at the end criteria $V_N (phii)>=0$,
  or#footnote[$V_N$ and $tV_N$ are related by a positive constant.] $tV_N (phii)>=0$, now implies
  $tV_N =^(PP^*) 0$, and so#footnote[the equivalence $PP ~ PP^*$ means that "$PP$-almost surely" is
  equivalent to "$PP^*$-almost surely"] $tV_N=^(PP)0$. Then $V_N =^(PP) 0$ as well. 
]

#let RRp = $RR_(>=0)$

#proof($(arrow.r.double)$)[
  We are looking for a $PP^*$ equivalent to $PP$. Assuming that $calF=cal(P)(Omega)$ and
  $PP(omega)>0$ for all outcomes $omega in Omega$, equivalence with $PP$ means $forall omega: PP^*(omega) > 0$ as well.

  So the equivalent measures lie in $RRp^Omega$ and we're looking for a positive map $ PP^*: Omega
  -> RR_+,$ an element $PP^* in RR^Omega_(>=0).$

  But remember that the terminal portfolio values $tV_N (phii)$ induced by the self-financing strategies from the
  theorem's assumption#footnote[The assumption is about admissible strategies, but we showed that
  this is equivalent to self-financing strategies.] live in the same ambient space $RR^Omega$ as $PP^*$:
  $ tV_N (SelfF_0) subset RR^Omega supset RRp^Omega in.rev PP^*, $
  and by that, they form a subspace that, apart from 0, is disjoint#footnote[This is the assumption in the left side of the proposition] from the cone $RR_(>=0)^Omega$
   in which the $PP^*$ we're looking for lies in.

  Considering the wanted $PP^*$ as a vector, for any $phii$ the mean $EE^* [tV_N (phii)]$ is just the
  dot product $PP^* dot tV_N (phii)$. Then the required condition $EE^* [tV_N (phii)] = 0$ for all $phii in
  SelfF_0$ means just that $PP^*$ must be orthogonal to $tV_N (SelfF_0)$. // $PP^* perp SelfF_0$.

  Now by standard separation theorem there exists a linear functional on $RR^Omega$ vanishing on
  $tV_N (SelfF_0)$ and positive on $RRp^Omega$, or --- a unit (by $||dot||_1$) vector 
  $PP^* in RRp^Omega$ orthogonal to $tV_N (SelfF_0)$. That it, there exists an equivalent to $PP$
  probability measure under which $tV_N (phii)$ has zero mean for all $phii in SelfF_0$.
]

=== Summary
We summarize the proof and the preceding rewrites of the Fundamental theorem of asset pricing (FTAP) in the
following diagram:

#align(
  center,
  diagram(
    spacing: (2cm, 2em),
    {
      let eqqGeneric(label, label-side) = edge("d", "<->", stroke: .7pt, extrude: (-2.5,2.5), label: label, label-side: label-side)
      let eqq(label) = eqqGeneric(label, right)

      node((0,0), [The market is\ arbitrage-free])
      eqq("By definition")
      edge("r", extrude: (-2.5,2.5), "<->", label: "FTAP", stroke: 1pt)
      node((0,4/3), $ forall phii in Adm_0\ V_N (phii) = 0 $)
      eqq([@viable-by-self-financing])
      node((0,8/3), $ forall phii in SelfF_0\ V_N (phii) >= 0 => V_N = 0 $)
      eqq("Syntactical")
      node((0,4), $V_N (SelfF_0) inter RRp^Omega\ ={0} $)
      edge("r", "=>", label: "Hahn-Banach")

      let eqq(label) = eqqGeneric(label, left)
      let uu = [Under some $PP^*$ equivalent to $PP$,];

      node((1,0), uu + [\ all $S^j_bullet$ are martingales.])
      eqq([@martingale-characterization])
      node((1,1), $ exists PP^*~PP: med forall H "predictable" forall j\ EE^*[(H martra tS^j)_N]=0 $)
      eqq([@value-mean-zero-when-mart-transform-mean-zero])
      node((1,2), $ exists PP^*~PP: med forall phii in SelfF_0 \ EE^*[V_N (phii)]=0 $)
      eqq("Syntactical")
      edge((1,2), (0,8/3), "=>", label: [Measure-theoretic], label-sep: 7pt, label-angle: 0deg, bend: -13deg)
      node((1,3), $ exists PP^*~PP: med forall phii in SelfF_0\ PP^* dot V_N (phii) = 0 $)
      eqq("Syntactical")
      node((1,4), $ exists PP^*~PP:\ med PP^* perp V_N (SelfF_0) $)
    })
)
