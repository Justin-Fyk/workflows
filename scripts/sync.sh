#!/usr/bin/env bash
set -euo pipefail

MODE="pull"
TARGET_SKILLS_DIR="${TARGET_SKILLS_DIR:-$HOME/.gemini/config/skills}"
TARGET_RULES_FILE="${TARGET_RULES_FILE:-$HOME/.gemini/GEMINI.md}"

for arg in "$@"; do
  case "$arg" in
    --pull|-Pull) MODE="pull" ;;
    --push|-Push) MODE="push" ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_SKILLS="$REPO_ROOT/skills"
REPO_RULES="$REPO_ROOT/rules/GEMINI.md"

if [ "$MODE" = "pull" ]; then
  echo "==> Pulling latest workflows & skills from origin/main..."
  git -C "$REPO_ROOT" pull --ff-only origin main

  mkdir -p "$TARGET_SKILLS_DIR"
  cp -R "$REPO_SKILLS/"* "$TARGET_SKILLS_DIR/"
  echo "==> Synced skills to: $TARGET_SKILLS_DIR"

  mkdir -p "$(dirname "$TARGET_RULES_FILE")"
  cp "$REPO_RULES" "$TARGET_RULES_FILE"
  echo "==> Synced global rules to: $TARGET_RULES_FILE"
else
  echo "==> Copying local skills & global rules into repo checkout ($REPO_ROOT)..."
  mkdir -p "$REPO_SKILLS"
  cp -R "$TARGET_SKILLS_DIR/"* "$REPO_SKILLS/"

  if [ -f "$TARGET_RULES_FILE" ]; then
    cp "$TARGET_RULES_FILE" "$REPO_RULES"
  fi

  git -C "$REPO_ROOT" status -s
  echo "==> Local changes copied into $REPO_ROOT. Review 'git status' above, then commit and push."
fi
