import gleam/bit_array
import gleam/crypto
import gleam/io
import gleam/result
import gleam/string
import simplifile
import tom

fn run() -> Result(Nil, String) {
  use gleam_toml <- result.try(
    simplifile.read("gleam.toml") |> result.map_error(string.inspect),
  )
  use toml <- result.try(
    tom.parse(gleam_toml) |> result.map_error(string.inspect),
  )

  use version <- result.try(
    tom.get_string(toml, ["version"]) |> result.map_error(string.inspect),
  )

  use escript_data <- result.try(
    simplifile.read_bits("gh_issues") |> result.map_error(string.inspect),
  )

  let sha = crypto.hash(crypto.Sha256, escript_data) |> bit_array.base16_encode

  let download_url =
    "https://github.com/joaopalmeiro/gh-issues/releases/download/v"
    <> version
    <> "/gh_issues"
  let formula =
    "class GhIssues < Formula\n"
    <> "  desc \"A CLI to back up all your GitHub issues.\"\n"
    <> "  homepage \"https://github.com/joaopalmeiro/gh-issues\"\n"
    <> "  version \""
    <> version
    <> "\"\n"
    <> "  license \"MIT\"\n"
    <> "\n"
    <> "  url \""
    <> download_url
    <> "\"\n"
    <> "  sha256 \""
    <> sha
    <> "\"\n"
    <> "\n"
    <> "  depends_on \"erlang\"\n"
    <> "\n"
    <> "  def install\n"
    <> "    bin.install \"gh_issues\"\n"
    <> "  end\n"
    <> "end\n"

  simplifile.write("gh-issues.rb", formula) |> result.map_error(string.inspect)
}

pub fn main() {
  case run() {
    Ok(_) -> io.println("Done!")
    Error(e) -> io.println(e)
  }
}
