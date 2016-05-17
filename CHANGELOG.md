# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

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

## Changed
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

[unreleased]: https://github.com/lleolin/lean-attributes/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/lleolin/lean-attributes/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/lleolin/lean-attributes/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/lleolin/lean-attributes/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/lleolin/lean-attributes/compare/v0.0.1...v0.0.2
