#!/bin/sh
# Runs the tests against sidekick.nvim from lazy's install dir, or SIDEKICK_DIR
cd "$(dirname "$0")/.." && exec nvim --headless -u NONE -l tests/run.lua
