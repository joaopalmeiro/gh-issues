import envoy
import gleam/http
import gleam/http/request
import gleam/int
import gleam/io
import gleam/result

type AppError {
  MissingToken
}

type Repo {
  Repo(name: String, fork: Bool)
}

fn repos_request(token: String, page: Int) -> request.Request(String) {
  request.new()
  |> request.set_scheme(http.Https)
  |> request.set_host("api.github.com")
  |> request.set_path("/user/repos")
  |> request.set_query([
    #("visibility", "all"),
    #("type", "owner"),
    #("per_page", "100"),
    #("page", int.to_string(page)),
  ])
  |> request.set_header("Accept", "application/vnd.github+json")
  |> request.set_header("Authorization", "Bearer " <> token)
  |> request.set_header("X-GitHub-Api-Version", "2026-03-10")
  |> request.set_header(
    "User-Agent",
    "gh-issues (https://github.com/joaopalmeiro/gh-issues)",
  )
}

fn fetch_repos(token: String) -> Result(List(Repo), AppError) {
  todo
}

fn run() -> Result(Nil, AppError) {
  use token <- result.try(
    envoy.get("GITHUB_TOKEN") |> result.replace_error(MissingToken),
  )

  use repos <- result.try(fetch_repos(token))
  todo
}

pub fn main() -> Nil {
  case run() {
    Ok(_) -> io.println("Done!")
    Error(MissingToken) ->
      io.println_error("GITHUB_TOKEN environment variable is not set")
  }
}
