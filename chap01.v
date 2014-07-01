(** 
%\section*{Introduction}%


The following are solutions to (eventually all of) the exercises from
_Homotopy Type Theory: Univalent Foundations of Mathematics_.  The Coq
code given alongside the by-hand solutions requires the HoTT version of Coq,
available %\href{https://github.com/HoTT}{at the HoTT github repository}%.  It
will be assumed throughout that it has been imported by *)


Require Import HoTT.

(** 
The
%\href{https://github.com/HoTT/book/blob/master/coq_introduction/Reading_HoTT_in_Coq.v}{introduction to Coq from the HoTT repo}% 
is assumed.  Each exercise has its own Section in
the Coq file, so Context declarations don't extend beyond the exercise---and sometimes they're even more restricted than that.


* Type Theory

%\exer{1.1}{56}%  
Given functions $f:A\to B$ and $g:B\to C$, define their \term{composite} $g
\circ f : A \to C$.  Show that we have $h \circ (g \circ f) \equiv (h \circ g)
\circ f$.


%\soln%
Define $g \circ f \defeq \lam{x:A}g(f(x))$.  Then if $h:C \to D$, we
have
%\[
  h \circ (g \circ f) 
  \equiv \lam{x:A}h((g \circ f)x)
  \equiv \lam{x:A}h((\lam{y:A}g(fy))x)
  \equiv \lam{x:A}h(g(fx))
\]%
and
%\[
  (h \circ g) \circ f 
  \equiv \lam{x:A}(h \circ g)(fx)
  \equiv \lam{x:A}(\lam{y:A}h(gy))(fx)
  \equiv \lam{x:A}h(g(fx))
\]%
So $h \circ (g \circ f) \equiv (h \circ g) \circ f$.  In Coq, we have *)


Definition compose {A B C:Type} (g : B -> C) (f : A -> B) := fun x => g (f x).


Theorem compose_assoc : forall (A B C D : Type) (f : A -> B) (g : B-> C) (h : C -> D),

compose h (compose g f) = compose (compose h g) f.

Proof.

trivial.

Qed.

(** 
%\exer{1.2}{56}%  
Derive the recursion principle for products $\rec{A \times B}$ using only the
projections, and verify that the definitional equalities are valid.  Do the
same for $\Sigma$-types.  *)


Section Exercise2a.

Context {A B : Type}.

(** 
%\soln% 
The recursion principle states that we can define a function $f : A
\times B \to C$ by giving its value on pairs.  Suppose that we have projection
functions $\fst : A \times B \to A$ and $\snd : A \times B \to B$.  Then we can
define a function of type
%\[
\rec{A\times B} : \prd{C : \UU} (A \to B \to C) \to A \times B \to C
\]%
in terms of these projections as follows
%\[
\rec{A \times B}'(C, g, p) \defeq 
g(\fst p)(\snd p)
\]%
or, in Coq,
*)


Definition recprod (C : Type) (g : A -> B -> C) (p : A * B) := g (fst p) (snd p).

(** We must then show that
%\begin{align*}
  \rec{A\times B}'(C, g, (a, b)) 
  \equiv g(\fst (a, b))(\snd (a, b))
  \equiv g(a)(b)
\end{align*}%
which in Coq is also trivial: *)


Goal forall C g a b, recprod C g (a, b) = g a b. trivial. Qed.

End Exercise2a.

Section Exercise2b.

Context {A : Type}.
Context {B : A -> Type}.

(** 
Now for the $\Sigma$-types.  Here we have a projection
%\[
\fst : \left(\sm{x : A} B(x) \right) \to A
\]%
and another
%\[
\snd : \prd{p : \sm{x : A} B(x)} B(\fst (p))
\]%
Define a function of type 
%\[
\rec{\sm{x:A}B(x)} : \prd{C:\UU} \left(\tprd{x:A} B(x) \to C \right) \to
\left(\tsm{x:A}B(x) \right) \to C
\]%
by
%\[
\rec{\sm{x:A}B(x)}(C, g, p)
\defeq
g(\fst p)(\snd p)
\]% 
*)

Definition recsm (C : Type) (g : forall (x : A), B x -> C) (p : exists (x : A), B x) := g (projT1 p) (projT2 p).

(** 
We then verify that
%\begin{align*}
\rec{\sm{x:A}B(x)}(C, g, (a, b))
\equiv g(\fst (a, b))(\snd (a, b))
\equiv g(a)(b)
\end{align*}%
which is again trivial in Coq: *)


Goal forall C g a b, recsm C g (a; b) = g a b. trivial. Qed.

End Exercise2b.

(** 
%\exer{1.3}{56}% 
Derive the induction principle for products $\ind{A \times B}$ using only the
projections and the propositional uniqueness principle $\uppt$.  Verify that
the definitional equalities are valid.  Generalize $\uppt$ to $\Sigma$-types,
and do the same for $\Sigma$-types. *)
(* begin hide *)
Section Exercise3a.
Context {A B : Type}.
(* end hide *)

(** %\soln% 
The induction principle has type
%\[
\ind{A\times B} : \prd{C: A\times B \to \UU}\left(\prd{x:A}\prd{y:B}C((x,
y))\right) \to \prd{z:A\times B}C(z)
\]%
For a first pass, we can define
%\[
\ind{A\times B}(C, g, z)
\defeq
g(\fst z)(\snd z)
\]%
However, we have $g(\fst x)(\fst x) : C((\fst x, \snd x))$, so the type of this
$\ind{A \times B}$ is
%\[
\ind{A\times B} : \prd{C: A\times B \to \UU}\left(\prd{x:A}\prd{y:B}C((x,
y))\right) \to \prd{z:A\times B}C((\fst z, \snd z))
\]%
To define $\ind{A \times B}$ with the correct type, we need the
$\mathsf{transport}$ operation from the next chapter.  The uniqueness principle
for $A \times B$ is
%\[
\uppt : \prd{x : A \times B} \big((\fst x, \snd x) =_{A \times B} x\big)
\]%
By the transport principle, there is a function
%\[
(\uppt\, x)_{*} : C((\fst x, \snd x)) \to C(x)
\]%
so
%\[
\ind{A \times B}(C, g, z)
\defeq
(\uppt\, z)_{*}(g(\fst z)(\snd z))
\]%
has the right type.
In Coq we first define $\uppt$, then use it with transport to give our
$\ind{A\times B}$.  *)


Definition uppt (x : A * B) : (fst x, snd x) = x. destruct x; reflexivity. Defined.


Definition indprd (C : A * B -> Type) (g : forall (x:A) (y:B), C (x, y)) (z : A * B) :=

(uppt z) # (g (fst z) (snd z)).

(** 
We now have to show that
%\[
\ind{A \times B}(C, g, (a, b)) 
\equiv g(a)(b)
\]%
Unfolding the left gives
%\begin{align*}
\ind{A \times B}(C, g, (a, b)) 
&\equiv
(\uppt\, (a, b))_{*}(g(\fst (a, b))(\snd (a, b)))
\\&\equiv
\ind{=_{A \times B}}(D, d, (a, b), (a, b), \uppt((a, b)))(g(a)(b))
\\&\equiv
\ind{=_{A \times B}}(D, d, (a, b), (a, b), \refl{(a, b)})
(g(a)(b))
\\&\equiv
\ind{=_{A \times B}}(D, d, (a, b), (a, b), \refl{(a, b)})
(g(a)(b))
\\&\equiv
\mathsf{id}_{C((a, b))}(g(a)(b))
\\&\equiv
g(a)(b)
\end{align*}%
which was to be proved.  In Coq, it's as trivial as always: *)


Goal forall C g a b, indprd C g (a, b) = g a b. trivial. Qed.

End Exercise3a.
Section Exercise3b.
Context {A : Type}.
Context {B : A -> Type}.

(** 
For $\Sigma$-types, we define
%\[
\ind{\tsm{x:A}B(x)} : \prd{C:(\tsm{x:A}B(x)) \to \UU}
\left(\tprd{a:A}\tprd{b:B(a)}C((a, b))\right) \to \prd{p: \tsm{x:A}B(x)}C(p)
\]%
at first pass by
%\[
\ind{\tsm{x:A}B(x)}(C, g, p)
\defeq
g(\fst p)(\snd p)
\]%
We encounter a similar problem as before.  We need a uniqueness principle for
$\Sigma$-types, which would be a function
%\[
\upst : \prd{p : \sm{x:A}B(x)} \big(
(\fst p, \snd p) =_{\sm{x:A}B(x)} p
\big)
\]%
As for product types, we can define
%\[
\upst((a, b)) \defeq \refl{(a, b)}
\]%
which is well-typed, since $\fst(a, b) \equiv a$ and $\snd(a, b) \equiv b$.
Thus, we can write
%\[
\ind{\sm{x:A}B(x)}(C, g, p) \defeq (\upst\, p)_{*}(g(\fst p)(\snd p)).
\]%
and in Coq, *)


Definition upst (p : {x:A & B x}) : (projT1 p; projT2 p) = p. destruct p; reflexivity. Defined.


Definition indsm (C : {x:A & B x} -> Type) (g : forall (a:A) (b:B a), C (a; b)) (p : {x:A & B x}) :=
    (upst p) # (g (projT1 p) (projT2 p)).

(** 
Now we must verify that
%\[
\ind{\sm{x:A}B(x)}(C, g, (a, b)) \equiv g(a)(b)
\]%
We have
%\begin{align*}
\ind{\sm{x:A}B(x)}(C, g, (a, b))
&\equiv
(\uppt\, (a, b))_{*}(g(\fst(a, b))(\snd(a, b)))
\\&\equiv
\ind{=_{\sm{x:A}B(x)}}(D, d, (a, b), (a, b), \uppt\, (a, b))
(g(a)(b))
\\&\equiv
\ind{=_{\sm{x:A}B(x)}}(D, d, (a, b), (a, b), \refl{(a, b)})
(g(a)(b))
\\&\equiv
\mathsf{id}_{C((a, b))}
(g(a)(b))
\\&\equiv
g(a)(b)
\end{align*}% 
which Coq finds trivial: *)


Goal forall C g a b, indsm C g (a; b) = g a b. trivial. Qed.

(* begin hide *)
End Exercise3b.
(* end hide *)

(** 
%\exer{1.4}{56}%  
Assuming as given only the _iterator_ for natural numbers
%\[
\ite : 
\prd{C:\UU} C \to (C \to C) \to \mathbb{N} \to C
\]%
with the defining equations
%\begin{align*}
\ite(C, c_{0}, c_{s}, 0) &\defeq c_{0}, \\
\ite(C, c_{0}, c_{s}, \suc(n)) &\defeq c_{s}(\ite(C, c_{0}, c_{s}, n)),
\end{align*}%
derive a function having the type of the recursor $\rec{\mathbb{N}}$.  Show
that the defining equations of the recursor hold propositionally for this
function, using the induction principle for $\mathbb{N}$.


%\soln%  
Fix some $C : \UU$, $c_{0} : C$, and $c_{s} : \mathbb{N} \to C \to C$.
$\ite(C)$ allows for the $n$-fold application of a single function to a single
input from $C$, whereas $\rec{\mathbb{N}}$ allows each application to depend on
$n$, as well.  Since $n$ just tracks how many applications we've done, we can
construct $n$ on the fly, iterating over elements of $\mathbb{N} \times C$.  So
we will use the iterator
%\[
\ite_{\mathbb{N} \times C} : \mathbb{N} \times C \to (\mathbb{N} \times C
\to \mathbb{N} \times C) \to \mathbb{N} \to \mathbb{N} \times C
\]%
to derive a function
%\[
\Phi : \prd{C : \UU} C \to (\mathbb{N} \to C \to C) \to
\mathbb{N} \to C
\]%
which has the same type as $\rec{\mathbb{N}}$.  


The first argument of $\ite_{\mathbb{N} \times C}$ is the starting point,
which we'll make $(0, c_{0})$.  The second input takes an element of
$\mathbb{N} \times C$ as an argument and uses $c_{s}$ to construct a new
element of $\mathbb{N} \times C$.  We can use the first and second elements of
the pair as arguments for $c_{s}$, and we'll use $\suc$ to advance the second
argument, representing the number of steps taken.  This gives the function
%\[
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)) 
: \mathbb{N} \times C \to \mathbb{N} \times C
\]%
for the second input to $\ite_{\mathbb{N} \times C}$.  The third input is just
$n$, which we can pass through.  Plugging these in gives
%\[
\ite_{\mathbb{N} \times C}\big(
(0, c_{0}),
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)),
n
\big)
: \mathbb{N} \times C
\]%
from which we need to extract an element of $C$.  This is easily done with the
projection operator, so we have
%\[
\Phi_{C}(c_{0}, c_{s}, n) \defeq
\snd\bigg(
\ite_{\mathbb{N} \times C}\big(
(0, c_{0}),
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)),
n
\big)
\bigg)
\]%
which has the same type as $\rec{\mathbb{N}}$.  In Coq we first define the
iterator and then our alternative recursor: *)



