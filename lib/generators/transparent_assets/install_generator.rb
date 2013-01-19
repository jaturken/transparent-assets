module TransparentAssets
  class InstallGenerator < Rails::Generators::Base
    def do_test
      print ActiveRecord.class
    end
  end
end
