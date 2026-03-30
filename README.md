# VOD Security Tracking

VOD Security Tracking is an internal Rails application used to track systems and resources involving sensitive data, document exceptions/incidents, and generate reporting for operational and security review.

## Tech Stack

- Ruby `3.4.9`
- Rails `7.2.3.1`
- MySQL (`mysql2`)
- RSpec for test coverage
- Hotwire + Stimulus
- ActiveAdmin for administrative interfaces
- esbuild + Tailwind for frontend assets

## Key Domain Areas

- DSA exceptions
- IT security incidents
- Legacy OS records
- Sensitive data systems
- Reporting and CSV exports
- Auditing/version history via `audited`

## Local Setup

### Prerequisites

- Ruby `3.4.9` (asdf recommended)
- Bundler
- MySQL (local instance)
- Node.js + Yarn

### 1) Clone and install dependencies

```sh
git clone git@github.com:lsa-mis/VOD_Security_Tracking.git
cd VOD_Security_Tracking
bundle install
yarn install
```

### 2) Configure database access

`config/database.yml` expects:

- MySQL user: `root`
- password from env var: `LOCAL_MYSQL_DATABASE_PASSWORD`

Example:

```sh
export LOCAL_MYSQL_DATABASE_PASSWORD='your-local-password'
```

### 3) Prepare the database

```sh
bin/rails db:prepare
```

### 4) Build frontend assets

```sh
yarn build
yarn build:css
```

### 5) Start the app

```sh
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000).

## Development Workflow

If you want Rails + JS + CSS watchers in one session:

```sh
bin/dev
```

`Procfile.dev` starts:

- Rails server
- `yarn build --watch`
- `yarn build:css --watch`

## Running Tests

Run the full suite:

```sh
bundle exec rspec
```

Run a single file:

```sh
bundle exec rspec spec/requests/reports_spec.rb
```

## Deployment Notes

Deployment is configured with Capistrano (`config/deploy.rb`).

- Production stage: `config/deploy/production.rb`
- Uses asdf shims for Ruby/Bundler on deploy hosts
- Runs asset build/precompile during deploy
- Restarts Puma after deploy

Coordinate with the maintainers before changing deploy settings, linked files, or credentials handling.

## Security and Credentials

- Production credentials are stored via Rails encrypted credentials.
- Never commit secrets, keys, or credential files.
- LDAP/Duo/SendGrid/Google Cloud integration settings are environment or credential driven.

## Contributing

1. Create a feature branch from `master`
2. Make focused changes
3. Run tests (`bundle exec rspec`)
4. Open a pull request with:
   - summary
   - risk/impact notes
   - test plan

## Contact

Project group: `security-track-devs@umich.edu`