Fixpoint iter (C : Type) (c0 : C) (cs : C -> C) (n : nat) : C :=
    match n with 
        | 0 => c0
        | S n' => cs(iter C c0 cs n')
    end.


Definition Phi (C : Type) (c0 : C) (cs: nat -> C -> C) (n : nat) :=
    snd (iter (nat * C)
                (0, c0)
                (fun x => (S (fst x), cs (fst x) (snd x)))
                n).

(** 
Now to show that the defining equations hold propositionally for $\Phi$.
To do this, we must show that
%\begin{align*}
\Phi(C, c_{0}, c_{s}, 0) &=_{C} c_{0} \\
\prd{n:\mathbb{N}}\bigg(\Phi_{C}(c_{0}, c_{s}, \suc(n)) &=_{C} c_{s}(n,
\Phi(C, c_{0}, c_{s}, n)) \bigg)
\end{align*}%
are inhabited.  Since $C$, $c_{0}$, and $c_{s}$ are fixed, define
for brevity. The first equality is straightforward:
%\[
\Phi(C, c_{0}, c_{s}, 0)
\equiv
\snd\bigg(
\ite_{\mathbb{N} \times C}\big(
(0, c_{0}),
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)),
0
\big)
\bigg)
\equiv
\snd(0, c_{0})
\equiv
c_{0}
\]%
and in Coq, *)

