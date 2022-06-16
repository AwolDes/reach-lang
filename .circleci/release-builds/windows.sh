#!/usr/bin/env bash
set -e

# Install command dependencies
curl -sSL https://get.haskellstack.org/ | bash
choco install make wget

# Compile
cd hs || exit
make hs-release

# Gather artifacts
REACH="$(stack exec -- which reach)"
REACHPC="$(stack exec -- which reachpc)"
REACHC="$(stack exec -- which reachc)"
mkdir -p /c/tmp/artifacts
mv "$REACH" "$REACHC" "$REACHPC" /c/tmp/artifacts
for art in /c/tmp/artifacts/*; do 7z -sdel a "$art".gz "$art"; done
