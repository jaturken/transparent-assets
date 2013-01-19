module TransparentAssets
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Creates , and configs'

      def self.source_root
        # @_sugarcrm_source_root ||= File.expand_path("../templates", __FILE__)
        p "self.source_root"
      end
      # def create_config_file
      #   template 'sugarcrm.yml', File.join('config', 'sugarcrm.yml')
      # end

      # def create_initializer_file
      #   template 'initializer.rb', File.join('config', 'initializers', 'sugarcrm.rb')
      # end
    end
  end
end
