module Accountable
  module Generators
    module OrmHelpers
      
      def model_contents
                buffer = <<-CONTENT
          # Include default devise modules. Others available are:
          # :confirmable, :lockable, :timeoutable and :omniauthable
          devise :database_authenticatable, :registerable,
                 :recoverable, :rememberable, :trackable, :validatable

        CONTENT
      end
      
      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end
      
      def migration_exists?(migration_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_#{migration_name}.rb$/).first
      end
      
      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
