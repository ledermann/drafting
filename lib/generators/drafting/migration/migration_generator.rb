require 'rails/generators'
require 'rails/generators/migration'

module Drafting
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for Drafting'
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/drafting_migration.rb'
      migration_template 'non_user_migration.rb', 'db/migrate/non_user_drafting_migration.rb'
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        # ensure timestamp of the multiple migration files generated
        # will be different
        timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        timestamp += 1 if current_migration_number(dirname) == timestamp

        timestamp
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
