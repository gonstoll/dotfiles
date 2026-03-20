---
name: branch
description: Create a git branch, and possibly a JIRA ticket and a Github PR
---

## Prerequisites

- Require GitHub CLI `gh`. Check `gh --version`. If missing, ask the user to install `gh` and stop.
- Require authenticated `gh` session. Run `gh auth status`. If not authenticated, ask the user to run `gh auth login` (and re-run `gh auth status`) before continuing.
- Check if `jira` CLI is available: `jira version`. If missing, skip Jira steps but warn the user.

## Workflow

### Step 1: Analyze Changes

- Run `git status` and `git diff` to understand what changed.
- Summarize the changes briefly.

### Step 2: Jira Integration

In this step, your job is to figure out wether there's an already existent JIRA ticket for the work done in this branch, or if you need to create one.

- Ask the user if the work done belongs to an existent JIRA ticket

#### JIRA ticket exists

- You need to figure out what is its id.
- Do this with `jira cli`: `jira issue list` and then the user selects the ticket
- Capture the JIRA ticket ID, usually in the form of `PEAKONxxxx-xxxx`

#### JIRA ticket does not exist

- You need to create a jira task
- Use `write-jira` skill ([found here](../write-jira/SKILL.md))
- Capture the JIRA ticket ID, usually in the form of `PEAKONxxxx-xxxx`

### Step 3: Branch

- If on main/master/default: create branch `gonza/{ticket-KEY}-{description}`.
- If already on a feature branch, and branch doesn't follow the `gonza/{ticket-KEY}-{description}` format, rename it to that with: `git branch --move {old-name} gonza/{ticket-KEY}-{description}`
- Keep `{description}` short. Not more than 5 words
- Use kebab-case for description.
- Run: `git checkout -b {branch-name}`
- Run `jira issue view {ticket-KEY} --raw`
  - If assignee is not "Gonzalo Stoll", run: `jira issue assign {ticket-KEY} "Gonzalo Stoll"`
  - If status is not "In Progress", run: `jira issue move {ticket-KEY} "Start Progress"`

### Step 4: Create PR

- Check with the user if they want to also create a pr. If they do, follow the next steps. Otherwise, jump to the next step.
- Write the PR description to a temp file (e.g. `pr-body.md`) with real newlines to avoid `\n`-escaped markdown.
- Follow [pr-template](./pr-template.md)
- PR title: `{ticket-KEY}: {Descriptive title}`
- Create the PR:
  ```
  GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 gh pr create --head $(git branch --show-current) --title "{title}" --body-file pr-body.md
  ```
- Remove the temp file: `rm -rf pr-body.md`

### Step 5: Report

Report to the user:

- Jira subtask URL: `https://jira2.workday.com/browse/{ticket-KEY}`
- PR URL (from `gh pr create` output)
- Branch name

### Step 6: Code review

Review the code on the PR. Use the `code-review` skill for that.

## Error Handling

- If branch already exists, suggest an alternative name.
- If Jira CLI fails, show the error and suggest `jira auth login`. Continue with PR creation without Jira.
- If uncommitted changes exist on another branch, alert the user before proceeding.
