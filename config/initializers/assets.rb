# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Add app/assets/builds to the asset load path
Rails.application.config.assets.paths << Rails.root.join('app/assets/builds')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( application.js application.css instructions.css forms.css )

# Guard against accidental ActiveAdmin build artifacts shadowing the
# canonical Sprockets assets in app/assets/stylesheets and app/assets/javascripts.
if Rails.env.development?
  %w[active_admin.css active_admin.js].each do |asset_name|
    conflicting_asset = Rails.root.join("app/assets/builds", asset_name)
    next unless conflicting_asset.exist?

    conflicting_asset.delete
    Rails.logger&.warn("[assets] Removed conflicting build artifact: #{conflicting_asset}")
  end
end
