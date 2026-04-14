# dev-tools

## review

`review` prints a review prompt for the current branch or a GitLab merge
request. With `--copilot`, it passes that prompt to GitHub Copilot CLI. It can
also use another branch or MR as the base for stacked reviews, include
unresolved GitLab Duo comments, and instruct Copilot to comment back on the
merge request.

Install on macOS:

```sh
curl -fsSL https://raw.githubusercontent.com/aminnew10/dev-tools/main/install-review.sh | bash
```

This installs `review` into `~/bin`, creates the directory if needed, and
adds `~/bin` to your shell startup file.

After installation:

```sh
review --help
```

GitLab-backed features need `curl`, `jq`, and either `GITLAB_TOKEN` or
`GITLAB_ACCESS_TOKEN`.

### Options

| Option | What it does |
| --- | --- |
| `<branch-name-or-merge-request-url>` | Reviews a specific remote branch or GitLab merge request by fetching it, switching to that branch safely, and ensuring the checked-out branch matches the remote exactly. |
| `--copilot` | Passes the generated prompt to GitHub Copilot CLI. Without this flag, `review` prints the prompt. |
| `--base <ref>` | Uses another branch, commit hash, or GitLab merge request URL as the review base. |
| `--duo` | Includes only unresolved GitLab Duo comments for the target merge request in the prompt. |
| `--resolve` | With `--duo`, asks Copilot to reply to and resolve Duo comments that are not worth acting on. |
| `--comment` | Asks Copilot to post substantive review findings back to the target merge request as comments. |
| `-h`, `--help` | Shows the built-in command help. |

### Usage examples

Print a review prompt for the current branch against `main`:

```sh
review
```

Pass the generated prompt to GitHub Copilot CLI:

```sh
review --copilot
```

Review the current branch against another branch for a stacked merge request:

```sh
review --base feature/parent
```

Fetch a remote branch, switch to it, and print the review prompt against `main`:

```sh
review feature/child
```

Fetch a merge request branch, switch to its exact source branch state, and print the review prompt:

```sh
review https://gitlab.com/group/project/-/merge_requests/123
```

Generate a prompt with unresolved GitLab Duo comments and instructions for Copilot to comment substantive findings back on the current branch's open merge request:

```sh
review --duo --comment
```

If `review` needs to switch branches for a branch or merge request review, keep
your tracked working tree clean first so the switch can happen safely. Existing
local branches are only reused when they already match the fetched remote
branch or can be fast-forwarded to it.

## License

Originally built as internal tooling, this repository is available under the
MIT License. See [LICENSE](LICENSE).
