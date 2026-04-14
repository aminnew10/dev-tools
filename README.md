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

### Usage examples

| Command | What it does |
| --- | --- |
| `review` | Opens Copilot with a review prompt for the current branch against `main`. |
| `review --prompt` | Prints the review prompt instead of opening Copilot. |
| `review --base feature/parent --prompt` | Reviews the current branch against another branch, which is useful for stacked merge requests. |
| `review --base a4ec3108e901238960f16bba68b9569dacd9fabb --prompt` | Reviews the current branch against a specific commit. |
| `review --base https://gitlab.com/group/project/-/merge_requests/122 --prompt` | Uses the source branch of another merge request as the review base. |
| `review https://gitlab.com/group/project/-/merge_requests/123` | Fetches the merge request branch, switches to the exact branch state for that MR, and starts a review. |
| `review https://gitlab.com/group/project/-/merge_requests/123 --duo` | Reviews a specific merge request and includes only unresolved GitLab Duo comments in the prompt. |
| `review https://gitlab.com/group/project/-/merge_requests/123 --duo --resolve` | Adds instructions for replying to and resolving Duo comments that are incorrect, irrelevant, or too nitpicky. |
| `review https://gitlab.com/group/project/-/merge_requests/123 --comment` | Adds instructions for posting substantive inline review comments back to the merge request. |
| `review https://gitlab.com/group/project/-/merge_requests/123 --duo --comment` | Combines unresolved Duo context with instructions for commenting review findings on the merge request. |

If `review` needs to switch branches for a merge request review, keep your
tracked working tree clean first so the switch can happen safely.
