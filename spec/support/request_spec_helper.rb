# Helper to avoid asset compilation errors in request specs
# The CSS errors occur because Tailwind CSS uses modern syntax that SassC doesn't understand
# JavaScript assets are built with esbuild but Sprockets can't find them in test environment
# Image assets may not be present in the asset pipeline during tests
# We'll stub the asset pipeline helpers to avoid compilation/lookup errors in request specs
RSpec.configure do |config|
  config.before(:each, type: :request) do
    # Mock the asset pipeline helpers to return empty tags
    # This prevents CSS/JS/image compilation and lookup errors in request specs
    allow_any_instance_of(ActionView::Base).to receive(:stylesheet_link_tag) do |*args|
      '<link rel="stylesheet" />'.html_safe
    end
    allow_any_instance_of(ActionView::Base).to receive(:javascript_include_tag) do |*args|
      '<script></script>'.html_safe
    end
    allow_any_instance_of(ActionView::Base).to receive(:image_tag) do |source, *args|
      options = args.last.is_a?(Hash) ? args.last : {}
      alt = options[:alt] || options['alt'] || ''
      size = options[:size] || options['size']
      size_attr = size ? " width=\"#{size.to_s.split('x')[0]}\" height=\"#{size.to_s.split('x')[1]}\"" : ''
      "<img src=\"#{source}\" alt=\"#{alt}\"#{size_attr} />".html_safe
    end
  end
end
