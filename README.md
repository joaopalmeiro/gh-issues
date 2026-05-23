# gh-issues

A CLI to back up all your GitHub issues.

## Usage

```bash
brew install joaopalmeiro/tap/gh-issues
```

```bash
GITHUB_TOKEN="op://Development/gh-issues/GITHUB_TOKEN" op run -- gh-issues
```

## Development

Install [mise](https://mise.jdx.dev/getting-started.html), [GitHub CLI](https://github.com/cli/cli#installation), [1Password](https://1password.com/downloads/), and [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (if necessary).

```bash
mise install && gleam --version
```

```bash
GITHUB_TOKEN="op://Development/gh-issues/GITHUB_TOKEN" op run -- gleam run
```

```bash
gleam format
```

```bash
gleam check --target erlang
```

### Get a GitHub token

1. Go to https://github.com/settings/personal-access-tokens
2. _Generate new token_
3. _Token name_: `gh-issues`
4. _Repository access_ > _All repositories_
5. _Add permissions_ > `Issues` (_Access:_ `Read-only`)

## Deployment

Bump the `version` in the [gleam.toml](gleam.toml) file.

Commit and push changes.

```bash
gleam build
```

```bash
gleam run -m gleescript
```

```bash
VERSION="v$(awk -F'"' '/^version/{print $2}' gleam.toml)"; GITHUB_TOKEN="op://Development/gh-issues/RELEASE_GITHUB_TOKEN" op run -- gh release create "$VERSION" gh_issues --title "$VERSION"
```

```bash
cd scripts/ && gleam run -m gen_formula && cd ..
```

```bash
cp ~/Documents/GitHub/gh-issues.rb ~/Documents/GitHub/homebrew-tap/Formula/gh-issues.rb
```

### Get a GitHub token

1. Go to https://github.com/settings/personal-access-tokens
2. _Generate new token_
3. _Token name_: `Release gh-issues`
4. _Repository access_ > _Only select repositories_ > `joaopalmeiro/gh-issues`
5. _Add permissions_ > `Contents` (_Access:_ `Read and write`)
