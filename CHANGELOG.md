## 1.0.0 - 2026-02-23
### Fixed
- Fixed broken badge links in README.md to ensure correct visualization on pub.dev.
### Changed
- Standardized dependency versions for `http` and `meta` using caret syntax (`^`) for better compatibility and compliance with pub.dev standards.
- Improved SEO by adding relevant topics and refining the package description in pubspec.yaml.
### Added
- Added "Maintainers" section to README.md, including GitHub profile integration.
- Official stable release.

## 0.0.6 - 2025-10-27
### Breaking change
- NetworkObservable is now solely responsible for managing local observers and notifying them of network events.
- GlobalNetworkObservable is responsible for tracking and notifying global observers across all clients, as well as maintaining shared network state by client.id.
- Renamed HttpClient to NccClient to better reflect the package name.
### Added
- GlobalNetworkObservable class is responsible for tracking and notifying global observers across all clients
### Changed
- Upgrade http: ">=1.5.0 <2.0.0"
- Upgrade meta: ">=1.16.0 <2.0.0"
- Upgrade coolint: ^2.1.2

## 0.0.5 - 2025-07-16
### Breaking change
- Manage of socket exception as NetworkAvailabilityException

## 0.0.4 - 2025-07-16
### Changed
- CI/CD for open PR
### Added
- Manage race conditions

## 0.0.3 - 2025-05-20
### Changed
- Change function for normalize headers

## 0.0.2 - 2025-05-14
### Added
- Test added
- Github action for pull_main and publish added

## 0.0.1

- Initial version.
### Added
- Ncc implementation
- SessionClient implementation