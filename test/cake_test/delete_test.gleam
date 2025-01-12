import birdie
import cake/adapter/postgres
import cake/delete as d
import cake/join as j
import cake/where as w
import pprint.{format as to_string}
import test_helper/postgres_test_helper

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Setup                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

fn delete() {
  d.new()
  |> d.table("owners")
  |> d.where(w.col("owners.name") |> w.eq(w.string("Alice")))
}

fn delete_postgres() {
  delete()
  |> d.using_table("cats")
  |> d.where(w.col("cats.owner_id") |> w.eq(w.col("owners.id")))
  |> d.join(j.inner(
    with: j.table("dogs"),
    on: w.col("dogs.name") |> w.eq(w.col("cats.name")),
    alias: "dogs",
  ))
  |> d.returning(["owners.id"])
}

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  Tests                                                                    │
// └───────────────────────────────────────────────────────────────────────────┘

pub fn delete_test() {
  let pgo = delete_postgres() |> d.to_query

  pgo
  |> to_string
  |> birdie.snap("delete_test")
}

pub fn delete_prepared_statement_test() {
  let pgo =
    delete_postgres()
    |> d.to_query
    |> postgres.write_query_to_prepared_statement

  pgo
  |> to_string
  |> birdie.snap("delete_prepared_statement_test")
}

pub fn delete_execution_result_test() {
  let pgo =
    delete_postgres()
    |> d.to_query
    |> postgres_test_helper.setup_and_run_write

  pgo
  |> to_string
  |> birdie.snap("delete_execution_result_test")
}
