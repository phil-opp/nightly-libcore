# Nightly libcore

[![Build Status](https://travis-ci.org/phil-opp/nightly-libcore.svg?branch=master)](https://travis-ci.org/phil-opp/nightly-libcore)

Rust's [core library](https://doc.rust-lang.org/core/) as a cargo crate. Updated daily using [nightli.es](http://nightli.es).

It has a `disable_float` feature that includes thepowersgang's [float-free libcore patch](https://github.com/thepowersgang/rust-barebones-kernel/blob/master/libcore_nofp.patch).

## Cross compiling
_Note_: This works only for targets with `"no-compiler-rt": true`.

Copy your `your-target-name.json` file into the cloned folder and run:

```
cargo build --release --features disable_float --target=your-target-name
```
If you want to build it with float support, just omit the cargo feature.

Then put the resulting `target/your-target-name/release/libcore.rlib` in your Rust lib folder. For multirust, that folder is:

```
~/.multirust/toolchains/nightly/lib/rustlib/your-target-name/lib
```

Now it should be possible to compile `no_std` crates for `your-target-name`. Note that `./your-target-name` and `your-target-name` are different targets to Rust.
