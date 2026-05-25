import envoy
import gleam/dynamic/decode
import gleam/erlang/process
import gleam/http
import gleam/http/request
import gleam/httpc
import gleam/int
import gleam/io
import gleam/json
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

type AppError {
  DecodeError(json.DecodeError)
  HttpError(httpc.HttpError)
  MissingToken
  Timeout
  WriteError(simplifile.FileError)
}

type Repo {
  Repo(full_name: String, fork: Bool)
}

type PullRequest {
  PullRequest(
    url: option.Option(String),
    html_url: option.Option(String),
    diff_url: option.Option(String),
    patch_url: option.Option(String),
    merged_at: option.Option(String),
  )
}

type Issue {
  Issue(number: Int, title: String, body: option.Option(String))
}

type RepoIssues {
  RepoIssues(repo: String, issues: List(Issue))
}

fn parse_link_rel(
  headers: List(#(String, String)),
  rel: String,
) -> option.Option(Int) {
  headers
  |> list.find_map(fn(h) {
    let #(name, value) = h

    case name == "link" {
      False -> Error(Nil)
      True ->
        value
        |> string.split(", ")
        |> list.find_map(fn(part) {
          let rel_param = "rel=\"" <> rel <> "\""

          case string.split_once(part, "; ") {
            Ok(#(url, r)) if r == rel_param ->
              url
              |> string.drop_start(1)
              |> string.drop_end(1)
              |> string.split("page=")
              |> list.last
              |> result.try(int.parse)
            _ -> Error(Nil)
          }
        })
    }
  })
  |> option.from_result
}

fn repos_request(token: String, page: Int) -> request.Request(String) {
  request.new()
  |> request.set_scheme(http.Https)
  |> request.set_host("api.github.com")
  |> request.set_path("/user/repos")
  |> request.set_query([
    #("visibility", "all"),
    #("affiliation", "owner"),
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

fn issues_request(
  token: String,
  full_name: String,
  page: Int,
) -> request.Request(String) {
  request.new()
  |> request.set_scheme(http.Https)
  |> request.set_host("api.github.com")
  |> request.set_path("/repos/" <> full_name <> "/issues")
  |> request.set_query([
    #("state", "open"),
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

fn repo_decoder() -> decode.Decoder(Repo) {
  use full_name <- decode.field("full_name", decode.string)
  use fork <- decode.field("fork", decode.bool)
  decode.success(Repo(full_name: full_name, fork: fork))
}

fn pull_request_decoder() -> decode.Decoder(PullRequest) {
  use url <- decode.field("url", decode.optional(decode.string))
  use html_url <- decode.field("html_url", decode.optional(decode.string))
  use diff_url <- decode.field("diff_url", decode.optional(decode.string))
  use patch_url <- decode.field("patch_url", decode.optional(decode.string))
  use merged_at <- decode.field("merged_at", decode.optional(decode.string))
  decode.success(PullRequest(
    url: url,
    html_url: html_url,
    diff_url: diff_url,
    patch_url: patch_url,
    merged_at: merged_at,
  ))
}

fn issue_decoder() -> decode.Decoder(#(Issue, option.Option(PullRequest))) {
  use number <- decode.field("number", decode.int)
  use title <- decode.field("title", decode.string)
  use body <- decode.field("body", decode.optional(decode.string))
  use pull_request <- decode.optional_field(
    "pull_request",
    option.None,
    decode.map(pull_request_decoder(), option.Some),
  )
  decode.success(#(
    Issue(number: number, title: title, body: body),
    pull_request,
  ))
}

fn fetch_repos_page(token: String, page: Int) -> Result(List(Repo), AppError) {
  use resp <- result.try(
    repos_request(token, page)
    |> httpc.send
    |> result.map_error(HttpError),
  )

  use data <- result.try(
    json.parse(resp.body, decode.list(repo_decoder()))
    |> result.map_error(DecodeError),
  )

  Ok(list.filter(data, fn(r) { !r.fork }))
}

fn fetch_repos(token: String) -> Result(List(Repo), AppError) {
  use resp <- result.try(
    repos_request(token, 1)
    |> httpc.send
    |> result.map_error(HttpError),
  )

  use data <- result.try(
    json.parse(resp.body, decode.list(repo_decoder()))
    |> result.map_error(DecodeError),
  )

  let first_page = list.filter(data, fn(r) { !r.fork })

  case parse_link_rel(resp.headers, "last") {
    option.None -> Ok(first_page)
    option.Some(last) -> {
      let parent = process.new_subject()
      let pages = int.range(from: 2, to: last + 1, with: [], run: list.prepend)

      list.each(pages, fn(p) {
        process.spawn_unlinked(fn() {
          process.send(parent, fetch_repos_page(token, p))
        })
      })

      use remaining <- result.try(
        list.try_fold(over: pages, from: [], with: fn(acc, _) {
          case process.receive(from: parent, within: 30_000) {
            Ok(Ok(repos)) -> Ok(list.append(acc, repos))
            Ok(Error(e)) -> Error(e)
            Error(Nil) -> Error(Timeout)
          }
        }),
      )

      Ok(list.append(first_page, remaining))
    }
  }
}

fn fetch_issues(
  token: String,
  full_name: String,
) -> Result(List(Issue), AppError) {
  fetch_issues_page(token, full_name, 1, [])
}

fn fetch_issues_page(
  token: String,
  full_name: String,
  page: Int,
  acc: List(Issue),
) -> Result(List(Issue), AppError) {
  use resp <- result.try(
    issues_request(token, full_name, page)
    |> httpc.send
    |> result.map_error(HttpError),
  )

  use data <- result.try(
    json.parse(resp.body, decode.list(issue_decoder()))
    |> result.map_error(DecodeError),
  )

  let page_issues =
    list.filter_map(data, fn(pair) {
      let #(issue, pull_request) = pair
      case pull_request {
        option.None -> Ok(issue)
        option.Some(_) -> Error(Nil)
      }
    })

  let all = list.append(acc, page_issues)

  case parse_link_rel(resp.headers, "next") {
    option.None -> Ok(all)
    option.Some(next) -> fetch_issues_page(token, full_name, next, all)
  }
}

fn fetch_all_issues(
  token: String,
  repos: List(Repo),
) -> Result(List(RepoIssues), AppError) {
  repos
  |> list.sized_chunk(100)
  |> list.try_fold(from: [], with: fn(acc, batch) {
    let parent = process.new_subject()

    list.each(batch, fn(repo) {
      process.spawn_unlinked(fn() {
        process.send(parent, #(repo, fetch_issues(token, repo.full_name)))
      })
    })

    list.try_fold(over: batch, from: acc, with: fn(batch_acc, _) {
      case process.receive(from: parent, within: 30_000) {
        Ok(#(repo, Ok(issues))) ->
          Ok(
            list.append(batch_acc, [
              RepoIssues(repo: repo.full_name, issues: issues),
            ]),
          )
        Ok(#(_, Error(e))) -> Error(e)
        Error(Nil) -> Error(Timeout)
      }
    })
  })
}

fn encode_issue(issue: Issue) -> json.Json {
  json.object([
    #("number", json.int(issue.number)),
    #("title", json.string(issue.title)),
    #("body", case issue.body {
      option.Some(s) -> json.string(s)
      option.None -> json.null()
    }),
  ])
}

fn encode_backup(repo_issues: List(RepoIssues)) -> String {
  json.array(repo_issues, fn(ri) {
    json.object([
      #("repository", json.string(ri.repo)),
      #("issues", json.array(ri.issues, encode_issue)),
    ])
  })
  |> json.to_string
}

fn run() -> Result(Nil, AppError) {
  use token <- result.try(
    envoy.get("GITHUB_TOKEN") |> result.replace_error(MissingToken),
  )

  use repos <- result.try(fetch_repos(token))

  use repos_issues <- result.try(fetch_all_issues(token, repos))

  let num_repos = list.length(repos)
  let num_issues =
    list.fold(repos_issues, 0, fn(acc, ri) { acc + list.length(ri.issues) })
  io.println("Repos: " <> int.to_string(num_repos))
  io.println("Issues: " <> int.to_string(num_issues))

  simplifile.write(to: "gh-issues.json", contents: encode_backup(repos_issues))
  |> result.map_error(WriteError)
}

pub fn main() -> Nil {
  case run() {
    Ok(_) -> io.println("Done!")
    Error(MissingToken) ->
      io.println_error("GITHUB_TOKEN environment variable is not set")
    Error(HttpError(e)) -> io.println_error(string.inspect(e))
    Error(DecodeError(e)) -> io.println_error(string.inspect(e))
    Error(WriteError(e)) -> io.println_error(string.inspect(e))
    Error(Timeout) -> io.println_error("Data fetching timed out")
  }
}
