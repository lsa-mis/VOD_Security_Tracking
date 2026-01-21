# Workaround for Rails 8.1 frozen eager_load_paths issue with turbo-rails
# This initializer runs very early (00 prefix ensures it loads first) and ensures
# eager_load_paths can be modified before engines initialize
#
# Monkey-patch to prevent eager_load_paths from being frozen
# Patch the Configuration class to always return an unfrozen array

# Ensure Rails is loaded (initializers run after config/application.rb)
if defined?(Rails::Application::Configuration)
  Rails::Application::Configuration.class_eval do
    # Store original method if not already aliased
    unless method_defined?(:original_eager_load_paths)
      alias_method :original_eager_load_paths, :eager_load_paths
    end
    
    def eager_load_paths
      paths = original_eager_load_paths
      # If frozen, return an unfrozen copy and replace the original
      if paths.frozen?
        unfrozen = paths.dup
        instance_variable_set(:@eager_load_paths, unfrozen)
        unfrozen
      else
        paths
      end
    end
    
    def eager_load_paths=(paths)
      # Ensure we never store a frozen array
      instance_variable_set(:@eager_load_paths, paths.frozen? ? paths.dup : paths)
    end
  end
end
