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

## Supported Bit Field Types

Following table describes which RgGen bit field types are supported by DUH format and corresponeded DUH properties.

| RgGen bit field type | Support? | access         | modifiedWriteValue | readAction    | reserved |
|:---------------------|:---------|:---------------|:-------------------|:--------------|:---------|
| rw                   | yes      | read-write     | not specified      | not specified | no       |
| ro                   | yes      | read-only      | don't care         | not specified | no       |
| rof                  | no       |                |                    |               | no       |
| wo                   | yes      | write-only     | not specified      | don't care    | no       |
| wrc                  | yes      | read-write     | not specified      | clear         | no       |
| wrs                  | yes      | read-write     | not specified      | set           | no       |
| rc                   | yes      | read-only      | don't care         | clear         | no       |
| w0c                  | yes      | read-write     | zeroToClear        | not specified | no       |
| w1c                  | yes      | read-write     | oneToClear         | not specified | no       |
| wc                   | yes      | read-write     | clear              | not specified | no       |
| woc                  | yes      | write-only     | clear              | don't care    | no       |
| rs                   | yes      | read-only      | don't care         | set           | no       |
| w0s                  | yes      | read-write     | zeroToSet          | not specified | no       |
| w1s                  | yes      | read-write     | oneToSet           | not specified | no       |
| ws                   | yes      | read-write     | set                | not specified | no       |
| wos                  | yes      | write-only     | set                | don't care    | no       |
| rwc                  | no       |                |                    |               |          |
| rwe                  | no       |                |                    |               |          |
| rwl                  | no       |                |                    |               |          |
| rws                  | no       |                |                    |               |          |
| w0crs                | yes      | read-write     | zeroToClear        | set           | no       |
| w1crs                | yes      | read-write     | oneToClear         | set           | no       |
| wcrs                 | yes      | read-write     | clear              | set           | no       |
| w0src                | yes      | read-write     | zeroToSet          | clear         | no       |
| w1src                | yes      | read-write     | oneToSet           | clear         | no       |
| wsrc                 | yes      | read-write     | set                | clear         | no       |
| w0trg                | no       |                |                    |               |          |
| w1trg                | no       |                |                    |               |          |
| w1                   | yes      | read-writeOnce | not specified      | not specified | no       |
| wo1                  | yes      | writeOnce      | not specified      | don't care    | no       |
| reserved             | yes      | don't care     | don't care         | don't care    | yes      |

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

Everyone interacting in the RgGen::Duh project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rggen/rggen-duh/blob/master/CODE_OF_CONDUCT.md).
