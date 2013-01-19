module TransparentAssets
  class InstallGenerator < Rails::Generators::Base
    desc "This generator creates initializer and config files for transparent_assets gem"
    def create_initializer
      initializer_text = "# Add initialization content here"
      create_file "config/initializers/transparent_assets.rb", initializer_text
    end

    def create_config
      config_text = "# Add config content here"
      create_file "config/transparent_assets.yml", config_text
    end
  end
end
