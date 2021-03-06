# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `noscript` message if JavaScript is disabled

### Changed
- Remove phantomjs dependency and postinstall hook to rebuild node-sass
- Use COS ember-base image and multi-stage build
  - Notify DevOps prior to merging into master to update Jenkins
- Update README
- Format travis config
- Remove footer styling in favor of adding it to ember-osf
- Update to latest ember-osf (TODO: change this to ember-osf release version before release)
- Use model.queryHasMany in place of model.query

## [0.6.11] - 2017-12-04
### Changed
- Update to @centerforopenscience/ember-osf@0.12.4

## [0.6.10] - 2017-11-29
### Changed
- Update to @centerforopenscience/ember-osf@0.12.3

## [0.6.9] - 2017-11-29
### Changed
- Update to @centerforopenscience/ember-osf@0.12.2

## [0.6.8] - 2017-11-21
### Removed
- Instance of double banner

### Changed
- Update to @centerforopenscience/ember-osf@0.12.1

## [0.6.7] - 2017-10-26
### Changed
- Update to @centerforopenscience/ember-osf@0.11.4

## [0.6.6] - 2017-10-19
### Changed
- Update to @centerforopenscience/ember-osf@0.11.2

## [0.6.5] - 2017-10-11
### Added
- Dockerfile-alpine for small production builds
- Testem flag to Chrome for no sandbox
- Test with headless Firefox

### Changed
- Get the sentryDSN from the ember config
- Update to @centerforopenscience/osf-style@1.5.1
- Point Bower to new Bower registry (https://registry.bower.io)
- Update to @centerforopenscience/ember-osf@0.11.0
