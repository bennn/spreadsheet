exception Invalid_spreadsheet of string
module type SpecType =
  sig
    type row
    val compare_row : row -> row -> int
    val row_of_string : string -> row
    val string_of_row : row -> string
    val title : string
  end
module Make :
  functor (Spec : SpecType) ->
    sig
      module RowSet :
        sig
          type elt = Spec.row
          type t
        end
      type t = RowSet.t
      val add_row : t -> row:RowSet.elt -> RowSet.t
      val count_rows : t -> int
      val create : unit -> RowSet.t
      val read_lines : string -> string list
      val read : string -> t
      val write_lines : string -> string list -> unit
      val write : filename:string -> t -> unit
    end
