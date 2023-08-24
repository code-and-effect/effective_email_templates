module EffectiveEmailTemplates
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectiveEmailTemplates initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        unless ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_email_templates.rb', 'config/initializers/effective_email_templates.rb'
      end

      def copy_mailer
        template ('../' * 3) + 'config/email_templates_mailer.rb', 'app/mailers/email_templates_mailer.rb'
      end

      def copy_liquid
        template ('../' * 3) + 'config/welcome.liquid', 'app/views/email_templates_mailer/welcome.liquid'
      end

      def copy_preview
        template ('../' * 3) + 'config/email_templates_mailer_preview.rb', 'test/mailers/previews/email_templates_mailer_preview.rb'
      end

      def create_migration_file
        migration_template ('../' * 3) + 'db/migrate/101_create_effective_email_templates.rb', 'db/migrate/create_effective_email_templates.rb'
      end

      def message
        puts("Please run rake db:migrate and rake effective_email_templates:import")
      end

    end
  end
end
