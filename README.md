spreadsheet
===========

Functor for working with spreadsheets.
Generates spreadsheet functions from a spec for spreadsheet rows.

See the `examples/` directory for sample code.

Overview
--------

1. Create an instance of the `RowSpec` module.
  - Define a type for spreadsheet rows, give a string separator like `","`.
  - Write functions to parse a row from a list of columns, and write a row to columns.
  - Give a title---a list of strings describing each column in a row.
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


