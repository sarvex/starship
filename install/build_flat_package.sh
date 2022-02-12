#!/bin/bash

# Usage: run `cargo build --release` and then pass the directory to the starship
# root as $1 (or, if script is in the usual place in the repo, just run script)

error(){
    echo "[ERROR]: $1"
    exit 1
}

if [[ "$OSTYPE" != 'darwin'* ]]; then
    error "This script only works on MacOS"
fi

script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
repo_dir="$(dirname "$script_dir")"

starship_src_root="${1:-$repo_dir}"
starship_program_path="$starship_src_root/target/release/starship"

if [ ! -f "$starship_program_path" ]; then
    error "Could not find starship binary at $starship_program_path"
fi

pkgdir="$(mktemp -d)"
mkdir -p "$pkgdir/usr/local/{bin,share}"
cp "$starship_program_path" "$pkgdir/usr/local/bin/starship"

