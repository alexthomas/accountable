module Accountable
  class Engine < Rails::Engine
    #isolate_namespace Accountable
      config.autoload_paths += Dir[self.root.join('app', 'models', '{**}/{**}')]
      
      initializer "accountable.load_app_instance_data" do |app|
        Accountable.setup do |config|
          config.app_root = app.root
          #Rails.logger.debug "rails root in gem #{Rails.root}"
          #Rails.logger.debug "app root in gem #{Dir[self.root.join('app', 'models', '{**}/{**}')]}"
          
        end
      end

      initializer "accountable.load_static_assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
      
  end
end
