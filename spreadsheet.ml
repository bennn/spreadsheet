exception Invalid_spreadsheet of string

module type SpecType = sig
  type row

  val compare_row : row -> row -> int
  val row_of_string_list : string list -> row option
  val separator : string
  val string_list_of_row : row -> string list
  val title : string
end

module Make =
  functor (Spec : SpecType) -> struct

    module RowSet = Set.Make(struct
      type t = Spec.row
      let compare = Spec.compare_row
    end)

    type t = RowSet.t

    let add_row (sheet : t) ~row =
      if RowSet.mem row sheet then
        let sheet' = RowSet.remove row sheet in
        RowSet.add row sheet'
      else
        RowSet.add row sheet

    let count_rows (sheet : t) : int =
      RowSet.cardinal sheet

    let create () =
      RowSet.empty

    (* Necessary because `Str.split` needs a regexp argument *)
    let sep_regexp = Str.regexp Spec.separator

    (* Split the string using the separator, then call `row_of_string_list` *)
    let parse_row_exn str =
      begin match Spec.row_of_string_list (Str.split sep_regexp str) with
      | Some r -> r
      | None   -> let err_msg = Format.sprintf "failed to parse row '%s'" str in
                  raise (Invalid_spreadsheet err_msg)
      end

    let read_lines name : string list =
      let ic = open_in name in
      let try_read () =
        try Some (input_line ic) with End_of_file -> None in
      let rec loop acc =
        begin match try_read () with
        | Some s -> loop (s :: acc)
        | None  -> close_in ic; List.rev acc
        end
      in
      loop []

    let read ?(skip_title=true) (fname : string) : t =
      let strs  = read_lines fname in
      let lines =
        List.map
          parse_row_exn
          (if skip_title
           then List.tl strs
           else strs)
      in
      RowSet.of_list lines

    let write_lines fname lines =
      let out_chn = open_out fname in
      let () =
        List.iter
          (fun l -> output_string out_chn l; output_string out_chn "\n")
          lines
      in
      let () = close_out out_chn in
      ()

    let write ~filename (sheet : t) : unit =
      let rows =
        List.map
          (fun r -> String.concat Spec.separator (Spec.string_list_of_row r))
          (RowSet.elements sheet)
      in
      try write_lines filename (Spec.title :: rows)
      with Sys_error _ ->
        let msg = Format.sprintf "Could not write to file '%s'. Make sure the containing directory exists." filename in
        raise (Sys_error msg)

  end
