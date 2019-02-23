# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

### Changed

- In addition to existing attribute-specific coercion methods (e.g. `coerce_title`) there are now additional type-specific coercion methods e.g. `coerce_string_attribute`. These methods can be overridden to more directly coerce all attributes of the same type.
- Using a Symbol as an attribute's default value no longer attempts to call an instance method based on the Symbol name; all Symbol defaults resolve to Symbols (prior to any coercion)
- Using a Proc as an attribute's default always uses the value resultant from `call`ing the Proc. Attributes of the type Proc should probably use nested Procs if the default value is to be an actual Proc.
- Adds benchmarks for dry-types, which is honestly pretty fast

## [0.3.1] - 2016-05-17

### Fixed

- Fixes a bug where values for custom types would be unnecessarily coerced irrespective of whether they were already of the expected type or not

## [0.3.0] - 2016-03-07

### Added

- Adds benchmarks for ActiveAttr
- Adds benchmarks for ActiveRecord::Attributes
- Adds basic support for boolean attributes

## [0.2.0] - 2015-09-18

### Added

- Adds content to README.md
- Adds comprehensive YARD documentation
- Adds #attributes method to return attribute values as a hash

### Changed

- Renames generated coercion methods from `coerce_<attribute>_to_<type>` to `coerce_<attribute>`
- `Lean::Attribute::CoercionHelpers` is no longer an included module but a utility for precompiling coercion methods

### Fixed

- Fixes a bug where Time attributes would be improperly parsed to January 1st
- Fixes a bug where coercion methods were not being called as documented

## [0.1.0] - 2015-09-09

### Changed

- Makes calls to `coerce_<attribute>_to_<type>` unconditional when setting an attribute
- Lean::Attributes::Coercion is now Lean::Attributes::CoercionHelpers

## [0.0.2] - 2015-09-09 [YANKED]

### Fixed

- Fixes error when setting Symbol attributes

## [0.0.1] - 2015-09-08

### Added

- Initial release

[unreleased]: https://github.com/elliottmason/lean-attributes/compare/v0.3.1...HEAD
[0.3.1]: https://github.com/elliottmason/lean-attributes/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/elliottmason/lean-attributes/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/elliottmason/lean-attributes/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/elliottmason/lean-attributes/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/elliottmason/lean-attributes/compare/v0.0.1...v0.0.2
