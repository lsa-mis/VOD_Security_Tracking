# Changelog

All notable changes to the VOD Security Tracking system baseline are documented in this file.

This changelog supports configuration management by recording the **current approved baseline** and the history of reviewed updates. Entries are derived from merged pull requests on the `master` branch and related deploy/runtime configuration under version control.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## Baseline configuration management

### Current baseline (under configuration control)

The approved software baseline for VOD Security Tracking is the tip of the `master` branch in this repository (`lsa-mis/VOD_Security_Tracking`), deployed via Capistrano. As of **2026-07-21**, the documented runtime/component baseline is:

| Component | Baseline |
| --- | --- |
| Application | VOD Security Tracking (Rails MVC) |
| Source control | GitHub `master` (PR-reviewed merges) |
| Ruby | `4.0.6` (`.ruby-version`, `Gemfile`) |
| Rails | `8.1.3` (`Gemfile.lock`) |
| Database adapter | MySQL via `mysql2` |
| Web server | Puma |
| Background jobs | Solid Queue (restarted on Capistrano deploy) |
| Frontend assets | Propshaft + esbuild + Tailwind CSS + Hotwire/Stimulus |
| Auth / MFA | Devise + LDAP; Duo second factor |
| Authorization | Pundit + LDAP group `AccessLookup` |
| Auditing | `audited` gem (model change history) |
| Error monitoring | Sentry (`sentry-ruby` / `sentry-rails`) |
| Admin UI | Custom `/admin` MVC (ActiveAdmin removed) |
| Deploy | Capistrano (`config/deploy.rb`, staging/production stages) |
| Test baseline | RSpec (`bundle exec rspec`) |

Supporting baseline artifacts under configuration control include: `Gemfile` / `Gemfile.lock`, `package.json` / yarn lockfile, `.ruby-version`, `config/deploy.rb`, `config/deploy/*.rb`, application config under `config/`, and this `CHANGELOG.md`.

### Review and update of the baseline

The baseline is reviewed and updated as follows:

1. **Organization-defined frequency**
   - Dependency baselines are reviewed on an ongoing basis through Dependabot pull requests (Bundler and npm/yarn groups) merged to `master` after review.
   - Platform/runtime baselines (Ruby, Rails, major framework upgrades) are reviewed when maintainers schedule upgrades and again at merge/deploy time.
   - This changelog is updated when the approved baseline changes in a material way (platform upgrades, major architecture swaps, security-relevant component installs).

2. **Organization-defined circumstances**
   - Security findings or vulnerability remediations (for example, dependency CVEs or ITS security scan mitigations).
   - Operational incidents requiring configuration or component changes.
   - Policy/terminology or access-control changes that affect the approved system configuration.
   - Changes to deploy topology (for example, Solid Queue restart behavior, staging/production Capistrano stages).

3. **When system components are installed or upgraded**
   - New or replaced major components (for example, Sentry, Propshaft/esbuild replacing Webpacker, custom admin replacing ActiveAdmin).
   - Ruby/Rails version upgrades and related gem/Node package updates.
   - API or integration platform migrations (for example, TDX / Apigee X).
   - Post-merge Capistrano deploys that install the updated baseline on target hosts; deploy hooks print Ruby/Rails versions for verification.

All baseline-affecting changes are introduced via pull request, reviewed, merged to `master`, and deployed through the Capistrano process so the running system matches the version-controlled baseline.

---

## [Unreleased]

- Dependency and patch updates may land via Dependabot PRs between dated baseline entries below; see merged PRs on `master`.

## [2026-07-16] — Rails 8 / Ruby 4 and ActiveAdmin replacement

