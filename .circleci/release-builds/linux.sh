# Compile
cd hs
make hs-release

# Gather artifacts
REACH="$(stack exec -- which reach)"
REACHPC="$(stack exec -- which reachpc)"
REACHC="$(stack exec -- which reachc)"
strip "$REACH" "$REACHPC" "$REACHC"
mkdir -p /tmp/artifacts
mv "$REACH" "$REACHPC" "$REACHC" /tmp/artifacts
for art in /tmp/artifacts/*; do gzip "$art"; done
