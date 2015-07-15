exception Invalid_spreadsheet of string

module type SpecType = sig
  type row

  val compare_row : row -> row -> int
  val row_of_string : string -> row
  val string_of_row : row -> string
  val title : string
end

module Make =
  functor (Spec : SpecType) -> struct

    module RowSet = Set.Make(struct
      type t = Spec.row
      let compare        = Spec.compare_row
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

    let read_lines name : string list =
      let ic = open_in name in
      let try_read () =
        try Some (input_line ic) with End_of_file -> None in
      let rec loop acc =
        match try_read () with
        | Some s -> loop (s :: acc)
        | None -> close_in ic; List.rev acc
      in
      loop []

    let read (fname : string) : t =
      let lines = (* skip the title *)
        List.map
          Spec.row_of_string
          (List.tl (read_lines fname))
      in
      RowSet.of_list lines

    let write_lines fname lines =
      let out_chn = open_out fname in
      let () =
        List.iter (fun l -> output_string out_chn l; output_string out_chn "\n") lines in
      let () = close_out out_chn in
      ()

    let write ~filename (sheet : t) : unit =
      let rows =
        List.map
          Spec.string_of_row
          (RowSet.elements sheet)
      in
      try write_lines filename (Spec.title :: rows)
      with Sys_error _ ->
        let msg = Format.sprintf "Could not write to file '%s'. Make sure the containing directory exists." filename in
        raise (Sys_error msg)

  end
