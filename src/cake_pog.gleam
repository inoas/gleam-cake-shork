import gleam/io

/// As a library *cake_pog* cannot be invoked directly in a meaningful way.
///
@internal
pub fn main() {
  { "\n" <> "cake_pog is an adapter library and cannot be invoked directly." }
  |> io.println
}
