# Shown below are the defaults for configuration
ReactOnRails.configure do |config|
  # Client bundles are configured in application.js

  # Directory where your generated assets go
  config.generated_assets_dir = File.join(%w(app assets webpack))

  # Define the files for we need to check for webpack compilation when running tests

  config.webpack_generated_files = %w( client-bundle.js server-bundle.js )

  # Server rendering:
  # Server bundle is a single file for all server rendering of components.
  # Set the server_bundle_js_file to "" if you know that you will not be server rendering.

  config.server_bundle_js_file = 'server-bundle.js'

  # increase if you're on JRuby
  config.server_renderer_pool_size = 1
  # seconds
  config.server_renderer_timeout = 20
  # If set to true, this forces Rails to reload the server bundle if it is modified
  config.development_mode = Rails.env.development?
  # For server rendering. This can be set to false so that server side messages are discarded.
  # Default is true. Be cautious about turning this off.
  config.replay_console = true
  # Default is true. Logs server rendering messags to Rails.logger.info
  config.logging_on_server = true

  # The following options can be overriden by passing to the helper method:

  # Default is false
  config.prerender = false
  # Default is true for development, off otherwise
  config.trace = Rails.env.development?
  # Default is false, enable if your content security policy doesn't include `style-src: 'unsafe-inline'`
  config.skip_display_none = false
end
