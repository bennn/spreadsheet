open Spreadsheet

type address = int * string
type phone_number = Full of (int * int * int)
                  | Partial of (int * int)

let address_regexp = Str.regexp "^\\([0-9]+\\) \\(.*\\)$"

let address_of_string str =
  begin match Str.string_match address_regexp str 0 with
  | true -> int_of_string (Str.matched_group 1 str), Str.matched_group 2 str
  | false -> failwith "Failed to parse address"
  end

let string_of_address (n, s) =
  string_of_int n ^ " " ^ s

let full_phone_regexp = Str.regexp "^\\([0-9][0-9][0-9]\\)-\\([0-9][0-9][0-9]\\)-\\([0-9][0-9][0-9][0-9]\\)$"
let partial_phone_regexp = Str.regexp "^\\([0-9][0-9][0-9]\\)-\\([0-9][0-9][0-9][0-9]\\)$"

let phone_number_of_string str =
  begin match Str.string_match full_phone_regexp str 0 with
  | true ->
    let n1 = int_of_string (Str.matched_group 1 str) in
    let n2 = int_of_string (Str.matched_group 2 str) in
    let n3 = int_of_string (Str.matched_group 3 str) in
    Full(n1, n2, n3)
  | false ->
    begin match Str.string_match partial_phone_regexp str 0 with
    | true ->
      let n1 = int_of_string (Str.matched_group 1 str) in
      let n2 = int_of_string (Str.matched_group 2 str) in
      Partial(n1, n2)
    | false -> failwith "Couldn't parse phone number"
    end
  end

let string_of_phone_number = function
  | Full (n1, n2, n3) -> Format.sprintf "%d-%d-%d" n1 n2 n3
  | Partial (n1, n2)  -> Format.sprintf "%d-%d" n1 n2

module PersonSpec  = struct
  type row = string * phone_number * address

  let compare_row (n1,_,_) (n2,_,_) = Pervasives.compare n1 n2

  let row_of_string_list strs =
    begin match strs with
    | [name; number; addr] ->
      begin try Some (name, phone_number_of_string number, address_of_string addr) with
      | _ -> None
      end
    | _ -> None
    end

  let separator = ","

  let string_list_of_row (name, pn, addr) =
    [name; string_of_phone_number pn; string_of_address addr]

  let titles = ["NAME";"NUMBER";"ADDRESS"]
end

module PhoneBook = Spreadsheet.Make(PersonSpec)

let _ =
  let sheet = PhoneBook.read "phone_book.csv" in
  let filename = "phone_book2.csv" in
  let () = PhoneBook.write sheet ~filename in
  let () = Format.printf "Wrote new spreadsheet to '%s'\n" filename in
  ()