Major baseline upgrade and admin architecture change (PR [#279](https://github.com/lsa-mis/VOD_Security_Tracking/pull/279) and related commits on `master`).

### Changed
- Upgraded application baseline to **Ruby 4.0.6** and **Rails 8.1.x**.
- Replaced ActiveAdmin with a custom Tailwind/Hotwire `/admin` MVC.
- Modernized admin table row actions into a shared Turbo-powered actions partial.
- Adjusted Gemfile dependencies for Rails 8 / Ruby 4 compatibility (including `ostruct` for `net-ldap`).
- Automated **Solid Queue** restart after Capistrano deploys (no sudo); deploy output confirms service restart.
- Fixed Legacy OS report crash when rendering `review_date`.

### Security / dependencies
- Merged Dependabot updates for Bundler and npm/yarn groups (including PRs [#276](https://github.com/lsa-mis/VOD_Security_Tracking/pull/276)–[#278](https://github.com/lsa-mis/VOD_Security_Tracking/pull/278) and earlier group bumps).

## [2026-03-31] — Observability and platform patch baseline

### Added
- Integrated **Sentry** error monitoring (PR [#267](https://github.com/lsa-mis/VOD_Security_Tracking/pull/267)).

### Changed
- Updated Rails to **7.2.3.1** and related Active Storage migration compatibility (PR [#265](https://github.com/lsa-mis/VOD_Security_Tracking/pull/265)).
- Updated Ruby to **3.4.9** across `Gemfile`, `.ruby-version`, and tool version files (PR [#263](https://github.com/lsa-mis/VOD_Security_Tracking/pull/263)).

## [2025-11-17] — DSA terminology and feedback component

### Changed
- Renamed user-facing **DPA Exception** terminology to **DSA Exception** across controllers, views, and related assets (PR [#253](https://github.com/lsa-mis/VOD_Security_Tracking/pull/253)).
- Introduced/updated feedback gem integration (PR [#252](https://github.com/lsa-mis/VOD_Security_Tracking/pull/252)).

## [2025-10-06] — Device updates and API keys

### Changed
- Improved device update error handling and flash messaging (PR [#249](https://github.com/lsa-mis/VOD_Security_Tracking/pull/249)).
- Updated API key configuration/messaging for integrations (PR [#247](https://github.com/lsa-mis/VOD_Security_Tracking/pull/247)).

## [2025-01-31] — Asset pipeline and CSV exports

### Changed
- Replaced Webpacker with **jsbundling / esbuild**-oriented frontend build (PR [#231](https://github.com/lsa-mis/VOD_Security_Tracking/pull/231)).
- Refactored Sensitive Data System CSV export for clearer field formatting and maintainability (PR [#232](https://github.com/lsa-mis/VOD_Security_Tracking/pull/232)).
- Applied ongoing Dependabot security and maintenance updates for Bundler and npm/yarn (including esbuild and related packages).

## [2024-04-30] — Login messaging and asset security mitigations

### Added
- Login alert / messaging improvements (PR [#208](https://github.com/lsa-mis/VOD_Security_Tracking/pull/208)).

### Fixed
- Mitigated security issues identified in an ITS scan related to JS asset posting (PR [#206](https://github.com/lsa-mis/VOD_Security_Tracking/pull/206)).

## [2024-02-20] — Ruby 3.3 and staging configuration

### Changed
- Updated Ruby version to **3.3** (PR [#197](https://github.com/lsa-mis/VOD_Security_Tracking/pull/197)).
- Added staging deploy/configuration support (PR [#199](https://github.com/lsa-mis/VOD_Security_Tracking/pull/199)).
- Webpacker-related fixes and ActiveAdmin/Ransack dependency bumps (PRs [#193](https://github.com/lsa-mis/VOD_Security_Tracking/pull/193), [#190](https://github.com/lsa-mis/VOD_Security_Tracking/pull/190), [#200](https://github.com/lsa-mis/VOD_Security_Tracking/pull/200)).

## [2023-01-10] — TDX / Apigee X integration migration

### Changed
- Migrated TDX ticket API usage to the Apigee X platform (PR [#175](https://github.com/lsa-mis/VOD_Security_Tracking/pull/175)).

## [2022-07-05] — Attachment capability expansion

### Changed
- Allowed ZIP file uploads for attachments (PR [#160](https://github.com/lsa-mis/VOD_Security_Tracking/pull/160)).

## [2021-10] — Export/device consistency and auth fixes

### Fixed
- Aligned device information across edit/show/CSV export (PR [#146](https://github.com/lsa-mis/VOD_Security_Tracking/pull/146)).
- Aligned Legacy OS export with edit/show record data (PR [#145](https://github.com/lsa-mis/VOD_Security_Tracking/pull/145)).
- Fixed login error when using “remember me” (PR [#142](https://github.com/lsa-mis/VOD_Security_Tracking/pull/142)).
- Notification display fixes (PR [#143](https://github.com/lsa-mis/VOD_Security_Tracking/pull/143)).

### Changed
- RSpec test suite cleanup (PR [#126](https://github.com/lsa-mis/VOD_Security_Tracking/pull/126)).
- Admin user help documentation (PR [#141](https://github.com/lsa-mis/VOD_Security_Tracking/pull/141)).

## [2021-07] – [2021-09] — Initial production baseline formation

Foundational baseline established through PR-reviewed merges on `master`, including (non-exhaustive):

### Added
- Core domain tracking for DSA/DPA exceptions, IT security incidents, legacy OS records, sensitive data systems, devices, departments, and related lookups.
- Reporting and CSV export capabilities (PR [#104](https://github.com/lsa-mis/VOD_Security_Tracking/pull/104) and follow-ons).
- LDAP/Pundit authorization improvements, nested-group authorization, and department-scoped access (PRs [#79](https://github.com/lsa-mis/VOD_Security_Tracking/pull/79), [#109](https://github.com/lsa-mis/VOD_Security_Tracking/pull/109), [#133](https://github.com/lsa-mis/VOD_Security_Tracking/pull/133)).
- Audit log presentation styling (PR [#89](https://github.com/lsa-mis/VOD_Security_Tracking/pull/89)).
- Maintenance mode support (PRs [#129](https://github.com/lsa-mis/VOD_Security_Tracking/pull/129), [#131](https://github.com/lsa-mis/VOD_Security_Tracking/pull/131), [#139](https://github.com/lsa-mis/VOD_Security_Tracking/pull/139)).
- Session timeout of 8 hours after login (PR [#125](https://github.com/lsa-mis/VOD_Security_Tracking/pull/125)).
- Cron/job support to auto-update devices from TDX (PR [#76](https://github.com/lsa-mis/VOD_Security_Tracking/pull/76)).
- Attachment upload with file type/size limits (PRs [#64](https://github.com/lsa-mis/VOD_Security_Tracking/pull/64), [#68](https://github.com/lsa-mis/VOD_Security_Tracking/pull/68)).

### Changed
- Rails upgrade during early production hardening (PR [#82](https://github.com/lsa-mis/VOD_Security_Tracking/pull/82)).
- Action Text fields across tables and reports (PRs [#92](https://github.com/lsa-mis/VOD_Security_Tracking/pull/92), [#123](https://github.com/lsa-mis/VOD_Security_Tracking/pull/123), [#127](https://github.com/lsa-mis/VOD_Security_Tracking/pull/127)).

## [2021-03-17] — Initial repository baseline

### Added
- Initial application commit establishing Ruby **3.0.0** / Rails **~> 6.1.3** starting baseline under Git configuration control.

---

## Dependency update practice

Routine security and maintenance dependency updates are merged via Dependabot PRs (Bundler and npm/yarn). Representative historical ranges include PRs [#170](https://github.com/lsa-mis/VOD_Security_Tracking/pull/170)–[#278](https://github.com/lsa-mis/VOD_Security_Tracking/pull/278). Individual patch bumps are not always given a separate dated section above; they remain part of the `master` baseline and are visible in GitHub PR history and lockfiles.
