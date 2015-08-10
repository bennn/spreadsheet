open Spreadsheet

module PetSpec = struct
  type row = int * (string list)

  let compare_row (id1,_) (id2,_) = Pervasives.compare id1 id2

  let row_of_string str =
    begin match Str.split (Str.regexp "\t") str with
    | [id; names] ->
      begin try Some (int_of_string id, Str.split (Str.regexp ",") names) with
      | Failure _ -> None
      end
    | _ -> None
    end

  let string_of_row (id, names) =
    string_of_int id ^ "\t" ^ (String.concat "," names)

  let title = "ID\tNAMES"
end

module PetSheet = Spreadsheet.Make(PetSpec)

let _ =
  let sheet = PetSheet.read "pet_names.tab" in
  let sheet2 = PetSheet.add_row sheet (5, ["pickles"; "mittens"; "gooby"]) in
  let filename = "pet_names2.tab" in
  let () = PetSheet.write sheet2 ~filename in
  let () = Format.printf "Wrote new spreadsheet to '%s'\n" filename in
  ()
