#import "@preview/ctheorems:1.1.3": thmbox, thmproof, thmrules
#show: thmrules

#let definition = thmbox("definition", "Definition", stroke: .5pt)

A Poisson process $N_t, t>=0$ is defined by its instantaneous jump probability _now_ and
is dragged forward by independence:

#let Nth = $N_(t+h)$
#let DNth = $Delta N_(t,h)$
#let DNOh = $Delta N_(0,h)$

#definition[
  $N$ is a Poisson process with parameter $lambda>0$ if both of these conditions are satisfied:
  + (Generator) the time evolution of the probabilities $p_k (t) := PP(N_t = k)$ satisfies $ p'_k (0) = cases(lambda & "if" k=1, -lambda & "if" k=0, 0 & "if" k>1) $
  + (Drag forward) $N$ has independent , i.e. each increment $Delta N_(t,h) := N_(t+h)-N_t$ is independent from $N_t$ (denoted $ Delta N_(t,h) perp N_t$), i.e. satisfies $ PP(Delta N_(t,h) = k "and" N_t = n) = PP(Delta N_(t,h) = k)PP(N_t=n)  $ for all $n,k$.
  + $N$ has stationary increments, i.e. all increments $Delta N_(dot, h)$ have the same laws, i.e. $ DNth ~ DNOh "for all" t>=0. $
]

To drag the probabilities forward, we choose a later time $t>=0$ and apply the conditions above to 
$ PP(Nth = k) &= sum_n PP(Nth = k | N_t = n)          && "(by total probability)"\
              &= sum_n PP(DNth = k-n | N_t = n)       && "(by "Nth=N_t + DNth")"\
              &= sum_n PP(DNth = k-n) dot PP(N_t = n) wide && "(by "DNth perp N_t")"\
              &= sum_n PP(DNOh = k-n) dot PP(N_t = n) wide && "(by "DNth ~ DNOh")"\
              &= sum_n PP(N_h = k-n) dot PP(N_t = n) wide && "(by "N_t = N_0 + DNOh")"\
$
In terms of the functions $p_k (t)$, this means $ p_k (t+h) = sum_n p_n (h) p_(k-n) (t) $ for all
$k,t,h$. Differentiate w.r.t. $h$:
$ p'_k (t+h) = sum_n p'_n (h) p_(k-n) (t) $ 
and evaluate at $h=0$:
$ p'_k (t) = sum_n p'_n (0) p_(k-n) (t) $ 
But $p'_n (0)$ was postulated to vanish for $n>1$, so the sum is just
$ p'_k (t) &= p'_0 (0) p_k (t) + p'_1 (0) p_(k-1) (t) \
           &= lambda (-p_k (t) + p_(k-1) (t)),
$
or, in point-free style, $ p'_k = lambda ( p_(k-1) - p_k ). $

= Computing $p_k$

Collect all $p_k$ in the generating function $ G_t (x) = sum_k p_k (t) x^k $
and differentiate
$ partial_t G_t (x) &= sum_k p'_k (t) x^k \
              &= p'_0 (t) + sum_(k>=1) p'_k (t) x^k \
              &= p'_0 (t) + lambda sum_(k>=1) p_(k-1) (t) x^k - lambda sum_(k>=1) p_k (t) x^k \
              &= p'_0 (t) + lambda x G_t (x) - lambda (G_t (x) - p_0 (t)) \
              &= lambda (x-1) G_t (x),
$
so $ dif/(dif t) G_t (x) = lambda (x-1) G_t (x). $
The solution is $ G_t (x) = exp(lambda (x-1) t). $

To get the coefficients of $G_t (x)$, expand 
$ exp(lambda (x-1) t) = e^(-lambda t) exp(lambda t x) &= e^(-lambda t) sum_k (lambda x t)^k / k! \
                                                      &= sum_k e^(-lambda t) (lambda t)^k /k! x^k
$

Equating with $G_t (x) = sum_k p_k (t) x^k$ we get $ p_k (t) = e^(-lambda t) (lambda t)^k /k! $
