# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
### Changed
### Fixed

## [1.5.2](v1.5.2) - 2016-1-1
### Fixed
- Fixed a permissions issue when trying to send transactions introduced by [0d995a6](0d995a6) in [1.4.0](v1.4.0).

## [1.5.1](v1.5.1) - 2015-12-31
### Fixed
- Fixed a permissions issue when calculating character deaths.

## [1.5.0](v1.5.0) - 2015-12-30
### Added
- Rollbar integration

### Fixed
- Cleaned up internals for Death and CharacterEvents
- Added `revert_attendence_awards` to CharacterEvent

## [1.4.2](v1.4.2) - 2015-12-30
### Fixed
- Proper links in Changelog
- Deploys to Heroku trigger assets compiling

## [1.4.1](v1.4.1) - 2015-12-30
### Added
- Changelog

## [1.4.0](v1.4.0) - 2015-12-30
This was a HUGE rewrite with about 54 commits since the last push.
Since I don't have a testing strategy yet, it's likely some things are broken.
### Changed
- NPC Shifts have been totally reworked. They track which event they're attached
  to and automatically pay out at their closing. Granularity has been dropped to 15 minutes, so partial payments are a thing.
- Reworked navigation for admins/back office.

### Added
- Each model has an admin page now, some of them have less than useful defaults.
- Exposed version history on admin side for most models (as well as who changed them). Need to use the console for reverts.

### Fixed
- Removed some disabled links and routes to edit pages
- Cleaned the crap out of the admin edit pages. Hooray CSS.
- Nicer flash messages
- Massive speedups on pages that load several characters (and everything along with them).
- Faster experience calculations
- Prettier datetimes.

## [1.3.7](v1.3.7) - 2015-10-04
### Added
- There are some aws settings hanging out after my initial attempt. Eventually will get back to them.
- Version file :)
- Added rspec skeletons, didn't write any tests.

## [1.3.5](v1.3.5) - 2015-10-04
### Fixed
- Deaths are calculated on the fly and properly account for the current event.

## [1.3.4](v1.3.4) - 2015-10-04
### Added
- Used at the November Event.