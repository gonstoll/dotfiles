---
name: create-worktree
description: Create a git worktree for an own or someone else's branch, symlink local-only files (.env, .tmux-sessionizer), optionally install or symlink node_modules, and open it in tmux
---

Ask the user, in order:

1. **Own branch** or **someone else's branch**?
2. **Branch name.** If own: strip a leading `gonza/` if the user typed it, then prepend `gonza/`.
3. **Deps strategy:** `link` (default) or `install`?
4. **If `install`:** ask for the install command, default `npm install`.

Then run the matching one-liner from below. Substitute `<BRANCH>` and (for install) `<INSTALL_CMD>`.

After it runs, reply with one sentence: worktree path, branch, strategy.

## Own + link

```sh
B="<BRANCH>" && git fetch && src=$(git rev-parse --show-toplevel) && dir=$(realpath "$src/..")/${B//\//-} && git worktree add -b "$B" "$dir" origin/master --no-track && cd "$dir" && { [ -f "$src/.env" ] && ln -s "$src/.env" .env; [ -f "$src/.tmux-sessionizer" ] && ln -s "$src/.tmux-sessionizer" .tmux-sessionizer; fd -t d -HI --prune '^node_modules$' "$src" | while read nm; do rel=${nm#$src/}; p=$(dirname "$rel"); [ -d "$p" ] && ln -sfn "$nm" "$p/node_modules"; done; tmux-sessionizer "$dir"; }
```

## Own + install

```sh
B="<BRANCH>" && CMD="<INSTALL_CMD>" && git fetch && src=$(git rev-parse --show-toplevel) && dir=$(realpath "$src/..")/${B//\//-} && git worktree add -b "$B" "$dir" origin/master --no-track && cd "$dir" && { [ -f "$src/.env" ] && ln -s "$src/.env" .env; [ -f "$src/.tmux-sessionizer" ] && ln -s "$src/.tmux-sessionizer" .tmux-sessionizer; tmux-sessionizer "$dir" && tmux send-keys -t "$(basename "$dir" | tr . _)" "$CMD" C-m; }
```

## Other + link

```sh
B="<BRANCH>" && git fetch && src=$(git rev-parse --show-toplevel) && dir=$(realpath "$src/..")/${B//\//-} && git worktree add "$dir" -b "$B" "origin/$B" && cd "$dir" && { [ -f "$src/.env" ] && ln -s "$src/.env" .env; [ -f "$src/.tmux-sessionizer" ] && ln -s "$src/.tmux-sessionizer" .tmux-sessionizer; fd -t d -HI --prune '^node_modules$' "$src" | while read nm; do rel=${nm#$src/}; p=$(dirname "$rel"); [ -d "$p" ] && ln -sfn "$nm" "$p/node_modules"; done; tmux-sessionizer "$dir"; }
```

## Other + install

```sh
B="<BRANCH>" && CMD="<INSTALL_CMD>" && git fetch && src=$(git rev-parse --show-toplevel) && dir=$(realpath "$src/..")/${B//\//-} && git worktree add "$dir" -b "$B" "origin/$B" && cd "$dir" && { [ -f "$src/.env" ] && ln -s "$src/.env" .env; [ -f "$src/.tmux-sessionizer" ] && ln -s "$src/.tmux-sessionizer" .tmux-sessionizer; tmux-sessionizer "$dir" && tmux send-keys -t "$(basename "$dir" | tr . _)" "$CMD" C-m; }
```
