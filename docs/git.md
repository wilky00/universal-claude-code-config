# Git Standards

## Commits
- Never include "Co-Authored-By: Claude" or any AI/Anthropic attribution in commit messages
- Never use `--no-verify` to bypass hooks
- Commit messages: imperative mood, present tense ("Add feature" not "Added feature")
- Keep commits focused — one logical change per commit
- Never commit secrets, credentials, or `.env` files

## Branch Naming
- Features: `feature/short-description`
- Bug fixes: `fix/short-description`
- Chores/maintenance: `chore/short-description`
- Use hyphens, all lowercase

## Pull Requests
- Title: short, imperative, under 70 characters
- Body must include:
  - **Summary**: what changed and why (2-3 bullets)
  - **Test plan**: how to verify the change works
- Keep PRs small and focused — one concern per PR
- Never force-push to `main` or `master`

## General
- Always branch from `main` unless told otherwise
- Rebase over merge for keeping history clean (when appropriate)
- Delete branches after merging
