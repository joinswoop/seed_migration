# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/named_base'

module SeedMigration
  module Generators
    class SeedMigrationGenerator < Rails::Generators::NamedBase
      namespace 'seed_migration'
      desc 'Creates a seed migration'
      class_option :migration_name, :type => :string, :default => nil
      class_option :seed_directory, type: :string, default: nil, desc: 'The directory where this seed file is going to be created. By --seed_directory=data, it will create it inside db/data directory. By --seed_directory=<any>, it will create it inside db/<any> custom directory.'

      argument :timestamp, :type => :string, :required => false, :default => Time.now.utc.strftime("%Y%m%d%H%M%S")

      def create_seed_migration_file
        if SeedMigration.seeds_by_custom_directories_enabled? && !options['seed_directory']
          Logger.new($stdout).error "Can't execute seed_migration. You must pass the seed_directory param, e.g. bundle exec rails generate seed_migration seed_directory=data. \
This requirement is currently enabled by SeedMigration.config.seed_by_custom_directories == true. Run 'bundle exec rails g seed_migration' for details."
        else
          path = SeedMigration::Migrator.data_migration_directory(options['seed_directory'])
          create_file path.join("#{timestamp}_#{file_name.gsub(/([A-Z])/, '_\1').downcase}.rb"), contents
        end
      end

      private

      def contents
        <<STRING
class #{file_name.camelize} < SeedMigration::Migration
  def up

  end

  def down

  end
end
STRING
      end
    end
  end
end
