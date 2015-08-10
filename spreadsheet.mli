(**
 * spreadsheet : minimal functor for building spreadsheets
 *
 * A spreadsheet is a set of rows.
 * This functor is generic over the definition of a spreadsheet row,
 *  and provides basic functions for reading and writing spreadsheets.
 *)

exception Invalid_spreadsheet of string

(* Specification for spreadsheet rows.
 * The title may be any string, but the rows must all have the same type. *)
module type SpecType =
  sig
    type row
    (* Abstract type for spreadsheet rows *)

    val compare_row : row -> row -> int
    (* Function comparing two rows, used to define set operations. *)

    val row_of_string_list : string list -> row option
    (* Parse a row value from a list of columns.
     * Return `None` if the columns are not well-formed. *)

    val separator : string
    (* String pattern dividing columns. Most likely "," or "\t". *)

    val string_list_of_row : row -> string list
    (* Write a row value to a list of columns. *)

    val titles : string list
    (* Spreadsheet title. Elements may be arbitrary strings,
     *  but probably should not contain the `separator`.
     * Will be printed as the first line of output spreadsheets.
     * Length is used to validate output of `string_list_of_row`. *)

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
      (* A spreadsheet, aka a set of rows *)

      val add_row : t -> row:RowSet.elt -> t
      (* Aggresively add a new row to the spreadsheet,
       * replacing an old equal row if one exists. *)

      val count_rows : t -> int
      (* Return the number of non-title rows in the spreadsheet. *)

      val create : unit -> t
      (* Initialize an empty spreadsheet. *)

      val read : ?skip_title:bool -> string -> t
      (* Parse a spreadsheet from a file.
       * Raises `Invalid_spreadsheet` if any row fails to parse.
       * Optional argument `skip_title` is used to ignore the first line
       *  of the spreadsheet. *)

      val write : filename:string -> t -> unit
      (* Print a spreadsheet to a file. *)

    end
