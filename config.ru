dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(subclasses: %w'Roda Sequel::Model', logger: logger, reload: dev){App}
require_relative 'models'
Unreloader.require('app.rb'){'App'}
run(dev ? Unreloader : App.freeze.app)

freeze_core = false
#freeze_core = !dev # Uncomment to enable refrigerator
if freeze_core
  begin
    require 'refrigerator'
  rescue LoadError
  else
    require 'tilt/sass' unless File.exist?(File.expand_path('../compiled_assets.json', __FILE__))

    require 'yaml' 
    Gem.ruby

    Refrigerator.freeze_core
  end
end
