#!/bin/bash

set -e  # Exit on any error, no half-measures in the unwoke revolution

if [ $# -ne 1 ]; then
    echo "Usage: $0 <repo-url>  # Because 'main' is so last year's oppression" >&2
    exit 1
fi

REPO_URL="$1"
REPO_URL="${REPO_URL%.git}"  # Trim .git if present, we're classy like that

# Convert https URL to SSH format if needed
if [[ "$REPO_URL" == https://github.com/* ]]; then
    OWNER_REPO="${REPO_URL#https://github.com/}"
    REPO_URL="git@github.com:${OWNER_REPO}.git"
else
    # Extract owner/repo from SSH URL
    OWNER_REPO="${REPO_URL#git@github.com:}"
    OWNER_REPO="${OWNER_REPO%.git}"
fi

# Check default branch (requires gh auth for API, works for public repos)
DEFAULT_BRANCH=$(gh api "repos/$OWNER_REPO" --jq .default_branch)

if [ "$DEFAULT_BRANCH" != "main" ]; then  # API returns quoted string, like it's whispering secrets
    echo "Phew, 'master' already reigns supreme. No need to liberate this repo from the main squeeze." >&2
    exit 0
fi

echo "Alert: Woke branch detected! Commencing Operation Unwoke'ify: Reclaiming 'master' glory..."

# Clone to temp dir – because we don't want to mess up your precious history
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT  # Cleanup, unlike some naming fads

gh repo clone "$REPO_URL" "$TEMP_DIR"
cd "$TEMP_DIR"

# The rename: From sensitive "main" to bold "master"
git checkout main
git branch -m main master
git push origin master  # Push the new overlord

# Crown the king
gh repo edit --default-branch master

git push origin --delete main  # Exile the pretender

echo "Victory! Repo restored to pre-woke perfection. 'master' is back, baby. No trigger warnings needed."
