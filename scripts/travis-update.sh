#!/bin/sh

# Exit if anything fails
set -e

git clone https://github.com/rust-lang/rust.git

cd rust
commit_hash=$(rustc --version | cut -d"(" -f2 | cut -d" " -f1)
git checkout $commit_hash
cd ..

git clone https://github.com/phil-opp/nightly-libcore.git

cd nightly-libcore
rm -r src
cp -r ../rust/src/libcore libcore
cp -r libcore libcore_orig
# Make floats optional
patch -p0 < ../libcore_nofp.patch

rm -r libcore_orig
mv libcore src

# remove official Cargo.toml in favor of our own
rm src/Cargo.toml

# try to build it
cargo build
cargo build --features="disable_float" --target=float_free_target

git config user.name "travis-update-bot"
git config user.email "travis-update-bot@phil-opp.com"
git config --global push.default simple

git add --all src
git commit -m "Update to $commit_hash" || true

if [ $TRAVIS_BRANCH = 'master' ]; then
  eval SSH_KEY_TRAVIS_ID=a2e63a976778
  eval key=\$encrypted_${SSH_KEY_TRAVIS_ID}_key
  eval iv=\$encrypted_${SSH_KEY_TRAVIS_ID}_iv

  mkdir -p ~/.ssh
  openssl aes-256-cbc -K $key -iv $iv -in scripts/travis-nightly-libcore.enc -out ~/.ssh/id_rsa -d
  chmod 600 ~/.ssh/id_rsa

  git remote add upstream git@github.com:phil-opp/nightly-libcore.git
  git push upstream
fi

cd ../
rm -rf rust
rm -rf nightly-libcore
rm libcore_nofp.patch
