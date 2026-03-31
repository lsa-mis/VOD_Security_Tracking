# frozen_string_literal: true

# https://docs.sentry.io/platforms/ruby/guides/rails/
dsn = Rails.application.credentials.dig(:sentry, :dsn)

if dsn.present?
  Sentry.init do |config|
    config.dsn = dsn

    # Only send from deployed environments (override with SENTRY_ENVIRONMENT for preview/staging names)
    config.environment = ENV["SENTRY_ENVIRONMENT"].presence || Rails.env
    config.enabled_environments = %w[production staging]

    # Tie errors and performance to a release (set SENTRY_RELEASE in deploy, or add a REVISION file)
    config.release = begin
      ENV["SENTRY_RELEASE"].presence ||
        ENV["GIT_REV"].presence ||
        ENV["GIT_COMMIT"].presence ||
        (Rails.root.join("REVISION").read.strip if Rails.root.join("REVISION").file?)
    rescue StandardError
      nil
    end

    # Errors-only mode: keep breadcrumbs, but disable tracing + profiling.
    config.breadcrumbs_logger = %i[active_support_logger]
    config.traces_sample_rate = 0.0
    config.profiles_sample_rate = 0.0

    # Privacy: do not send IP/cookies by default; user id is set in ApplicationController when signed in
    config.send_default_pii = false

    # Richer stack traces (lines above/below each frame)
    config.context_lines = 5

    # Skip noisy bot traffic and scanners (adjust paths to match your routes)
    config.before_send = lambda do |event, _hint|
      url = event.request&.url
      return nil if url&.match?(%r{/assets/|/favicon\.ico|/robots\.txt})

      event
    end
  end
else
  Rails.logger.info "[Sentry] DSN not configured; monitoring disabled"
end
