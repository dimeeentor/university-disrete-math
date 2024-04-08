(* Question 1 *)
(** [bin_to_hex bin_list] est une fonction qui prend une liste de chiffres binaires [bin_list] et la convertit en une représentation hexadécimale sous forme de chaîne.
    Elle convertit d'abord la liste binaire en une chaîne binaire, puis utilise la fonction [int_of_string] pour convertir la chaîne binaire en un entier.
    Enfin, elle utilise la fonction [Printf.sprintf] avec le spécificateur de format "%X" pour convertir l'entier en chaîne hexadécimale.
    @param bin_list La liste des chiffres binaires.
    @return La représentation hexadécimale de la chaîne de caractères du nombre binaire. *)
let bin_to_hex (bin_list : int list) : string =
  let bin_str : string ref = ref "" in
  let length : int = List.length bin_list - 1 in
  for i = 0 to length do
    let bit = List.nth bin_list i in
    bin_str := !bin_str ^ string_of_int bit
  done;
  Printf.sprintf "%X" (int_of_string ("0b" ^ !bin_str))
;;

bin_to_hex [1; 0; 1; 0; 1; 0; 1; 0];;

(* Question 2 *)
(** [int_to_bin n] est une fonction qui prend un entier [n] et le convertit en une liste de chiffres binaires.
    Elle utilise une fonction d'aide [helper] qui divise récursivement [n] par 2 et ajoute le reste (0 ou 1) à la liste d'accumulateurs [acc].
    La récursivité s'arrête lorsque [n] devient 0, et la liste d'accumulateurs finale est renvoyée.
    @param n L'entier à convertir en binaire.
    @return La liste des chiffres binaires représentant l'entier. *)
let int_to_bin (n : int) : int list =
 let rec helper n acc =
   if n = 0 then acc
   else helper (n / 2) ((n mod 2) :: acc)
 in
 helper n []
;;

int_to_bin 42;;

(* Question 3 *)
(** La fonction [liste inversée] prend une liste [liste] et renvoie une nouvelle liste dont les éléments sont classés dans l'ordre inverse.
    Elle utilise une fonction d'aide [helper] qui ajoute récursivement la tête de la liste restante à la liste accumulatrice.
    La récursivité s'arrête lorsque la liste restante devient vide, et la liste accumulatrice finale est renvoyée.
    @param liste La liste à inverser.
    @return La liste inversée. *)
let reverse list =
  let rec helper acc remaining =
    if remaining = [] then acc
    else
      helper (List.hd remaining :: acc) (List.tl remaining)
  in
  helper [] list
;;

let inc_bin bin_list =
  let rec helper bin_list carry =
    if bin_list = [] && carry = 1 then
      [1]
    else if bin_list = [] && carry = 0 then
      []
    else if carry = 0 then
      ((List.hd bin_list + 1) mod 2) :: (List.tl bin_list)
    else
      0 :: (helper (List.tl bin_list) 1)
  in
  let rev_bin_list = List.rev bin_list in
  let result = helper rev_bin_list 1 in
  reverse result
;;

inc_bin [1; 0; 1; 0; 1; 0; 1; 0];;

(* Question 4 *)
(** [twos_comp n] est une fonction qui prend un entier [n] et renvoie sa représentation en complément à deux sous la forme d'une chaîne hexadécimale.
    Elle convertit d'abord la valeur absolue de [n] en une liste binaire à l'aide de la fonction [int_to_bin].
    Si [n] est négatif, il annule chaque bit de la liste binaire, incrémente le résultat de 1 à l'aide de la fonction [inc_bin] et le convertit en chaîne hexadécimale à l'aide de la fonction [bin_to_hex].
    Si [n] est positif ou nul, il convertit directement la liste binaire en chaîne hexadécimale à l'aide de la fonction [bin_to_hex].
    @param n L'entier à convertir en complément à deux.
    @return La représentation en complément à deux de l'entier sous forme de chaîne hexadécimale. *)
let twos_comp n =
  let bin_list = int_to_bin (abs n) in
  let is_neg = n < 0 in
  let bin_list =
    if is_neg then
      let new_bin_list = ref [] in
      let length = List.length bin_list - 1 in
      for i = 0 to length do
        new_bin_list := (1 - List.nth bin_list i) :: !new_bin_list
      done;
      inc_bin (!new_bin_list)
    else
      bin_list
  in
  let hex_str = bin_to_hex bin_list in
  if is_neg then "-0x" ^ hex_str
  else "0x" ^ hex_str
;;

twos_comp (42);;

(* Question 5 *)
(** [bin_to_int bin_list] est une fonction qui prend une liste de chiffres binaires [bin_list] et la convertit en un nombre entier.
    Elle convertit d'abord la liste binaire en une chaîne binaire, puis utilise la fonction [int_of_string] pour convertir la chaîne binaire en un nombre entier.
    Si la liste binaire représente un nombre négatif (le premier bit est 1) et que sa longueur est supérieure à 32, elle soustrait la valeur du bit le plus significatif du résultat pour obtenir la représentation en complément à deux.
    @param bin_list La liste des chiffres binaires.
    @return La représentation entière du nombre binaire. *)
let bin_to_int bin_list =
  let bin_str = ref "" in
  for i = 0 to List.length bin_list - 1 do
    let bit = List.nth bin_list i in
    bin_str := !bin_str ^ string_of_int bit
  done;
  let value = int_of_string ("0b" ^ !bin_str) in
  let not_empty = bin_list <> [] in
  if not_empty && List.nth bin_list 0 = 1 && List.length bin_list > 32 then
    let power_of_two = 1 lsl (List.length bin_list - 32) in
    value - power_of_two * (1 lsl 32)
  else
    value
;;

bin_to_int [1; 0; 1; 0; 1; 0; 1; 0; 1];;