Goal forall C c0 cs, Phi C c0 cs 0 = c0. trivial. Qed.

(** 
%\noindent%
So $\refl{c_{0}} : \Phi(C, c_{0}, c_{s}, 0) =_{C} c_{0}$.  This establishes
the first equality.  We prove the second by strengthening the induction
hypothesis.  Define $\Phi'$ as the argument of $\snd$ in the above
definition; i.e., such that $\Phi = \snd \Phi'$. *)


Definition Phi' (C : Type) (c0 : C) (cs : nat -> C -> C) (n : nat) := 
    iter (nat * C) (0, c0) (fun x => (S (fst x), cs (fst x) (snd x))) n.

(** 
%\noindent%
We then show that for all $n : \mathbb{N}$,
%\[
P(n) \defeq
\left(\Phi'(C, c_{0}, c_{s}, \suc(n)) 
=_{C}
(\suc(n), c_{s}(n, \snd \Phi'(C, c_{0}, c_{s}, n))
\right).
\]%
For the base case, consider $\Phi'(C, c_{0}, c_{s}, 0)$; we have
 %\begin{align*}
\Phi'(C, c_{0}, c_{s}, \suc(0))
&\equiv 
\ite_{\mathbb{N} \times C}\big(
(0, c_{0}),
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)),
\suc(0)
\big)
\\&\equiv 
(\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)))
\Phi'(C, c_{0}, c_{s}, 0)
\\&\equiv 
(\suc(\fst (0, c_{0})), c_{s}(\fst (0, c_{0}), \snd \Phi'(C, c_{0}, c_{s}, 0))))
\\&\equiv 
\left(\suc(0), c_{s}(0, \snd \Phi'(C, c_{0}, c_{s}, 0))\right)
\end{align*}% 
For the induction step, suppose that $n : \mathbb{N}$ and that $P(n)$ is
inhabited.  Then
%\begin{align*}
\Phi'(C, c_{0}, c_{s}, \suc(\suc(n)))
&\equiv
\ite_{\mathbb{N} \times C}\big(
(0, c_{0}),
\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x)),
\suc(\suc(n)))
\big)
\\&\equiv
\left(\lam{x}(\suc(\fst x), c_{s}(\fst x, \snd x))\right)
\Phi'(C, c_{0}, c_{s}, \suc(n))
\\&\equiv
\big(\suc(\fst \Phi'(C, c_{0}, c_{s}, \suc(n))), 
\\&\phantom{-----}
c_{s}(\fst \Phi'(C, c_{0}, c_{s}, \suc(n)), \snd \Phi'(C, c_{0},
c_{s}, \suc(n)))\big)
\\&=_{C}
\big(\suc(\fst (\suc(n), c_{s}(n, \snd \Phi'(C, c_{0}, c_{s}, n)))), 
\\&\phantom{-----}
c_{s}(\fst (\suc(n), c_{s}(n, \Phi'(C, c_{0}, c_{s}, n))), \snd \Phi'(C, c_{0},
c_{s}, \suc(n)))\big)
\\&=_{C}
\big(\suc(\suc(n)), 
c_{s}(\suc(n), \snd \Phi'(C, c_{0}, c_{s}, \suc(n)))\big)
\end{align*}% 
Where the step introducing the propositional equality is an application of the
indiscernability of identicals as applied to the induction hypothesis.  We have
thus shown that $P(n)$ holds for all $n$.\footnote{Rather more sketchily than
before I lost the first file---redo this?}  Applying $\snd$ to either side
gives
%\[
  \Phi(C, c_{0}, c_{s}, \suc(n))
  \equiv
  \snd\Phi(C, c_{0}, c_{s}, \suc(n))
  =_{C}
  \snd(n, c_{s}(n, \Phi(C, c_{0}, c_{s}, n)))
  \equiv
  \snd(n, c_{s}(n, \Phi(C, c_{0}, c_{s}, n)))
\]%
for all $n$, meaning that the defining equations hold propositionally.  I need
to learn more Coq to do this proof in that.
*)


(** 
%\exer{1.5}{56}%  
Show that if we define $A + B \defeq \sm{x:\bool}
\rec{\bool}(\UU, A, B, x)$, then we can give a definition of $\ind{A+B}$ for
which the definitional equalities stated in \symbol{92}S1.7 hold.


%\soln%  
Define $A+B$ as stated.  We need to define a function of type
%\[
  \ind{A+B}' : \prd{C : (A + B) \to \UU}
               \left( \tprd{a:A} C(\inl(a))\right)
               \to
               \left( \tprd{b:B} C(\inr(b))\right)
               \to
               \tprd{x : A + B} C(x)
\]%
which means that we also need to define $\inl' : A \to A + B$ and $\inr' B \to
A + B$; these are
%\begin{align*}
  \inl'(a) \defeq (0_{\bool}, a)
  \qquad\qquad
  \inr'(b) \defeq (1_{\bool}, b)
\end{align*}%
In Coq, we can use sigT to define coprd as a
$\Sigma$-type: *)


Section Exercise5.


Context {A B : Type}.


Definition coprd := {x:Bool & if x then B else A}.

Definition myinl (a : A) := existT (fun x:Bool => if x then B else A) false a.

Definition myinr (b : B) := existT (fun x:Bool => if x then B else A) true b.

(** 
Suppose that $C : A + B \to \UU$, $g_{0} : \prd{a:A} C(\inl'(a))$, $g_{1} :
\prd{b:B} C(\inr'(b))$, and $x : A+B$; we're looking to define
%\[
  \ind{A+B}'(C, g_{0}, g_{1}, x)
\]%
We will use $\ind{\sm{x:\bool}\rec{\bool}(\UU, A, B, x)}$, and for notational
convenience will write $\Phi \defeq \sm{x:\bool}\rec{\bool}(\UU, A, B, x)$.
$\ind{\Phi}$ has signature
%\[
  \ind{\Phi} :
  \prd{C : (\Phi) \to \UU}
  \left(\tprd{x:\bool}\tprd{y:\rec{\bool}(\UU, A, B, x)}C((x, y))\right)
  \to
  \tprd{p:\Phi} C(p)
\]%
So
%\[
  \ind{\Phi}(C) : 
  \left(\tprd{x:\bool}\tprd{y:\rec{\bool}(\UU, A, B, x)}C((x, y))\right)
  \to
  \tprd{p:\Phi} C(p)
\]%
To obtain something of type $\tprd{x:\bool}\tprd{y:\rec{\bool}(\UU, A, B,
  x)}C((x, y))$ we'll have to use $\ind{\bool}$.  In particular, for $B(x)
\defeq\prd{y:\rec{\bool}(\UU, A, B, x)}C((x, y))$ we have
%\[
  \ind{\bool}(B)
  :
  B(0_{\bool})
  \to
  B(1_{\bool})
  \to
  \prd{x:\bool}
  B(x)
\]%
along with
%\[
  g_{0} :
  \prd{a:A} C(\inl'(a))
  \equiv
  \prd{a:\rec{\bool}(\UU, A, B, 0_{\bool})} C((0_{\bool}, a))
  \equiv
  B(0_{\bool})
\]%
and similarly for $g_{1}$.  So
%\[
  \ind{\bool}(B, g_{0}, g_{1}) : \prd{x:\bool}\prd{y:\rec{\bool}(\UU, A, B, x)}
  C((x, y))
\]%
which is just what we needed for $\ind{\Phi}$.  So we define
%\[
  \ind{A+B}'(C, g_{0}, g_{1}, x)
  \defeq
  \ind{\sm{x:\bool}\rec{\bool}(\UU, A, B, x)}\left(
    C,
    \ind{\bool}\left(
      \prd{y:\rec{\bool}(\UU, A, B, x)} C((x, y)),
      g_{0},
      g_{1}
    \right),
    x
  \right)
\]%
and, in Coq, we use sigT_rect, which is the built-in
$\ind{\sm{x:A}B(x)}$: *)


Definition indcoprd (C : coprd -> Type) (g0 : forall a : A, C (myinl a)) (g1 : forall b : B, C (myinr b)) (x : coprd) 
:= 
sigT_rect C (Bool_rect (fun x:Bool => forall (y : if x then B else A), C (x; y)) g1 g0) x.

(** 
Now we must show that the definitional equalities
%\begin{align*}
  \ind{A+B}'(C, g_{0}, g_{1}, \inl'(a)) \equiv g_{0}(a) \\
  \ind{A+B}'(C, g_{0}, g_{1}, \inr'(b)) \equiv g_{1}(b)
\end{align*}%
hold.  For the first, we have
%\begin{align*}
  \ind{A+B}'(C, g_{0}, g_{1}, \inl'(a)) 
  &\equiv
  \ind{A+B}'(C, g_{0}, g_{1}, (0_{\bool}, a)) 
  \\&\equiv
  \ind{\sm{x:\bool}\rec{\bool}(\UU, A, B, x)}\left(
    C,
    \ind{\bool}\left(
      \prd{y:\rec{\bool}(\UU, A, B, x)} C((x, y)),
      g_{0},
      g_{1}
    \right),
    (0_{\bool}, a)
  \right)
  \\&\equiv
    \ind{\bool}\left(
      \prd{y:\rec{\bool}(\UU, A, B, x)} C((x, y)),
      g_{0},
      g_{1},
      0_{\bool}
    \right)(a)
  \\&\equiv
      g_{0}(a)
\end{align*}%
and for the second,
%\begin{align*}
  \ind{A+B}'(C, g_{0}, g_{1}, \inr'(b)) 
  &\equiv
  \ind{A+B}'(C, g_{0}, g_{1}, (1_{\bool}, b)) 
  \\&\equiv
  \ind{\sm{x:\bool}\rec{\bool}(\UU, A, B, x)}\left(
    C,
    \ind{\bool}\left(
      \prd{y:\rec{\bool}(\UU, A, B, x)} C((x, y)),
      g_{0},
      g_{1}
    \right),
    (1_{\bool}, b)
  \right)
  \\&\equiv
    \ind{\bool}\left(
      \prd{y:\rec{\bool}(\UU, A, B, x)} C((x, y)),
      g_{0},
      g_{1},
      1_{\bool}
    \right)(b)
  \\&\equiv
      g_{1}(b)
\end{align*}%
Trivial calculations, as Coq can attest: *)


Goal forall C g0 g1 a, indcoprd C g0 g1 (myinl a) = g0 a. trivial. Qed.

Goal forall C g0 g1 b, indcoprd C g0 g1 (myinr b) = g1 b. trivial. Qed.

(* begin hide *)
End Exercise5.
(* end hide *)

(** 
%\exer{1.6}{56}%
Show that if we define $A \times B \defeq \prd{x : \bool}
\rec{\bool}(\UU, A, B, x)$, then we can give a definition of $\ind{A \times
  B}$ for which the definitional equalities stated in \symbol{92}S1.5 hold
propositionally (i.e.\~{}using equality types). *)
(* begin hide *)
Section Exercise6.
Context {A B : Type}.
(* end hide *)

(** %\soln% 
Define
%\[
  A \times B \defeq \prd{x : \bool} \rec{\bool}(\UU, A, B, x)
\]%
Supposing that $a : A$ and $b : B$, we have an element $(a, b) : A \times B$
given by
%\[
  (a, b) \defeq \ind{\bool}(\rec{\bool}(\UU, A, B), a, b)
\]%
Defining this type and constructor in Coq, we have *)


Definition prd := forall x:Bool, if x then B else A.

Definition mypair (a:A) (b:B) := Bool_rect (fun x:Bool => if x then B else A) b a.

(** 
An induction principle for $A \times B$ will, given a family $C : A \times B
\to \UU$ and a function 
%\[
  g : \prd{x:A}\prd{y:B} C((x, y)),
\]% 
give a function $f : \prd{x : A \times B}C(x)$ defined by
%\[
  f((x, y)) \defeq g(x)(y)
\]%
So suppose that we have such a $C$ and $g$.  Writing things out in terms of the
definitions, we have
%\begin{align*}
  C &: \left(\prd{x:\bool}\rec{\bool}(\UU, A, B, x)\right) \to \UU \\
  g &: \prd{x:A}\prd{y:B} C(\ind{\bool}(\rec{\bool}(\UU, A, B), x, y))
\end{align*}%  
We can define projections by
%\[
  \fst p \defeq p(0_{\bool}) \qquad\qquad \snd p \defeq p(1_{\bool})
\]%
Since $p$ is an element of a dependent type, we have
%\begin{align*}
  p(0_{\bool}) &: \rec{\bool}(\UU, A, B, 0_{\bool}) \equiv A\\
  p(1_{\bool}) &: \rec{\bool}(\UU, A, B, 1_{\bool}) \equiv B
\end{align*}% *)


Definition myfst (p : prd) := p false.

Definition mysnd (p : prd) := p true.

(** 
Then we have
%\begin{align*}
  g(\fst p)(\snd p) 
  &: C(\ind{\bool}(\rec{\bool}(\UU, A, B), (\fst p), (\snd p)))
  \\&\equiv 
  C(\ind{\bool}(\rec{\bool}(\UU, A, B), (\fst p), (\snd p)))
  \\&\equiv 
  C((p(0_{\bool}), p(1_{\bool})))
\end{align*}%
So we have defined a function
%\[
  f' : \prd{p : A \times B} C((p(0_{\bool}), p(1_{\bool})))
\]%
But we need one of the type
%\[
  f : \prd{p : A \times B} C(p)
\]%
To solve this problem, we need to appeal to function extensionality from \S2.9.
This implies that there is a function
%\[
  \funext : 
  \prd{f, g : A \times B} 
    \left(\prd{x:\bool} (f(x) =_{\rec{\bool}(\UU, A, B, x)} g(x))\right)
    \to 
    (f =_{A \times B} g)
\]%
So, consider
%\[
  \funext(p, (\fst p, \snd p))) 
  :
  \left(\prd{x:\bool} (p(x) =_{\rec{\bool}(\UU, A, B, x)} (p(0_{\bool}),
    p(1_{\bool}))(x))\right)
  \to 
  (p =_{A \times B} (p(0_{\bool}), p(1_{\bool})))
\]%
We just need to show that the antecedent is inhabited, which we can do with
$\ind{\bool}$.  So consider the family
%\begin{align*}
  E &\defeq 
  \lam{x : \bool} 
  (p(x) =_{\rec{\bool}(\UU, A, B, x)} (p(0_{\bool}), p(1_{\bool}))(x)))
  \\&\phantom{:}\equiv
  \lam{x : \bool} 
  (p(x) =_{\rec{\bool}(\UU, A, B, x)} \ind{\bool}(\rec{\bool}(\UU, A, B),
  p(0_{\bool}), p(1_{\bool}), x))
\end{align*}%
We have
%\begin{align*}
  E(0_{\bool})
  &\equiv
  (p(0_{\bool}) =_{\rec{\bool}(\UU, A, B, 0_{\bool})} \ind{\bool}(\rec{\bool}(\UU, A, B),
  p(0_{\bool}), p(1_{\bool}), 0_{\bool}))
  \\&\equiv
  (p(0_{\bool}) =_{\rec{\bool}(\UU, A, B, 0_{\bool})} p(0_{\bool}))
\end{align*}%
Thus $\refl{p(0_{\bool})} : E(0_{\bool})$.  The same argument goes through to
show that $\refl{p(1_{\bool})} : E(1_{\bool})$.  This means that
%\[
  h \defeq
  \ind{\bool}(E, \refl{p(0_{\bool})}, \refl{p(1_{\bool})})
  :
  \prd{x : \bool} (p(x) =_{\rec{\bool}(\UU, A, B, x)} (p(0_{\bool}),
  p(1_{\bool})))
\]%
and thus
%\[
  \funext(p, (\fst p, \snd p), h) 
  : p =_{A \times B} (p(0_{\bool}),
  p(1_{\bool}))
\]%
This allows us to define the uniqueness principle for products:
%\[
\uppt \defeq \lam{p}\funext(p, (\fst p, \snd p), h)  
: \prd{p:A \times B} p =_{A \times B} (\fst p, \snd p)
\]%
so we can define $\ind{A\times B}$ as before:
%\[
  \ind{A\times B}(C, g, p) \defeq (\uppt\, p)_{*}(g(\fst p)(\snd p))
\]%


In Coq we can repeat this construction using [Funext]. *)



Context `{Funext}.


Definition myuppt (p : prd) : mypair (myfst p) (mysnd p) = p.
apply path_forall.
unfold pointwise_paths; apply Bool_rect; reflexivity.
Defined.


Definition indprd' (C : prd -> Type) (g : forall (x:A) (y:B), C (mypair x y)) (z : prd) := 
(myuppt z) # (g (myfst z) (mysnd z)).

(** 
Now, we must show that the definitional equality holds propositionally.  That
is, we must show that the type
%\[
  \ind{A \times B}(C, g, (a, b)) =_{C((a, b))} g(a)(b)
\]%
is inhabited.  Unfolding the left hand side gives

%\begin{align*}
  \ind{A \times B}(C, g, (a, b))
  &\equiv
  (\uppt\, (a, b))_{*}(g(\fst (a, b))(\snd (a, b)))
  \\&\equiv
  \ind{C((a, b))}(D, d, (a, b), (a, b), \uppt\, (a, b))(g(a)(b))
\end{align*}%


*)

(* begin hide *)
End Exercise6.
(* end hide *)

(** 
%\exer{1.7}{56}%             
Give an alternative derivation of $\ind{=_{A}}'$ from
$\ind{=_{A}}$ which avoids the use of universes.


%\exer{1.8}{56}%  
Define multiplication and exponentiation using
$\rec{\mathbb{N}}$.  Verify that $(\mathbb{N}, +, 0, \times, 1)$ is a semiring
using only $\ind{\mathbb{N}}$.


%\soln% 
For multiplication, we need to construct a function $\mult : \mathbb{N}
\to \mathbb{N} \to \mathbb{N}$.  Defined with pattern-matching, we would have
%\begin{align*}
  \mult(0, m) &\defeq 0 \\
  \mult(\suc(n), m) &\defeq m + \mult(n, m)
\end{align*}%
so in terms of $\rec{\mathbb{N}}$ we have
%\[
  \mult \defeq 
  \rec{\mathbb{N}}(
  \mathbb{N} \to \mathbb{N},
  \lam{n}0,
  \lam{n}{g}{m}\add(m, g(m))
  )
\]%
For exponentiation, we have the function $\expf: \mathbb{N} \to \mathbb{N} \to
\mathbb{N}$, with the intention that $\expf(e, b) = b^{e}$.  In terms of pattern
matching,
%\begin{align*}
  \expf(0, b) &\defeq 1 \\
  \expf(\suc(e), b) &\defeq \mult(b, \expf(e, b))
\end{align*}%
or, in terms of $\rec{\mathbb{N}}$,
%\[
  \expf \defeq \rec{\mathbb{N}}(
    \mathbb{N} \to \mathbb{N},
    \lam{n}1,
    \lam{n}{g}{m}\mult(m, g(m))
  )
\]%
In Coq, we can define these by *)

(* begin hide *)

Fixpoint add (n m : nat) :=
    match n with
      | O => m
      | S n' => S (add n' m)
    end.

Notation "x + y" := (add x y) : nat_scope.

(* end hide *)

Fixpoint mult (n m : nat) :=
    match n with
      | O => O
      | S n' => m + (mult n' m)
    end.


Fixpoint myexp (e b : nat) :=
    match e with
      | O => S O
      | S e' => mult b (myexp e' b)
    end.

(** 
To verify that $(\mathbb{N}, +, 0, \times, 1)$ is a semiring, we need stuff
from Chapter 2.


%\exer{1.9}{56}%  
Define the type family $\Fin : \mathbb{N} \to \UU$
mentioned at the end of \S1.3, and the dependent function $\fmax :
\prd{n : \mathbb{N}} \Fin(n + 1)$ mentioned in \S1.4.


%\soln%  
$\Fin(n)$ is a type with exactly $n$ elements.  Essentially, we want to
recreate $\mathbb{N}$ using types; so we will replace $0$ with $\emptyt$ and
$\suc$ with a coproduct.  So we define $\Fin$ recursively:
%\begin{align*}
  \Fin(0) &\defeq \emptyt \\
  \Fin(\suc(n)) &\defeq \Fin(n) + \unit
\end{align*}%
or, equivalently,
%\[
  \Fin \defeq \rec{\mathbb{N}}(\UU, \emptyt, \lam{C}C+\unit)
\]%
In Coq, *)


Fixpoint Fin (n : nat) : Type := 
    match n with
      | O => Empty 
      | S n' => Unit + (Fin n')
    end.  

(** 
%\exer{1.10}{56}%  
Show that the Ackermann function $\ack : \mathbb{N} \to
\mathbb{N} \to \mathbb{N}$,
satisfying the following equations
%\begin{align*}
  \ack(0, n) &\equiv \suc(n), \\
  \ack(\suc(m), 0) &\equiv \ack(m, 1), \\
  \ack(\suc(m), \suc(n)) &\equiv \ack(m, \ack(\suc(m), n)),
\end{align*}%
is definable using only $\rec{\mathbb{N}}$.


%\soln% 
Define
%\[
  \ack \defeq 
  \rec{\mathbb{N}}\big(
    \mathbb{N} \to \mathbb{N}, 
    \suc,
    \lam{m}{r}
      \rec{\mathbb{N}}\big(
        \mathbb{N},
        r(1),
        \lam{n}{s}r(s(r, n))
      \big)
  \big)
\]%
To show that the defining equalities hold, we'll suppress the first argument of
$\rec{\mathbb{N}}$ for clarity.  For the first we have
%\begin{align*}
  \ack(0, n)
  \equiv
  \rec{\mathbb{N}}\big(
    \suc,
    \lam{m}{r}
      \rec{\mathbb{N}}\big(
        r(1),
        \lam{n}{s}r(s(r, n))
      \big),
    0
  \big)(n)
  \equiv
  \suc(n)
\end{align*}%
For the second,
%\begin{align*}
  &\phantom{\equiv} \ack(\suc(m), 0)
  \\&\equiv
  \rec{\mathbb{N}}\big(
    \suc,
    \lam{m}{r}
      \rec{\mathbb{N}}\big(
        r(1),
        \lam{n}{s}r(s(r, n))
      \big),
    \suc(m)
  \big)(0)
  \\&\equiv
  \big(
  \big(\lam{r}
    \rec{\mathbb{N}}\big(
      r(1),
      \lam{n}{s}r(s(r, n))
    \big)\big)
  \rec{\mathbb{N}}\big(
    \suc,
    \lam{m}{r}
      \rec{\mathbb{N}}\big(
        r(1),
        \lam{n}{s}r(s(r, n))
      \big),
    m
  \big)
  \big)(0)
  \\&\equiv
  \big(
  \big(\lam{r}
    \rec{\mathbb{N}}\big(
      r(1),
      \lam{n}{s}r(s(r, n))
    \big)\big)
    \ack(m, -)
  \big)(0)
  \\&\equiv
  \rec{\mathbb{N}}\big(
  \ack(m, 1),
  \lam{n}{s}\ack(m, s(\ack(m, -), n)),
  0
  \big)
  \\&\equiv
  \ack(m, 1)
\end{align*}%
Finally, using the first few steps of this second calculation again,
%\begin{align*}
  &\phantom{\equiv} \ack(\suc(m), \suc(n))
  \\&\equiv
  \rec{\mathbb{N}}\big(
    \suc,
    \lam{m}{r}
      \rec{\mathbb{N}}\big(
        r(1),
        \lam{n}{s}r(s(r, n))
      \big),
    \suc(m)
  \big)(\suc(n))
  \\&\equiv
  \rec{\mathbb{N}}\big(
  \ack(m, 1),
  \lam{n}{s}\ack(m, s(\ack(m, -), n)),
  \suc(n)
  \big)
  \\&\equiv
  (\lam{s}\ack(m, s(\ack(m, -), n)))
  \rec{\mathbb{N}}\big(
  \ack(m, 1),
  \lam{n}{s}\ack(m, s(\ack(m, -), n)),
  n
  \big)
\end{align*}%


%\exer{1.11}{56}%  
Show that for any type $A$, we have $\lnot\lnot\lnot A \to
\lnot A$.


%\soln% 
Suppose that $\lnot\lnot\lnot A$ and $A$.  Supposing further that $\lnot
A$, we get a contradiction with the second assumption, so $\lnot \lnot A$.  But
this contradicts the first assumption that $\lnot\lnot\lnot A$, so $\lnot A$.
Discharging the first assumption gives $\lnot\lnot\lnot A \to \lnot A$.


In type-theoretic terms, the first assumption is $x : ((A \to \emptyt) \to
\emptyt) \to \emptyt$, and the second is $a : A$.  If we further assume that
$h : A \to \emptyt$, then $h(a) : \emptyt$, so discharging the $h$ gives
%\[
  \lam{h:A \to \emptyt}h(a) : (A \to \emptyt) \to \emptyt
\]%
But then we have
%\[
  x(\lam{h : A \to \emptyt}h(a)) : \emptyt
\]%
so discharging the $a$ gives
%\[
  \lam{a:A}x(\lam{h : A \to \emptyt}h(a)) : A \to \emptyt
\]%
And discharging the first assumption gives
%\[
  \lam{x:((A\to\emptyt)\to\emptyt)\to\emptyt}{a:A}x(\lam{h : A \to
    \emptyt}h(a)) :
  (((A \to \emptyt) \to \emptyt) \to \emptyt) \to (A \to \emptyt)
\]%
This is automatic for Coq, though not trivial *)


Goal forall A, ~ ~ ~ A -> ~A. auto. Qed.

(** 
%\noindent% 
We can get a proof out of Coq by printing this
Goal.  It returns
[[
fun (A : Type) (X : ~ ~ ~ A) (X0 : A) => X (fun X1 : A -> Empty => X1 X0) 
: forall A : Type, ~ ~ ~ A -> ~ A
]]
which is just the function obtained by hand.


%\exer{1.12}{56}%  
Using the propositions as types interpretation, derive the
following tautologies.
\begin{enumerate}
  \item If $A$, then (if $B$ then $A$).
  \item If $A$, then not (not $A$).
  \item If (not $A$ or not $B$), then not ($A$ and $B$).
\end{enumerate} *)

(* begin hide *)
Section Exercise12.
Context {A B : Type}.
(* end hide *)
(** 
%\soln% 
(i)  Suppose that $A$ and $B$; then $A$.  Discharging the
assumptions, $A \to B \to A$.  That is, we
have 
%\[
  \lam{a:A}{b:B}a : A \to B \to A
\]%
and in Coq, *)


Goal A -> B -> A. trivial. Qed.

(** 
(ii)  Suppose that $A$.  Supposing further that $\lnot A$ gives a
contradiction, so $\lnot\lnot A$.  That is,
%\[
  \lam{a:A}{f:A \to \emptyt}f(a) : A \to (A \to \emptyt) \to \emptyt
\]% *)

Goal A -> ~ ~ A. auto. Qed.

(** 
(iii)
Finally, suppose $\lnot A \lor \lnot B$.  Supposing further that $A \land B$
means that $A$ and that $B$.  There are two cases.  If $\lnot A$, then we have
a contradiction; but also if $\lnot B$ we have a contradiction.  Thus $\lnot (A
\land B)$.


Type-theoretically, we assume that $x : (A \to\emptyt) + (B \to\emptyt)$ and $z
: A \times B$.  Conjunction elimination gives $\fst z : A$ and $\snd z : B$.
We can now perform a case analysis.  Suppose that $x_{A} : A \to \emptyt$; then
$x_{A}(\fst z) : \emptyt$, a contradicton; if instead $x_{B} : B \to \emptyt$,
then $x_{B}(\snd z) : \emptyt$.  By the recursion principle for the coproduct,
then,
%\[
  f(z) \defeq \rec{(A\to\emptyt)+(B\to\emptyt)}(
    \emptyt,
    \lam{x}x(\fst z),
    \lam{x}x(\snd z)
  )
  :
  (A \to \emptyt) + (B \to \emptyt) \to \emptyt
\]%
Discharging the assumption that $A \times B$ is inhabited, we have
%\[
  f : 
  A \times B \to (A \to \emptyt) + (B \to \emptyt) \to \emptyt
\]%
So
%\[
  \mathsf{swap}(A\times B, (A\to\emptyt)+(B\to\emptyt), \emptyt, f)
  :
  (A \to \emptyt) + (B \to \emptyt) 
  \to 
  A \times B 
  \to \emptyt
\]% *)

Goal (~ A + ~ B) -> ~ (A * B).
Proof.
    unfold not.
    intros H X.
    apply H.
    destruct X.
    constructor.
    exact a.
Qed.

(* begin hide *)
End Exercise12.
(* end hide *)

(**
%\exer{1.13}{57}%
Using propositions-as-types, derive the double negation of the
principle of excluded middle, i.e.~prove \emph{not (not ($P$ or not $P$))}. *)

(* begin hide *)
Section Exercise13.
Context {P : Type}.
(* end hide *)

(** 
%\soln%  
Suppose that $\lnot(P \lor \lnot P)$.  Then, assuming $P$, we have
$P \lor \lnot P$ by disjunction introduction, a contradiction.  Hence
$\lnot P$.  But disjunction introduction on this again gives $P \lor \lnot P$,
a contradiction.  So we must reject the remaining assumption, giving
$\lnot\lnot(P \lor \lnot P)$.


In type-theoretic terms, the initial assumption is that $g : P + (P \to
\emptyt) \to \emptyt$.  Assuming $p : P$, disjunction introduction results in
$\inl(p) : P + (P \to \emptyt)$.  But then $g(\inl(p)) : \emptyt$, so we
discharge the assumption of $p : P$ to get
%\[
  \lam{p:P}g(\inl(p)) : P \to \emptyt
\]%
Applying disjunction introduction again leads to contradiction, as
%\[
  g(\inr(\lam{p:P}g(\inl(p)))) : \emptyt
\]%
So we must reject the assumption of $\lnot( P \lor \lnot P)$, giving the
result:
%\[
  \lam{g:P + (P \to \emptyt) \to \emptyt}g(\inr(\lam{p:P}g(\inl(p)))) 
  : 
  (P + (P \to \emptyt) \to \emptyt) \to \emptyt
\]%
Finally, in Coq, *)


Goal ~ ~ (P + ~P).

Proof.

unfold not.

intro H.

apply H.

right.

intro p.

apply H.

left.

apply p.

Qed.

(* begin hide *)
End Exercise13.
(* end hide *)

(** 
%\exer{1.14}{57}%  
Why do the induction principles for identity types not allow
us to construct a function $f : \prd{x:A}\prd{p:x=x}(p = \refl{x})$ with the
defining equation
%\[
  f(x, \refl{x}) \defeq \refl{\refl{x}}\qquad?
\]%


%\exer{1.15}{57}% 
Show that indiscernability of identicals follows from path
induction.
*)
