# Nightly libcore

[![Build Status](https://travis-ci.org/phil-opp/nightly-libcore.svg?branch=master)](https://travis-ci.org/phil-opp/nightly-libcore)

Rust's [core library](https://doc.rust-lang.org/core/) as a cargo crate. Updated daily using [nightli.es](https://nightli.es).

It has a `disable_float` feature that includes thepowersgang's [float-free libcore patch](https://github.com/thepowersgang/rust-barebones-kernel/blob/master/libcore_nofp.patch).

_Note_: This crate only works for targets with `"no-compiler-rt": true`.

For cross-compiling `liballoc`, `librustc_unicode`, and `libcollections`, check out [nightly-libcollections](https://github.com/phil-opp/nightly-libcollections).

## Quick Installation
To install a cross-compiled `libcore`, download the installation script:

```
wget -q https://raw.githubusercontent.com/phil-opp/nightly-libcore/master/install-libcore.sh
```
The script should work for multirust and for standard rust installations (but I only tested multirust). Use at your own risk!

To install `libcore` for target `your-target-name` with floating point support, run:

```
sh install-libcore.sh your-target-name
```
Note that `your-target-name`, `your-target-name.json`, and `./your-target-name` are different targets to Rust.

To install `libcore` without floating point support, run:
```
sh install-libcore.sh your-target-name disable_float
```

After a successful installation the script deletes itself.

## As Cargo Dependency
_Note_: This works only for crates without dependencies, as cargo still wants to use the system `libcore` for them.

It is a normal cargo crate, so you can just add the following to your `Cargo.toml`:

```toml
[dependencies.core]
git = "https://github.com/phil-opp/nightly-libcore.git"
features = ["disable_float"] # optional
```

## Manual Installation
First, clone this repository. Then copy your `your-target-name.json` file into the cloned folder and run:

```
cargo build --release --features disable_float --target=your-target-name
```
If you want to build it with float support, just omit the cargo feature.

Then put the resulting `target/your-target-name/release/libcore.rlib` in your Rust lib folder. For multirust, that folder is:

```
~/.multirust/toolchains/nightly/lib/rustlib/your-target-name/lib
```

Now it should be possible to compile `no_std` crates for `your-target-name`. Note that `./your-target-name` and `your-target-name` are different targets to Rust.

## Uninstall
To “unistall”, just remove the `libcore.rlib`. For multirust, it is in

```
~/.multirust/toolchains/nightly/lib/rustlib/your-target-name/lib
```
