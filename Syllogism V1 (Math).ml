type proposition = Universelle | Particuliere;;
type qualite = Affirmative | Negative;;

type figure = | Figure1 | Figure2 | Figure3 | Figure4;;

type syllogisme = {
 u1 : bool;
 u2 : bool;
 uc : bool;
 a1 : bool;
 a2 : bool;
 ac : bool;
 s : bool;
 p : bool;
}
;;

let create_syllogisme (u1 u2 uc a1 a2 ac s p) : syllogisme = {
  u1 = u1;
  u2 = u2;
  uc = uc;
  a1 = a1;
  a2 = a2;
  ac = ac;
  s = s;
  p = p;
}
;;

let determine_type_proposition (u, a : bool * bool) : proposition =
  if u && a then Universelle
  else if not u && not a then Particuliere
  else failwith "Combination is invalid"
;;

let determine_figure (s, p : bool * bool) : figure =
  if s && p then Figure1
  else if s = false && p then Figure2
  else if s && p = false then Figure3
  else if not s && not p then Figure4
  else failwith "Combination is invalid"
;;

(* Question 1 *)
let z = create_syllogism(true, false, true, true, false, true, false, true);;

(*  Si deux prémisses sont affirmatives, alors la conclusion doit être affirmative *)
let rmt (z : syllogisme) : bool = (z.a1 && z.a2) = z.ac;;

(* Si une prémisse est négative, alors la conclusion doit être négative *)
let rlh (z : syllogisme) : bool =
  not z.a1 || not z.a2 = not z.ac
;;

(* Si la conclusion est négative, alors les deux prémisses doivent être négatives *)
let rnn (z : syllogisme) : bool =
  not z.ac = not a.a1 && not a.a2
;;

(* Si une prémisse est négative, alors l'autre prémisse et la conclusion doivent être négatives *)
let rn (z : syllogisme) : bool =
    z.a1 = false && z.a2 = false && z.ac = false
(*   not z.a1 = not z.a2 && not z.ac && not z.a2 = not z.a1 && not z.ac *)
;;

(* Si une prémisse est affirmative, alors l'autre prémisse et la conclusion doivent être affirmatives *)
let raa (z : syllogisme) : bool =
  z.a1 = z.a2 && z.ac && z.a2 = p1 && z.ac
 (* p1 = true && p2 = true && pc = true *)
;;

(* TODO: Re-do this function *)
(* Si une prémisse est particulière, alors la conclusion doit être particulière *)
let rpp (z : syllogisme) : bool =
    (z.a1 = Particuliere || z.a2 = Particuliere) && z.ac = Particuliere
;;

(*  Si une prémisse est universelle, alors la conclusion doit être universelle *)
let rp (z : syllogisme) : bool =
   (z.u1 || z.u2) && z.uc
;;

(* Question 2 *)
