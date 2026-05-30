import birdie
import cake/adapter/maria
import cake/adapter/mysql
import cake/insert as i
import cake/internal/write_query
import cake/param
import cake/select as s
import cake/where as w
import gleam/time/calendar
import pprint.{format as to_string}
import test_helper/maria_test_helper
import test_helper/mysql_test_helper

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Setup                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

/// Create a known test date: 2024-03-15
fn test_date() {
  calendar.Date(year: 2024, month: calendar.March, day: 15)
}

/// Helper to create a date InsertValue from a calendar.Date
///
/// FIXME: This uses cake/internal/write_query because cake/insert doesn't
/// export an `insert.date()` function yet. Will be added in Cake 4.0
fn date(value date: calendar.Date) -> i.InsertValue {
  param.date(date) |> write_query.InsertParam
}

/// Insert query that includes a DateParam
fn insert_with_date_query() {
  [[i.string("Whiskers"), i.int(5), date(test_date())] |> i.row]
  |> i.from_values(table_name: "events", columns: ["name", "priority", "date"])
  |> i.no_returning
  |> i.to_query
}

/// Select query that filters by DateParam
fn select_by_date_query() {
  s.new()
  |> s.from_table("events")
  |> s.selects([s.col("name"), s.col("date")])
  |> s.where(w.col("date") |> w.eq(w.date(test_date())))
  |> s.to_query
}

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Tests                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

pub fn insert_with_date_test() {
  insert_with_date_query()
  |> to_string
  |> birdie.snap("insert_with_date_test")
}

pub fn insert_with_date_prepared_statement_test() {
  let mdb = insert_with_date_query() |> maria.write_query_to_prepared_statement
  let myq = insert_with_date_query() |> mysql.write_query_to_prepared_statement

  #(mdb, myq)
  |> to_string
  |> birdie.snap("insert_with_date_prepared_statement_test")
}

pub fn insert_with_date_execution_result_test() {
  let mdb =
    insert_with_date_query()
    |> maria_test_helper.setup_and_run_write_with_events
  let myq =
    insert_with_date_query()
    |> mysql_test_helper.setup_and_run_write_with_events

  #(mdb, myq)
  |> to_string
  |> birdie.snap("insert_with_date_execution_result_test")
}

pub fn select_by_date_test() {
  select_by_date_query()
  |> to_string
  |> birdie.snap("select_by_date_test")
}

pub fn select_by_date_prepared_statement_test() {
  let mdb = select_by_date_query() |> maria.read_query_to_prepared_statement
  let myq = select_by_date_query() |> mysql.read_query_to_prepared_statement

  #(mdb, myq)
  |> to_string
  |> birdie.snap("select_by_date_prepared_statement_test")
}

pub fn select_by_date_execution_result_test() {
  let mdb =
    select_by_date_query() |> maria_test_helper.setup_and_run_with_events
  let myq =
    select_by_date_query() |> mysql_test_helper.setup_and_run_with_events

  #(mdb, myq)
  |> to_string
  |> birdie.snap("select_by_date_execution_result_test")
}
