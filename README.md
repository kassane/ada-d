# ada-d

D bindings for [Ada URL parser](https://github.com/ada-url)

The Ada library passes the full range of tests from the specification, across a wide range of platforms (e.g., Windows, Linux, macOS).
It fully supports the relevant [Unicode Technical Standard](https://www.unicode.org/reports/tr46/#ToUnicode).

## Requirements

* [D](https://dlang.org/) toolchain
* C++20 toolchain (system default)
#### For Wasm32
* [wasi-sdk](https://github.com/WebAssembly/wasi-sdk/releases) v25.0 or newer

## Usage

See [here](source/ada/url/package.d) unittests for make a usage example.
You can run it locally with `dub test` or `dub :benchmark` to run benchmark (see: [here](bench/bench.d)).
Feel free to adjust it for exploring this project.

## Acknowledgements
- [Daniel Lemire](https://github.com/lemire)
- [Yagiz Nizipli](https://github.com/anonrig)