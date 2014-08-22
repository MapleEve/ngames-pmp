# Copy this file to additional_environment.rb and add any statements
# that need to be passed to the Rails::Initializer.  `config` is
# available in this context.
#
# Example:
#
config.log_level = :debug
#   ...
#
# config/additional_environment.rb
#

config.action_controller.perform_caching = true
config.cache_store = :dalli_store, "127.0.0.1:11211", { namespace: 'test', compress: true }
config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
config.serve_static_assets = true
config.static_cache_control = "public, max-age=604800"
