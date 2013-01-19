module TransparentAssets
  class InstallGenerator < Rails::Generators::Base
    desc "This generator creates initializer and config files for transparent_assets gem"
    source_root File.expand_path("../templates", __FILE__)
    
    def create_initializer
      template "initializer.rb", "config/initializers/transparent_assets.rb"
    end

    def create_config
      template "config.yml", "config/transparent_assets.yml"
    end

    def add_uuid_model
      template  "uuid.rb", "app/models/uuid.rb"
    end
  end
end
