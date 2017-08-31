require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"
require "yaml"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MastermindApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.after_initialize do
      # Initialising database with service types
      for path in Dir['mastermind-services/*/']
        mastermindConf = YAML::load(File.open(path+'mastermind.yml'))
        dockerCompose = YAML::load(File.open(path+'docker-compose.yml'))
        serviceType = ServiceType.find_by(name: mastermindConf["name"])
        if serviceType.nil? then
          ServiceType.create(name: mastermindConf["name"], service_protocol_type: mastermindConf["protocol_type"], ngsi_version: mastermindConf["ngsi_version"], configuration_template: File.read(path+'mastermind.yml'), deploy_template: File.read(path+'docker-compose.yml'))
        end
      end
      # Initialising database with role levels
      adminLevel = RoleLevel.find_by(name: "admin")
      if adminLevel.nil? then
        RoleLevel.create(name: "admin")
      end
      userLevel = RoleLevel.find_by(name: "user")
      if adminLevel.nil? then
        RoleLevel.create(name: "user")
      end
    end
  end
end
