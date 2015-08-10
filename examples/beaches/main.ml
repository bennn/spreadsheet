(* open Spreadsheet *)

module BeachSpec = struct
  type row = string * string * int * bool

  let compare_row (n1,_,_,_) (n2,_,_,_) = Pervasives.compare n1 n2

  let row_of_string str =
    let vals = Str.split (Str.regexp "\t") str in
    begin match vals with
    | [name; loc; price; hasbr] ->
      begin try Some (name, loc, int_of_string price, bool_of_string hasbr) with
      | Failure _ -> None
      end
    | _ -> None
    end

  let string_of_row (n,l,p,h) =
    String.concat "\t" [n; l; string_of_int p; string_of_bool h]

  let title = "NAME	LOCALE	PRICE ($)	HAS BATHROOM"
end

module BeachSheet = Spreadsheet.Make(BeachSpec)

let _ =
  let sheet = BeachSheet.read "beaches.tab" in
  let sheet2 = BeachSheet.add_row sheet ("Race Point", "Provincetown", 1, false) in
  let fname = "beaches2.tab" in
  let () = BeachSheet.write sheet2 ~filename:fname in
  let () = Format.printf "Wrote new spreadsheet to '%s'\n" fname in
  ()
