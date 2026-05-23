# gh-issues

A CLI to back up all your GitHub issues.

## Development

Install [mise](https://mise.jdx.dev/getting-started.html), [1Password](https://1password.com/downloads/), and [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (if necessary).

```bash
mise install && gleam --version
```

```bash
GITHUB_TOKEN="op://Development/gh-issues/GITHUB_TOKEN" op run -- gleam run
```

```bash
gleam format
```

### Get a GitHub token

1. Go to https://github.com/settings/personal-access-tokens
2. _Generate new token_
3. _Token name_: `gh-issues`
4. _Repository access_ > _All repositories_
5. _Add permissions_ > _Issues_ (and _Metadata_)
