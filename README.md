# Adapter between `cake` and `shork`

[![Package <a href="https://github.com/inoas/gleam-cake-pgo/releases"><img src="https://img.shields.io/github/release/inoas/gleam-cake-shork" alt="GitHub release"></a> Version](https://img.shields.io/hexpm/v/cake_shork)](https://hex.pm/packages/cake_shork)
[![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)](https://www.erlang.org/)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/cake_shork/)
[![Discord](https://img.shields.io/discord/768594524158427167?label=discord%20chat&amp;color=5865F2)](https://discord.gg/Fm8Pwmy)

<!--
[![CI Test](https://github.com/inoas/gleam-cake-shork/actions/workflows/test.yml/badge.svg?branch=main&amp;event=push)](https://github.com/inoas/gleam-cake-shork/actions/workflows/test.yml)
-->

🎂[Cake](http://hex.pm/packages/cake) 🦭MariaDB and 🐬MySQL adapters which pass `PreparedStatement`s to the [shork](http://hex.pm/packages/shork) library for execution written in [Gleam](https://gleam.run/).

## Installation

```sh
gleam add cake_shork@1
```

## Examples

### MariaDB Example

Notice: Official cake adapters re-use the cake namespace, thus you can import them like
such: `import cake/adapter/mariadb`.

```gleam
import cake/adapter/mariadb
import cake/delete as d
import cake/insert as i
import cake/select as s
import cake/where as w
import gleam/dynamic/decode
import gleam/option.{None}

const mariadb_database_name = "my_mariadb_database_name"

pub fn main() {
  mariadb.with_connection(
    host: "localhost",
    port: 3306,
    username: Some("root"),
    password: None,
    database: mariadb_database_name,
    fn(db_connection) {
      db_connection |> create_table_if_not_exists_birds
      db_connection |> insert_into_table_birds
      db_connection |> select_from_table_birds
      db_connection |> delete_from_table_birds
    }
  )
}

fn create_table_if_not_exists_birds(db_connection) {
  "CREATE TABLE IF NOT EXISTS birds (
    species TEXT,
    average_weight FLOAT(8),
    is_extinct BOOLEAN
  );"
  |> mariadb.execute_raw_sql(db_connection)
  |> io.debug
}

fn insert_into_table_birds(db_connection) {
  [
    [i.string("Dodo"), i.float(14.05), i.bool(True)] |> i.row,
    [i.string("Great auk"), i.float(5.0), i.bool(True)] |> i.row,
  ]
  |> i.from_values(
      table_name: "birds",
      columns: [
        "species", "average_weight", "is_extinct",
      ]
  )
  |> i.to_query
  |> mariadb.run_write_query(decode.dynamic, db_connection)
  |> io.debug
}

fn select_from_table_birds(db_connection) {
  s.new()
  |> s.from_table("table")
  |> s.selects([s.col("species")])
  |> s.to_query
  |> mariadb.run_read_query(decode.dynamic, db_connection)
  |> io.debug
}

fn delete_from_table_birds(db_connection) {
  d.new()
  |> d.table("birds")
  |> d.where(w.col("species") |> w.eq(w.string("Dodo")))
  |> d.to_query
  |> mariadb.run_write_query(decode.dynamic, db_connection)
  |> io.debug
}
```


### MySQL Example

Notice: Official cake adapters re-use the cake namespace, thus you can import them like
such: `import cake/adapter/mysql`.

```gleam
import cake/adapter/mysql
import cake/delete as d
import cake/insert as i
import cake/select as s
import cake/where as w
import gleam/dynamic/decode
import gleam/option.{None}

const mysql_database_name = "my_mysql_database_name"

pub fn main() {
  mysql.with_connection(
    host: "localhost",
    port: 3306,
    username: Some("root"),
    password: None,
    database: mysql_database_name,
    fn(db_connection) {
      db_connection |> create_table_if_not_exists_birds
      db_connection |> insert_into_table_birds
      db_connection |> select_from_table_birds
      db_connection |> delete_from_table_birds
    }
  )
}

fn create_table_if_not_exists_birds(db_connection) {
  "CREATE TABLE IF NOT EXISTS birds (
    species TEXT,
    average_weight FLOAT(8),
    is_extinct BOOLEAN
  );"
  |> mysql.execute_raw_sql(db_connection)
  |> io.debug
}

fn insert_into_table_birds(db_connection) {
  [
    [i.string("Dodo"), i.float(14.05), i.bool(True)] |> i.row,
    [i.string("Great auk"), i.float(5.0), i.bool(True)] |> i.row,
  ]
  |> i.from_values(
      table_name: "birds",
      columns: [
        "species", "average_weight", "is_extinct",
      ]
  )
  |> i.to_query
  |> mysql.run_write_query(decode.dynamic, db_connection)
  |> io.debug
}

fn select_from_table_birds(db_connection) {
  s.new()
  |> s.from_table("table")
  |> s.selects([s.col("species")])
  |> s.to_query
  |> mysql.run_read_query(decode.dynamic, db_connection)
  |> io.debug
}

fn delete_from_table_birds(db_connection) {
  d.new()
  |> d.table("birds")
  |> d.where(w.col("species") |> w.eq(w.string("Dodo")))
  |> d.to_query
  |> mysql.run_write_query(decode.dynamic, db_connection)
  |> io.debug
}
```


## History

This is based on <https://github.com/inoas/gleam-cake-gleam_pgo>
and This is based on <https://github.com/inoas/gleam-cake-gmysql>.
