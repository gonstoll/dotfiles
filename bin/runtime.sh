#!/bin/sh

echo "> Installing runtime dependencies"

# NPM global packages
npm install -g depcheck eslint prettier prettier-plugin-tailwindss typescript typescript-language-server vscode-langservers-extracted
