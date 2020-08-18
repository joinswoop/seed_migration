require 'rails'

module SeedMigration

  DEFAULT_TABLE_NAME = 'seed_migration_data_migrations'

  # Default environments list set, defaults to []
  mattr_accessor :environments_defaults
  # set the current enviroment rails value, defaults to Rails.env
  mattr_accessor :environments_rails_value
  # set if the environments method should explicitly be called in the seeds, defaults to false
  mattr_accessor :environments_required
  # set the seed version from where the environments check should start, defaults to nil (which will check it from the first seed file)
  mattr_accessor :environments_version_bootstrap
  mattr_accessor :extend_native_migration_task
  mattr_accessor :migration_table_name
  mattr_accessor :ignore_ids
  mattr_accessor :update_seeds_file
  mattr_accessor :migrations_path
  mattr_accessor :use_strict_create
  mattr_accessor :use_activerecord_bulk_insert

  self.environments_defaults = []
  self.environments_rails_value = Rails.env
  self.environments_required = false
  self.environments_version_bootstrap = nil
  self.migration_table_name = DEFAULT_TABLE_NAME
  self.extend_native_migration_task = false
  self.ignore_ids = false
  self.update_seeds_file = true
  self.migrations_path = 'data'
  self.use_strict_create = false
  self.use_activerecord_bulk_insert = false

  def self.config
    yield self
    after_config
  end

  def self.after_config
    if self.extend_native_migration_task
      require_relative '../extra_tasks.rb'
    end
  end

  def self.use_strict_create?
    use_strict_create
  end

  def self.use_activerecord_bulk_insert?
    use_activerecord_bulk_insert
  end

  def self.environments_required?
    environments_required
  end

  class Engine < ::Rails::Engine
    isolate_namespace SeedMigration

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
