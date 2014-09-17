(* begin hide *)
Require Export HoTT Ch06_2 hit.Torus.
(* end hide *)
(** printing <~> %\ensuremath{\eqvsym}% **)
(** printing == %\ensuremath{\sim}% **)
(** printing ^-1 %\ensuremath{^{-1}}% **)

(** %\exer{6.3}{217}% 
Prove that the torus $T^{2}$ as defined in %\S6.6% 
is equivalent to $\Sn^{1} \times \Sn^{1}$.
*) 

(** %\soln%
We first define $f : T^{2} \to \Sn^{1} \times \Sn^{1}$ by torus recursion,
using the maps
%\begin{align*}
  b &\mapsto (\base, \base) \\
  p &\mapsto \pair^{=}(\refl{\base}, \lloop)\\
  q &\mapsto \pair^{=}(\lloop, \refl{\base})\\
  \Phi(\alpha, \alpha) &: \lam{\alpha : x = x'}{\alpha' : y = y'}
    \left(\pair^{=}(\refl{x}, \alpha') \ct \pair^{=}(\alpha, \refl{y'})\right)
    =
    \left(\pair^{=}(\alpha, \refl{y}) \ct \pair^{=}(\refl{x'}, \alpha')\right) \\
  t &\mapsto \Phi(\lloop, \lloop)
\end{align*}%
Where $\Phi$ is defined by recursion on $\alpha$ and $\alpha'$.  To define a
function $f : \Sn^{1} \times \Sn^{1} \to T^{2}$, we need a function $\tilde{f}
: \Sn^{1} \to \Sn^{1} \to T^{2}$, which we'll define by double circle
recursion.  $\tilde{f}' : \Sn^{1} \to T^{2}$ is given by $b \mapsto \base$ and
$\lloop \mapsto p$.  Then $\tilde{f}$ is defined by $b \mapsto \tilde{f}'$ and
%\begin{align*}
  \lloop &\mapsto 
\end{align*}%
*)

Definition Phi {A : Type} {x x' y y' : A} (alpha : x = x') (alpha' : y = y') 
: ((path_prod (x, y) (x, y') 1 alpha') @ (path_prod (x, y') (x', y') alpha 1)) 
  = ((path_prod (x, y) (x', y) alpha 1) @ (path_prod (x', y) (x', y') 1 alpha')). 
  induction alpha.
  induction alpha'. 
  reflexivity.
Defined.

(** %\exer{6.4}{217}% 
Define dependent $n$-loops and the action of dependent functions on $n$-loops,
and write down the induction principle for the $n$-spheres as defined at the
end of %\S6.4%.
*)

(** %\exer{6.5}{217}%
Prove that $\eqv{\susp\Sn^{n}}{\Sn^{n+1}}$, using the definition of $\Sn^{n}$
in terms of $\Omega^{n}$ from %\S6.4%.
*)

(** %\soln%
This definition defines $\Sn^{n}$ as the higher inductive type generated by
 - $\base_{n} : \Sn^{n}$
 - $\lloop_{n} : \Omega^{n}(\Sn^{n}, \base)$.
To define a function $\susp\Sn^{n} \to \Sn^{n+1}$, we send both $\north$ and
$\south$ to $\base_{n+1}$.  So we need a function $m : \Sn^{n} \to (\base_{n+1}
= \base_{n+1})$, for which we use $\Sn^{n}$-recursion.
*)


(** %\exer{6.6}{217}% 
Prove that if the type $\Sn^{2}$ belongs to some universe $\UU$, then $\UU$ is
not a 2-type.
*)

(** %\exerdone{6.7}{217}% 
Prove that if $G$ is a monoid and $x : G$, then $\sm{y:G}((x \cdot y = e)
\times (y \cdot x = e))$ is a mere proposition.  Conclude, using the principle
of unique choice, that it would be equivalent to define a group to be a monoid
such that for every $x : G$, there merely exists a $y : G$ such that $x \cdot y
= e$ and $y \cdot x = e$.
*)

(** %\soln%
Suppose that $G$ is a monoid and $x : G$.  Since $G$ is a set, each of $x
\cdot y = e$ and $y \cdot x = e$ are mere propositions.  The product preserves
this, so our type is of the form $\sm{y : G} P(y)$ for a family of mere
propositions $P : G \to \UU$.  Now, suppose that there is a point $u : \sm{y :
G} P(y)$; we show that this implies that this type is contractible, hence the
type is a mere proposition.  Since $P(y)$ is a mere proposition, we just need
to show that for any point $v : \sm{y : G} P(y)$, $\fst u = \fst v$.  But this
is just to say that if $\fst u$ has an inverse it is unique, and this is a
basic fact about inverses.

A group is defined to be a monoid together with an inversion function $i : G
\to G$ such that for all $x : G$, $x \cdot i(x) = e$ and $i(x) \cdot x = e$.
That is, the following type is inhabited:
%\[
  \sm{i : G \to G}\prd{x : G}\left(
    (x \cdot i(x) = e) \times (i(x) \cdot x = e)
  \right)
\]%
but this type is equivalent to the type
%\[
  \prd{x : G}\sm{y : G}
  \left(
    (x \cdot y = e) \times (y \cdot x = e)
  \right)
\]%
And as we have just shown, this is of the form $\prd{x:G} Q(x)$ for $Q$ a
family of mere propositions.  Thus, by the principle of unique choice, it
suffices to demand that for each $x : G$ we have $\brck{Q(x)}$.  Thus these two
requirements are equivalent.
*)

Class IsMonoid (A : Type) (m : A -> A -> A) (e : A) 
  := BuildIsMonoid {
         m_isset : IsHSet A ;
         m_unitr : forall a : A, m a e = a ;
         m_unitl : forall a : A, m e a = a ;
         m_assoc : forall x y z : A, m x (m y z) = m (m x y) z
       }.

Record Monoid 
  := BuildMonoid {
         m_set :> Type ;
         m_mult :> m_set -> m_set -> m_set ;
         m_unit :> m_set ;
         m_ismonoid :> IsMonoid m_set m_mult m_unit
       }.

Lemma hprop_prod :
  forall A, IsHProp A -> forall B, IsHProp B -> IsHProp (A * B).
Proof.
  intros A HA B HB z z'.
  apply (trunc_equiv (equiv_path_prod z z')).
Defined.
  
Theorem hprop_inverse_exists (G : Monoid) (x : G) :
  IsHProp {y : G & (G x y = G) * (G y x = G)}.
Proof.
  (* reduce to uniqueness of inverse *)
  assert (forall y : G, IsHProp ((G x y = G) * (G y x = G))). intro y.
  apply hprop_prod; intros p q; apply G.
  apply hprop_inhabited_contr. intro u. exists u.
  intro v. apply path_sigma_hprop.

  (* inverse is unique *)
  refine ((@m_unitr _ G G G _)^ @ _).
  refine (_ @ (@m_unitl _ G G G _)). 
  transitivity (G u.1 (G x v.1)). f_ap. symmetry. apply (fst v.2).
  transitivity (G (G u.1 x) v.1). refine (@m_assoc G G G G _ _ _).
  f_ap. apply (snd u.2).
Defined.


Class IsGroup (A : Monoid) (i : A -> A) 
  := BuildIsGroup {
         g_invr : forall a : A, (m_mult A) a (i a) = (m_unit A) ;
         g_invl : forall a : A, (m_mult A) (i a) a = (m_unit A)
       }.

Record Group 
  := BuildGroup {
         g_monoid :> Monoid ;
         g_inv :> (m_set g_monoid) -> (m_set g_monoid) ;
         g_isgroup :> IsGroup g_monoid g_inv
       }.

Theorem issig_group : 
  {G : Monoid & {i : G -> G & forall a, (G a (i a) = G) * (G (i a) a = G)}} 
    <~>
    Group.
Proof.
  apply (@equiv_compose' _ {G : Monoid & {i : G -> G & IsGroup G i}} _).
  issig BuildGroup g_monoid g_inv g_isgroup.
  apply equiv_functor_sigma_id. intro G.
  apply equiv_functor_sigma_id. intro i.
  apply (@equiv_compose' _
                         {_ : forall a, (G a (i a) = G)
                                & (forall a : G, G (i a) a = G)}
                         _).
  issig (BuildIsGroup G i) (@g_invr G i) (@g_invl G i).
  refine (equiv_adjointify _ _ _ _); intro z.
    apply (fun a => fst (z a); fun a => snd (z a)).
    apply (fun a => (z.1 a, z.2 a)).
    destruct z as [g h]. apply path_sigma_uncurried. exists 1. reflexivity.
    apply path_forall; intro a. apply eta_prod.
Defined.
  
Theorem ex6_7 :
  {G : Monoid & forall x, Brck {y : G & (G x y = G) * (G y x = G)}}
  <~>
  Group.
Proof.
  apply (@equiv_compose' _
                         {G : Monoid & 
                          forall x : G, {y : G & (G x y = G) * (G y x = G)}} 
                         _).
  apply (@equiv_compose' _
                         {G : Monoid & 
                         {i : G -> G & 
                          forall a, (G a (i a) = G) * (G (i a) a = G)}} 
                         _).
  apply issig_group. 
  apply equiv_functor_sigma_id. intro G.
  apply (BuildEquiv _ _ 
                    (Book_2_15_6 _ _ (fun x y => (G x y = G) * (G y x = G)))).
  apply Book_2_15_7.
  apply equiv_functor_sigma_id. intro G.
  apply equiv_functor_forall_id. intro x.
  apply equiv_inverse.
  apply (BuildEquiv _ _ min1).
  refine IsEquivmin1.
  apply hprop_inverse_exists.
Defined.
  
  


(** %\exerdone{6.8}{217}% 
Prove that if $A$ is a set, then $\lst{A}$ is a monoid.  Then complete the
proof of Lemma 6.11.5.
*)

(** %\soln%
We first characterise the path space of $\lst{A}$, which goes just as $\N$.
We define the codes
%\begin{align*}
    \codefunc(\nil, \nil) &\defeq \unit \\
    \codefunc(\cons(h, t), \nil) &\defeq \emptyt \\
    \codefunc(\nil, \cons(h', t')) &\defeq \emptyt \\
    \codefunc(\cons(h, t), \cons(h', t')) &\defeq (h=h') \times \codefunc(t, t')
\end{align*}%
and the function $r : \prd{\ell : \lst{A}} \codefunc(\ell, \ell)$ by
%\begin{align*}
        r(\nil) &\defeq \star \\
        r(\cons(h, t)) &\defeq (\refl{h}, r(t))
\end{align*}%
Now, for all $\ell, \ell' : \lst{A}$, $\eqv{(\ell = \ell')}{\codefunc(\ell,
\ell')}$.  To prove this, we define
%\[
  \encode(\ell, \ell', p) \defeq \transfib{\codefunc(\ell, -)}{p}{r(\ell)}
\]%
and we define $\decode$ by double induction on $\ell, \ell'$.  When they're
both $\nil$, send everything to $\refl{\nil}$.  When one is $\nil$ and the
other a $\cons$, we use the eliminator for $\emptyt$.  When they're both a
cons, we define
%\begin{align*}
  \codefunc(\cons(h, t), \cons(h', t'))
  &\equiv
  (h = h') \times \codefunc(t, t') \\
  &\xrightarrow{\idfunc{h=h'} \times \decode(t, t')}
  (h = h') \times (t = t') \\
  &\xrightarrow{\pair^{=}}
  ((h, t) = (h', t')) \\
  &\xrightarrow{\mapfunc{\lam{z}\cons(\fst z, \snd z)}}
  (\cons(h, t) = \cons(h', t'))
\end{align*}%
It follows easily from induction on everything and naturality that these are
quasi-inverses.  The only point of note is that the fact that $A$ is a set is
required in the proof of
%\[
  \encode(\ell, \ell', \decode(\ell, \ell', z)) = z
\]%
This is because our definition of $\encode$ involved an arbitrary choice in
how $r$ acts on $\cons$, and this choice is only preserved up to homotopy.
*)

Local Open Scope list_scope.

Fixpoint list_code {A : Type} (l l' : list A) : Type :=
  match l with
    | nil => match l' with
               | nil => Unit
               | h' :: t' => Empty
             end
    | h :: t => match l' with
                    | nil => Empty
                    | h' :: t' => (h = h') * (list_code t t')
                  end
  end.

Fixpoint list_r {A : Type} (l : list A) : list_code l l :=
  match l with
    | nil => tt
    | h :: t => (1, list_r t)
  end.

Definition list_encode {A : Type} (l l' : list A) (p : l = l') := 
  transport (fun x => list_code l x) p (list_r l).

Definition list_decode {A : Type} : 
  forall (l l' : list A) (z : list_code l l'), l = l'.
  induction l as [| h t]; destruct l' as [| h' t']; intros.
    reflexivity. contradiction. contradiction.
    apply (@ap _ _ (fun x => cons (fst x) (snd x)) (h, t) (h', t')).
    apply path_prod. apply (fst z). apply IHt. apply (snd z).
Defined.

Definition path_list {A : Type} : forall (h h' : A) (t t' : list A),
  h = h' -> t = t' -> h :: t = h' :: t'.
Proof.
  intros h h' t t' ph pt.
  apply (list_decode _ _). split. 
    apply ph.
    apply (list_encode _ _). apply pt.
Defined.

Theorem equiv_path_list {A : Type} {H : IsHSet A} (l l' : list A) : 
  (list_code l l') <~> (l = l').
Proof.
  refine (equiv_adjointify (list_decode l l') (list_encode l l') _ _).

  (* lst_decode o lst_encode == id *)
  intro p. induction p. 
  induction l as [|h t]. reflexivity. simpl in *.
  refine (_ @ (ap_1 _ _)). f_ap.
  transitivity (path_prod (h, t) (h, t) 1 1). f_ap. reflexivity.

  (* lst_encode o lst_decode == id *)
  generalize dependent l'.
  induction l as [|h t], l' as [|h' t']; intro z.
    apply contr_unit. contradiction. contradiction.
    simpl. unfold list_encode.
    refine ((transport_compose _ _ _ _)^ @ _).
    refine ((transport_prod 
               (path_prod (h, t) (h', t') (fst z) (list_decode t t' (snd z)))
               (1, list_r t)) @ _).
    destruct z as [p c].
    apply path_prod. apply H.
    refine ((transport_path_prod _ _ _ _ _ _ _ _) @ _).
    induction p. apply (IHt t').
Defined.

(** %\noindent%
It's now easy to see that $\lst{A}$ is a set, by induction.
If $\ell \equiv \ell' \equiv \nil$, then $\eqv{(\ell = \ell')}{\unit}$, which
is contractible.
Similarly, if only one is $\nil$ then $\eqv{(\ell = \ell')}{\emptyt}$, which
is contractible.
Finally, if both are $\cons$es, then the path space is $(h = h') \times
\codefunc(t, t')$.  The former is contractible because $A$ is a set, and the
latter is contractible by the induction hypothesis.  Contractibility is
preserved by products, so the path space is contractible.
*)
  
Theorem set_list_is_set (A : Type) : IsHSet A -> IsHSet (list A).
Proof.
  intros HA l.
  induction l as [|h t].
    intro l'; destruct l' as [|h' t'].
    apply (trunc_equiv (equiv_path_list nil nil)).
    apply (trunc_equiv (equiv_path_list nil (h' :: t'))).
    intro l'; destruct l' as [|h' t'].
    apply (trunc_equiv (equiv_path_list (h :: t) nil)).
    transparent assert (r : (IsHProp (list_code (h :: t) (h' :: t')))).
    simpl. apply hprop_prod. 
    apply hprop_allpath. apply HA.
    apply (trunc_equiv (equiv_path_list t t')^-1).
    apply (trunc_equiv (equiv_path_list (h :: t) (h' :: t'))).
Defined.


(** Now, to show that $\lst{A}$ is a monoid, we must equip it with a
multiplication function and a unit element.  For the multiplication function we
use append, and for the unit we use $\nil$.  These must satisfy two properties.
First we must have, for all $\ell : \lst{A}$, $\ell \cdot \nil = \nil \cdot
\ell = \ell$, which we clearly do.  Second, append must be associative, which
it clearly is.
*)

(* move these elsewhere *)

Theorem app_nil_r {A : Type} : forall l : list A, l ++ nil = l.
Proof. induction l. reflexivity. simpl. f_ap. Defined.

Theorem app_assoc {A : Type} : forall x y z : list A,
  x ++ (y ++ z) = (x ++ y) ++ z.
Proof. 
  intros x y z. induction x. reflexivity.
  simpl. apply path_list. reflexivity. apply IHx.
Defined.


Theorem set_list_is_monoid {A : Type} {HA : IsHSet A} : 
  IsMonoid (list A) (@app A) nil.
Proof.
  apply BuildIsMonoid.
  apply set_list_is_set. apply HA. 
  apply app_nil_r. reflexivity.
  apply app_assoc.
Defined.
    
(** Now, Lemma 6.11.5 states that for any set $A$, the type $\lst{A}$ is the
free monoid on $A$.  That is, there is an equivalence
%\[
  \eqv{
    \hom_{\text{Monoid}}(\lst{A}, G)
  }{
    (A \to G)
  }
\]%
There is an obvious inclusion $\eta : A \to \lst{A}$ defined by $a \mapsto
\cons(a, \nil)$, and this defines a map $({-} \circ \eta)$ giving the forward
direction of the equivalence.  For the other direction, suppose that $f : A \to
G$.  We lift this to a map $\bar{f} : \lst{A} \to G$ by recursion:
%\begin{align*}
  \bar{f}(\nil) &\defeq e \\
  \bar{f}(\cons(h, t)) &\defeq f(h) \cdot \bar{f}(t)
\end{align*}%
To show that this is a monoid homomorphism, we must show
%\begin{align*}
  \bar{f}(\nil) &= e \\
  \bar{f}(\ell \cdot \ell') &= \bar{f}(\ell) \cdot \bar{f}(\ell')
\end{align*}%
The first is a judgemental equality, so we just need to show the second, which
we do by induction on $\ell$.  When $\ell \equiv \nil$ we have
%\[
  \bar{f}(\nil \cdot \ell')
  \equiv
  \bar{f}(\ell')
  =
  e \cdot \bar{f}(\ell')
  \equiv
  \bar{f}(\nil) \cdot \bar{f}(\ell')
\]%
and when it is a cons,
%\begin{align*}
  \bar{f}(\cons(h, t) \cdot \ell')
  &=
  \bar{f}(\cons(h, t \cdot \ell'))
  =
  f(h) \cdot \bar{f}(t \cdot \ell')
  =
  f(h) \cdot \bar{f}(t) \cdot \bar{f}(\ell')
  =
  f(\cons(h, t)) \cdot \bar{f}(\ell')
\end{align*}%
by the induction hypothesis in the third equality.  So $\bar{f}$ is a monoid
homomorphism.

To show that these are quasi-inverses, suppose that $f :
\hom_{\text{Monoid}}(\lst{A}, G)$.  Then we must show that
%\[
  \overline{f \circ \eta} = f
\]%
which we do by function extensionality and induction.  When $\ell \equiv \nil$,
we have
%\[
  \overline{f \circ \eta}(\nil) \equiv e = f(\nil)
\]%
Since $f$ is a monoid homomorphism.  When $\ell \equiv \cons(h, t)$,
%\begin{align*}
  \overline{f \circ \eta}(\cons(h, t))
  &\equiv
  f(\eta(h))
  \cdot
  \overline{f \circ \eta}(t)
  =
  f(\eta(h))
  \cdot
  f(t)
  =
  f(\cons(h, \nil) \cdot t)
  \equiv
  f(\cons(h, t))
\end{align*}%
So by function extensionality $\overline{f \circ \eta} = f$.  We must
also show that the proofs that $\overline{f \circ \eta}$ and $f$ are
monoid homomorphisms are equal.  This turns out to be trivial,
however: since monoids are structures on sets, all of the relevant
proofs are of equalities in sets, so the structures are mere
propositions, and equality of the underlying maps is equivalent to
equality of the homomorphisms.

For the other direction, suppose that $f : A \to G$.  We show that
%\[
  \bar{f} \circ \eta = f
\]%
again by function extensionality.  Suppose that $a : A$; then
%\[
  \bar{f}(\eta(a)) 
  \equiv \bar{f}(\cons(a, \nil))
  \equiv f(a) \cdot \bar{f}(\nil)
  \equiv f(a) \cdot e
  = f(a)
\]%
and we're done.
*)

Notation "[ ]" := nil.
Notation "[ x ; .. ; y ]" := (cons x .. (cons y nil) ..).
    
Class IsMonoidHom {A B : Monoid} (f : A -> B) :=
  BuildIsMonoidHom {
      hunit : f (m_unit A) = m_unit B ;
      hmult : forall a a' : A, f ((m_mult A) a a') = (m_mult B) (f a) (f a')
    }.

Record MonoidHom (A B : Monoid) := 
  BuildMonoidHom {
      mhom_fun :> A -> B ;
      mhom_ismhom :> IsMonoidHom mhom_fun
    }.


Definition homLAG_to_AG (A : Type) (HA : IsHSet A) (G : Monoid) :
  MonoidHom (BuildMonoid (list A) _ _ set_list_is_monoid) G -> (A -> G)
  := fun f a => (mhom_fun _ G f) [a].

Definition AG_to_homLAG (A : Type) (HA : IsHSet A) (G : Monoid) :
  (A -> G) -> MonoidHom (BuildMonoid (list A) _ _ set_list_is_monoid) G.
Proof.
  (* lift f by recursion *)
  intro f.
  refine (BuildMonoidHom _ G _ _).
  intro l. induction l as [|h t]. 
  apply (m_unit G).
  apply ((m_mult _) (f h) IHt).

  apply BuildIsMonoidHom.
  (* takes the unit to the unit *)
  reflexivity.
  
  (* respects multiplication *)
  simpl. intro l. induction l. intro l'. simpl.
  refine (_ @ (m_unitl _)^). reflexivity. apply G.

  intro l'. simpl. refine (_ @ (m_assoc _ _ _)).
  f_ap. apply (m_unit _). apply G.
Defined.

Theorem isprod_ismonoidhom {A B : Monoid} (f : A -> B) :
  (f (m_unit A) = m_unit B) 
  * (forall a a', f ((m_mult A) a a') = (m_mult B) (f a) (f a'))
  <~>
  IsMonoidHom f.
Proof.
  (* I think this should be a judgemental equality, but it's not *)
  etransitivity {_ : f A = B & forall a a' : A, f (A a a') = B (f a) (f a')}.
  refine (equiv_adjointify _ _ _ _); intro z.
    exists (fst z). apply (snd z). apply (z.1, z.2). 
    apply eta_sigma. apply eta_prod.
    
  issig (BuildIsMonoidHom A B f) (@hunit A B f) (@hmult A B f).
Defined.
  

Theorem hprop_ismonoidhom {A B : Monoid} (f : A -> B) : IsHProp (IsMonoidHom f).
Proof.
  refine (trunc_equiv' (isprod_ismonoidhom f)).
  apply hprop_prod.
  intros p q. apply B.
  repeat (apply hprop_dependent; intro). intros p q. apply B.
Defined.
  
Theorem issig_monoidhom (A B : Monoid) :
  {f : A -> B & IsMonoidHom f} <~> MonoidHom A B.
Proof.
  issig (BuildMonoidHom A B) (@mhom_fun A B) (@mhom_ismhom A B).
Defined.

Theorem equiv_path_monoidhom {A B : Monoid} {f g : MonoidHom A B} :
  ((mhom_fun _ _ f) = (mhom_fun _ _ g)) <~> f = g.
Proof.
  equiv_via ((issig_monoidhom A B)^-1 f = (issig_monoidhom A B)^-1 g).
  refine (@equiv_path_sigma_hprop 
            (A -> B) IsMonoidHom hprop_ismonoidhom
            ((issig_monoidhom A B)^-1 f) ((issig_monoidhom A B)^-1 g)).
  apply equiv_inverse. apply equiv_ap. refine _.
Defined.

Theorem list_is_free_monoid (A : Type) (HA : IsHSet A) (G : Monoid) :
  MonoidHom (BuildMonoid (list A) _ _ set_list_is_monoid) G <~> (A -> G).
Proof.
  transparent assert (HG : (IsMonoid G G G)). apply G.
  refine (equiv_adjointify (homLAG_to_AG _ _ _) (AG_to_homLAG _ _ _) _ _).
  intro f. apply path_forall; intro a.
  simpl. apply (m_unitr _).

  intro f. apply equiv_path_monoidhom. apply path_forall; intro l.
  induction l as [|h t]; simpl.
  symmetry. apply (@hunit _ _ f). apply f.
  transitivity (G (homLAG_to_AG A HA G f h) (f t)). f_ap.
  unfold homLAG_to_AG. refine (@hmult _ _ f _ [h] t)^. apply f.
Defined.
  

Local Close Scope list_scope.


(** %\exer{6.9}{217}% 
Assuming $\LEM{}$, construct a family $f : \prd{X : \UU} (X \to X)$ such that
$f_{\bool} : \bool \to \bool$ is the nonidentity automorphism.
*)

(** %\exer{6.10}{218}% 
Show that the map constructed in Lemma 6.3.2 is in fact a quasi-inverse to
$\happly$, so that the interval type implies the full function extensionality
axiom.
*)

(** %\soln%
Of course, it's easiest to prove the full function extensionality axiom by
referring to Exercise 2.16.  But we want to show something more: that this map
is an inverse to $\happly$.
Let $f g : A \to B$, and suppose that $p : f = g$.  Then $\happly(p) :
\prd{x:A}f(x) = g(x)$.  For all $x : A$ we define a function $\tilde{h} : I \to
B$ by
%\begin{align*}
 \tilde{h}_{x}(0_{I}) &\defeq f(x),  \\
 \tilde{h}_{x}(1_{I}) &\defeq g(x),  \\
 \mapfunc{\tilde{h}_{x}}(\seg) &\defeq \happly(p, x)
\end{align*}%
and we define $q : I \to (A \to B)$ by $q(i) \defeq \lam{x}\tilde{h}_{x}(i)$.
Thus
%\[
  \mapfunc{q}(\seg) \equiv \mapfunc{\lam{x}\tilde{h}_{x}}(\seg)
\]%
*)

Module Exercise6_10.

Module Interval.

Private Inductive interval : Type :=
  | zero : interval
  | one : interval.

Axiom seg : zero = one.

Definition interval_rect (P : interval -> Type)
  (a : P zero) (b : P one) (p : seg # a = b)
  : forall x : interval, P x
  := fun x => (match x return _ -> P x with
                 | zero => fun _ => a
                 | one => fun _ => b
               end) p.

Axiom interval_rect_beta_seg : forall (P : interval -> Type)
  (a : P zero) (b : P one) (p : seg # a = b),
  apD (interval_rect P a b p) seg = p.

End Interval.

Definition interval_rectnd (P : Type) (a b : P) (p : a = b)
  : interval -> P
  := interval_rect (fun _ => P) a b (transport_const _ _ @ p).

Definition interval_rectnd_beta_seg (P : Type) (a b : P) (p : a = b)
  : ap (interval_rectnd P a b p) seg = p.
Proof.
  refine (cancelL (transport_const seg a) _ _ _).
  refine ((apD_const (interval_rect (fun _ => P) a b _) seg)^ @ _).
  refine (interval_rect_beta_seg (fun _ => P) _ _ _).
Defined.

Definition Lemma6_3_2 {A B : Type} (f g : A -> B) : (f == g) -> (f = g).
Proof.
  intro p.
  transparent assert (pt : (forall x:A, interval -> B)).
    intro x. apply (interval_rectnd B (f x) (g x) (p x)).
  transparent assert (q : (interval -> (A -> B))).
    intro i. apply (fun x:A => pt x i).
  apply (ap q seg).
Defined.

 
End Exercise6_10.

(** %\exerdone{6.11}{218}% 
Prove the universal property of suspension:
%\[
  \eqv{ \left(\susp A \to B \right) }{ \left(\sm{b_{n} : B}\sm{b_{s} : B} (A \to (b_{n} = b_{s}))\right) }
\]%
*)

(** %\soln%
To construct an equivalence, suppose that $f : \susp A \to B$.  Then there are
two elements $f(\north), f(\south) : B$ such that there is a map $A \to
(f(\north) = f(\south))$; in particular for any element $a : A$ we have the
element $\merid(a) : (\north = \south)$ which may be pushed forward to give
$f(\merid(a)) : f(\north) = f(\south)$.  For the other direction, suppose that
we have elements $b_{n}, b_{s} : B$ such that $f : A \to (b_{n} = b_{s})$.
Then by suspension recursion we define a function $g : \susp A \to B$ such that
$g(\north) \equiv b_{n}$, $g(\south) \equiv b_{s}$, and $g(\merid(a)) = f(a)$
for all $a : \susp A$.

To show that these are quasi-inverses, suppose that $f : \susp A \to B$.  We
then construct the element $(f(\north), f(\south), \lam{a}f(\merid(a)))$ of the
codomain, and going back gives a function $g : \susp A \to B$ such that
$g(\north) \equiv f(\north)$, $g(\south) \equiv f(\south)$, and $g(\merid(a)) =
f(\merid(a))$ for all $a : \susp A$.  But this just means that $g$ and $f$ have
the same recurrence relation, so we're back where we started.

For the other loop, suppose that we have an element $(b_{n}, b_{s}, f)$ of the
right.  Then we get an arrow $g : \susp A \to B$ on the left such that
$g(\north) = b_{n}$, $g(\south) = b_{s}$, and $g(\merid(a)) = f(a)$ for all $a
: \susp A$.  Going back to the right, we have the element $(b_{n}, b_{s}, f)$,
homotopic to the identity function.
*)

Theorem univ_prop_susp {A B : Type} :
  (Susp A -> B) <~> {bn : B & {bs : B & A -> (bn = bs)}}.
Proof.
  refine (equiv_adjointify _ _ _ _).
  intro f. exists (f North). exists (f South). intro a. apply (ap f (merid a)).
  intro w. destruct w as [bn [bs f]]. apply (Susp_rect_nd bn bs f).

  intro w. destruct w as [bn [bs f]]. 
  apply path_sigma_uncurried. exists 1. 
  apply path_sigma_uncurried. exists 1. 
  apply path_forall; intro a. simpl.
  apply Susp_comp_nd_merid.

  intro f. apply path_forall.
  refine (Susp_rect _ 1 1 _).
  intro a. 
  refine ((trans_paths _ _ _ _ _ _ _ _) @ _).
  apply moveR_pM.
  refine ((concat_p1 _) @ _). refine (_ @ (concat_1p _)^). apply inverse2.
  refine ((Susp_comp_nd_merid _) @ _).
  reflexivity.
Defined.
  

  

(** %\exer{6.12}{218}% 
Show that $\eqv{\Z}{\N + \unit + \N}$.  Show that if we were to define $\Z$ as
$\N + \unit + \N$, then we could obtain Lemma 6.10.12 with judgmental
computation rules.
*)

(** %\soln%
Let $\Z \defeq \sm{x : \N \times \N} (r(x) = x)$, where
%\[
  r(a, b) = \begin{cases}
    (a - b, 0) & \text{if $a \geq b$} \\
    (0, b - a) & \text{otherwise}
 \end{cases}
\]%
To define the forward direction, let $((a, b), p) : \Z$.  If $a = b$, then
produce $\star$.  Otherwise, if $a > b$, produce $\pred(a - b)$ in the right
copy of $\N$.  Otherwise (i.e., when $a < b$), produce $\pred(b - a)$ in the
left copy of $\N$.  To go the other way, we have three cases.  When $n$ is
in the left, send it to $(0, \suc(n))$, along with the appropriate proof.  When
$n \equiv \star$, produce $(0, 0)$.  When $n$ is in the right, send it to
$(\suc(n), 0)$.  Clearly, these two constructions are quasi-inverses, since
$\suc(\pred(n)) = n$ for all $n \neq 0$.
*)

Module Exercise6_12.


Fixpoint monus n m :=
  match m with
    | O => n
    | S m' => pred (monus n m')
  end.

Lemma monus_O_n : forall n, monus O n = O.
Proof. induction n. reflexivity. simpl. change O with (pred O). f_ap. Defined.

Lemma n_le_Sn : forall n, le n (S n).
Proof. intro n. exists (S O). apply (plus_1_r n)^. Defined.

Lemma monus_eq_O__n_le_m : forall n m, (monus n m = O) -> (le n m).
Admitted.

Lemma monus_self : forall n, monus n n = O.
Admitted.
  
Definition n_le_m__Sn_le_Sm : forall (n m : nat), (le n m) -> (le (S n) (S m))
  := fun n m H => (H.1; ap S H.2).

Lemma order_partitions : forall (n m : nat), (le n m) + (lt m n).
Proof.
  induction n.
    intro m. left. exists m. reflexivity.
  induction m.
    right. exists n. reflexivity.
    destruct IHm.
      left. destruct l. exists (S x).
      simpl. apply (ap S). apply ((plus_n_Sm _ _)^ @ p).
      destruct (IHn m).
        left. apply n_le_m__Sn_le_Sm. apply l0.
        right. destruct l0. exists x. simpl. apply (ap S). apply p.
Defined.
  

Definition r : nat * nat -> nat * nat.
  intro z. destruct z as [a b].
  destruct (order_partitions b a).
  apply (monus a b, O).
  apply (O, monus b a).
Defined.
  
Definition int := {x : nat * nat & r x = x}.

Definition int_to_nat_1_nat : int -> (nat + Unit + nat).
  intro z. destruct z as [[a b] p]. destruct (decidable_paths_nat a b).
  left. right. apply tt.
  destruct (order_partitions b a).
  right. apply (pred (monus a b)).
  left. left. apply (pred (monus b a)).
Defined.

Definition nat_1_nat_to_int : (nat + Unit + nat) -> int :=
  fun z =>
    match z with
      | inl a => match a with
                   | inl n => ((O, S n); 1)
                   | inr _ => ((O, O); 1)
                 end
      | inr n => ((S n, O); 1)
    end.
        
Lemma lt_le : forall n m, (lt n m) -> (le n m).
Proof.
  intros n m p. destruct p as [k p]. exists (S k). 
  apply p.
Defined.

Lemma hset_prod : forall A, IsHSet A -> forall B, IsHSet B -> IsHSet (A * B).
Proof.
  intros A HA B HB.
  intros z z'. apply hprop_allpath. apply allpath_hprop.
Defined.

Theorem hset_nat : IsHSet nat.
Proof.
  apply hset_decidable. intros n.
  induction n; intro m; destruct m.
    left. reflexivity.
    right. intro p. apply equiv_path_nat in p. contradiction.
    right. intro p. apply equiv_path_nat in p. contradiction.
    destruct (IHn m).
      left. apply (ap S). apply p.
      right. intro p. apply S_inj in p. contradiction.
Defined.
  

Theorem ex6_12 : int <~> (nat + Unit + nat).
Proof.
  refine (equiv_adjointify int_to_nat_1_nat nat_1_nat_to_int _ _).
  
  intro z. destruct z as [[n | n] | n].
  reflexivity. simpl. repeat f_ap. apply contr_unit. reflexivity.
  
  intro z. destruct z as [[a b] p].
  apply path_sigma_uncurried.
  assert (
    (nat_1_nat_to_int (int_to_nat_1_nat ((a, b); p))).1 = ((a, b); p).1
  ) as H.
  unfold nat_1_nat_to_int, int_to_nat_1_nat.
  destruct (decidable_paths_nat a b).
  unfold r in p. simpl. destruct (order_partitions b a); refine (_ @ p);
    apply path_prod. 
    assert (b = O). apply (ap snd p)^. 
    assert (a = O). apply (p0 @ X).
    simpl. transitivity (monus a 0). simpl. apply X0^. f_ap. apply X^.
    reflexivity.
    reflexivity.
    assert (a = O). apply (ap fst p)^. assert (b = O). apply (p0^ @ X).
    simpl. transitivity (monus b 0). simpl. apply X0^. f_ap. apply X^.

  unfold r in p. simpl. destruct (order_partitions b a); refine (_ @ p);
    apply path_prod.
    simpl. refine ((Spred _ _) @ _).
    intro H. apply monus_eq_O__n_le_m in H. 
    apply le_antisymmetric in H. symmetry in H. apply n in H. contradiction.
    apply l. reflexivity. reflexivity. reflexivity.
    simpl. refine ((Spred _ _) @ _).
    intro H. 
    assert (a = b). refine ((ap fst p)^ @ H^ @ (ap snd p)).  apply n in X.
    contradiction. reflexivity. simpl in *.
    
    exists H.
    assert (IsHSet (nat * nat)) as Hn. apply hset_prod; apply hset_nat.
    apply set_path2.
Defined.

End Exercise6_12.
