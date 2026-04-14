# dev-tools

## review

`review` opens GitHub Copilot with a review prompt for the current branch or a
GitLab merge request. It can also use another branch or MR as the base for
stacked reviews, include unresolved GitLab Duo comments, and instruct Copilot
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

GitLab-backed features need `curl`, `jq`, and either `GITLAB_TOKEN` or
`GITLAB_ACCESS_TOKEN`.

### Options

| Option | What it does |
| --- | --- |
| `<merge-request-url>` | Reviews a specific GitLab merge request by fetching its source branch, switching to that exact branch state, and using that MR as the review target. |
| `--open` | Opens GitHub Copilot with the generated review prompt. This is the default behavior. |
| `--prompt` | Prints the generated prompt instead of opening Copilot. |
| `--base <ref>` | Uses another branch, commit hash, or GitLab merge request URL as the review base. |
| `--duo` | Includes only unresolved GitLab Duo comments for the target merge request in the prompt. |
| `--resolve` | With `--duo`, asks Copilot to reply to and resolve Duo comments that are not worth acting on. |
| `--comment` | Asks Copilot to post substantive review findings back to the target merge request as comments. |
| `-h`, `--help` | Shows the built-in command help. |

### Usage examples

Open Copilot with a review prompt for the current branch against `main`:

```sh
review
```

Review the current branch against another branch for a stacked merge request:

```sh
review --base feature/parent
```

Fetch a merge request branch, switch to its exact source branch state, and start a review:

```sh
review https://gitlab.com/group/project/-/merge_requests/123
```

Include unresolved GitLab Duo comments and ask Copilot to comment substantive findings back on the current branch's open merge request:

```sh
review --duo --comment
```

If `review` needs to switch branches for a merge request review, keep your
tracked working tree clean first so the switch can happen safely.

## License

Originally built as internal tooling, this repository is available under the
MIT License. See [LICENSE](LICENSE).
