spreadsheet
===========

Functor for working with spreadsheets.
Generates spreadsheet functions from a spec for spreadsheet rows.


Overview
--------

1. Create an instance of the `RowSpec` module.
  - Define a type for spreadsheet rows.
  - Write functions to parse a row from a string, and write a row to string.
  - Give a string title describing the rows.
2. Call `Spreadsheet.Make` with your `RowSpec`.
3. Use the newly-created module to read a spreadsheet from a file, or
   make a new one and add rows to it.


API
---

Also see `spreadsheet.mli`

- `add_row : t -> row:RowSpec.t -> t` add a row to the spreadsheet, overwriting an existing equal row
- `count_rows : t -> int` return the number of rows in the spreadsheet
- `create : unit -> t` create an empty spreadsheet
- `read : ?skip_title:bool -> string -> t` parse a spreadsheet from a file
- `write : filename:string -> t -> unit` write a spreadsheet to a file


