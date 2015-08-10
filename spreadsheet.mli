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

    val row_of_string : string -> row option
    (* Parse a row value from a well-formed string. *)

    val string_of_row : row -> string
    (* Write a row value to string. *)

    val title : string
    (* Spreadsheet title. May be any string.
     * Will be printed as the first line of output spreadsheets. *)

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
