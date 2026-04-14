#!/usr/bin/env bash
set -euo pipefail

raw_base="${REVIEW_RAW_BASE:-https://raw.githubusercontent.com/aminnew10/dev-tools/main}"
script_url="${raw_base%/}/bin/review"
install_dir="${REVIEW_INSTALL_DIR:-$HOME/bin}"
target_path="$install_dir/review"
shell_name="${REVIEW_SHELL:-$(basename "${SHELL:-zsh}")}"
path_updated="false"

fail() {
  echo "install-review: $1" >&2
  exit 1
}

detect_shell_config() {
  if [[ -n "${REVIEW_RC_FILE:-}" ]]; then
    rc_file="$REVIEW_RC_FILE"
    path_line='export PATH="$HOME/bin:$PATH"'
    reload_hint='export PATH="$HOME/bin:$PATH"'
    return
  fi

  case "$shell_name" in
    fish)
      rc_file="$HOME/.config/fish/config.fish"
      path_line='fish_add_path "$HOME/bin"'
      reload_hint='fish_add_path "$HOME/bin"'
      ;;
    *)
      rc_file="$HOME/.${shell_name}rc"
      path_line='export PATH="$HOME/bin:$PATH"'
      reload_hint='export PATH="$HOME/bin:$PATH"'
      ;;
  esac
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "this installer is intended for macOS."
fi

if ! command -v curl >/dev/null 2>&1; then
  fail "curl is required. Install it with Homebrew: brew install curl"
fi

detect_shell_config

mkdir -p "$install_dir"
mkdir -p "$(dirname "$rc_file")"

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

if ! curl -fsSL "$script_url" -o "$tmpfile"; then
  fail "failed to download $script_url"
fi

chmod 755 "$tmpfile"
mv "$tmpfile" "$target_path"

touch "$rc_file"

marker_begin="# >>> review path >>>"
marker_end="# <<< review path <<<"

if ! grep -Fqs "$marker_begin" "$rc_file" && ! grep -Fqs "$path_line" "$rc_file"; then
  {
    printf '\n%s\n' "$marker_begin"
    printf '%s\n' "$path_line"
    printf '%s\n' "$marker_end"
  } >> "$rc_file"
  path_updated="true"
fi

echo "Installed review to $target_path"
if [[ "$path_updated" = "true" ]]; then
  echo "Added $HOME/bin to PATH in $rc_file"
else
  echo "$rc_file already configures access to $HOME/bin"
fi
echo "Restart your shell or run:"
echo "  $reload_hint"
