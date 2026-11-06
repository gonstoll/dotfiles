#!/bin/sh
cd "$(dirname "$0")/.." && exec nvim --headless -u NONE -l tests/run.lua
