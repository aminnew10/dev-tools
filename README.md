# dev-tools

## review

`review` generates a review prompt for the current branch or a GitLab merge
request and passes it to a local coding agent. By default it uses
[opencode](https://opencode.ai); use `--copilot` for GitHub Copilot CLI,
`--claude` for Claude Code CLI, or `--print` to print the prompt instead of
invoking an agent. All GitLab API calls made by `review` go through the
[`glab`](https://gitlab.com/gitlab-org/cli) CLI, and the agent is instructed
to use `glab` for any GitLab actions it takes. Pass `--gitlab-mcp` to instead
instruct the agent to use its installed GitLab MCP server. It can also use
another branch or MR as the base for stacked reviews and instruct the agent
to comment back on the merge request.

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

GitLab-backed features need a working
[`glab`](https://gitlab.com/gitlab-org/cli) CLI (run `glab auth login` once)
and `jq`. With `--gitlab-mcp` the agent is instructed to use its installed
GitLab MCP server instead of `glab` for posting comments; the script itself
still uses `glab` for fetching merge request metadata.

### Options

| Option | What it does |
| --- | --- |
| `<branch-name-or-merge-request-url>` | Reviews a specific remote branch or GitLab merge request by fetching it, switching to that branch safely, and ensuring the checked-out branch matches the remote exactly. |
| `--opencode` | Passes the generated prompt to opencode CLI. This is the default. |
| `--copilot` | Passes the generated prompt to GitHub Copilot CLI. |
| `--claude` | Passes the generated prompt to Claude Code CLI. |
| `--print` | Prints the generated prompt instead of invoking an agent. |
| `--base <ref>` | Uses another branch, commit hash, or GitLab merge request URL as the review base. |
| `--comment` | Asks the agent to post substantive review findings back to the target merge request as comments. |
| `--gitlab-mcp` | Instructs the agent to use its installed GitLab MCP server for posting comments. Without this flag, the agent is told to use the `glab` CLI. |
| `--model <model>` | Overrides the model used by the agent. Defaults: `gpt-5.5` for `--opencode` and `--copilot`, `sonnet` for `--claude`. With `--opencode` the value is forwarded as `github-copilot/<model>` unless it already contains `/`. |
| `--effort <level>` | Overrides the reasoning effort. Defaults: `xhigh` for `--opencode` and `--copilot`, `max` for `--claude`. With `--opencode` this is passed as `--variant`. |
| `-h`, `--help` | Shows the built-in command help. |

### Usage examples

Run a review of the current branch against `main` with the default agent (opencode):

```sh
review
```

Print the generated prompt instead of invoking an agent:

```sh
review --print
```

Pass the generated prompt to GitHub Copilot CLI:

```sh
review --copilot
```

Pass the generated prompt to Claude Code CLI:

```sh
review --claude
```

Review the current branch against another branch for a stacked merge request:

```sh
review --base feature/parent
```

Fetch a remote branch, switch to it, and run the review against `main`:

```sh
review feature/child
```

Fetch a merge request branch, switch to its exact source branch state, and run the review:

```sh
review https://gitlab.com/group/project/-/merge_requests/123
```

Generate a prompt with instructions to comment substantive findings back on the current branch's open merge request:

```sh
review --comment
```

If `review` needs to switch branches for a branch or merge request review, keep
your tracked working tree clean first so the switch can happen safely. Existing
local branches are only reused when they already match the fetched remote
branch or can be fast-forwarded to it.

## License

Originally built as internal tooling, this repository is available under the
MIT License. See [LICENSE](LICENSE).
