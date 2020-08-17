[![Gem Version](https://badge.fury.io/rb/rggen-duh.svg)](https://badge.fury.io/rb/rggen-duh)
[![CI](https://github.com/rggen/rggen-duh/workflows/CI/badge.svg)](https://github.com/rggen/rggen-duh/actions?query=workflow%3ACI)
[![Maintainability](https://api.codeclimate.com/v1/badges/7a4090f4a7c21d29036c/maintainability)](https://codeclimate.com/github/rggen/rggen-duh/maintainability)
[![codecov](https://codecov.io/gh/rggen/rggen-duh/branch/master/graph/badge.svg)](https://codecov.io/gh/rggen/rggen-duh)
[![Gitter](https://badges.gitter.im/rggen/rggen.svg)](https://gitter.im/rggen/rggen?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)


# RgGen::DUH

RgGen::DUH adds ability to load register map documents written in [DUH](https://github.com/sifive/duh) format.

## Installation

To install RgGen::DUH and required libraries, use the following command:

```
$ gem install rggen-duh
```

## Usage

You need to tell RgGen to load RgGen::DUH. There are two ways to do this:

### `--plugin` runtime option

```
$ rggen --plugin rggen-duh your_duh.json5
```

### `RGGEN_PLUGINS` environment variable

```
$ export RGGEN_PLUGINS=${RGGEN_PLUGINS}:rggen-duh
$ rggen your_duh.json5
```

## Contact

Feedbacks, bug reports, questions and etc. are wellcome! You can post them by using following ways:

* [GitHub Issue Tracker](https://github.com/rggen/rggen-duh/issues)
* [Chat Room](https://gitter.im/rggen/rggen)
* [Mailing List](https://groups.google.com/d/forum/rggen)
* [Mail](mailto:rggen@googlegroups.com)

## Copyright & License

Copyright &copy; 2020 Taichi Ishitani. RgGen::DUH is licensed under the [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](LICENSE) for futher details.

## Notice

RgGen::DUH includes the product generated from [duh-schema](https://github.com/sifive/duh-schema).
See [lib/rggen/duh/duh-schema/README.md](lib/rggen/duh/duh-schema/README.md) for futher details.

## Code of Conduct

Everyone interacting in the Rggen::Duh project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rggen/rggen-duh/blob/master/CODE_OF_CONDUCT.md).
