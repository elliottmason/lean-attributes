# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
### Added
- Adds comprehensive YARD documentation
- Adds .defined_attributes method to return an array of a class's attribute names
- Adds #attributes method to return attribute values as a hash

### Fixed
- Fixes a bug where Time attributes would be improperly parsed to January 1st

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

[unreleased]: https://github.com/lleolin/lean-attributes/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/lleolin/lean-attributes/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/lleolin/lean-attributes/compare/v0.0.1...v0.0.2
