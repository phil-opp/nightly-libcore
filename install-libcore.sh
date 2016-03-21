#!/bin/bash
# Exit if anything fails
set -e
DIR=$( pwd )

usage="Usage: sh $0 your-target-name [disable_float]"

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
echo $usage >&2
exit 1
fi

if [[ "$1" == "-h" || "$1" == "help" || "$1" == "-help" || "$1" == "--help" ]]; then
echo $usage >&2
exit 0
fi

target="$1"

if [ "$#" -eq 2 ]; then
  if [[ "$2" == "disable_float" ]]; then
    features="--features disable_float"
  else
    echo $usage >&2
    exit 1
  fi
else
  features=""
fi

extension="${target##*.}"
if [[ extension == "json" ]]; then
  targetWithExtension="$target"
else
  targetWithExtension="$target.json"
fi

if multirust which rustc > /dev/null; then
  rustcDir=$( multirust which rustc )
elif which rustc > /dev/null; then
  rustcDir=$( which rustc )
else
  echo "Could not detect rust installation!" >&2
  exit 1
fi

libraries=$( echo "$rustcDir" | sed s,"bin/rustc","lib/rustlib/$target/lib", )

echo "Installing libcore for $target to"
echo "$libraries"
echo ""

git clone --depth 1 https://github.com/phil-opp/nightly-libcore.git
if [ -f "$targetWithExtension" ]; then
  cp "$targetWithExtension" "nightly-libcore/$targetWithExtension"
fi
cd nightly-libcore
echo ""
if cargo build --release $features --target=$target --verbose; then
  echo ""
  mkdir -p "$libraries"
  cp "target/$target/release/libcore.rlib" "$libraries/"
  cd ..
  rm -rf nightly-libcore
  echo "done, removing the installation script"
  rm "$0"
else
  echo "Cargo build failed!" >&2
  cd ..
  rm -rf nightly-libcore
  exit 1
fi
