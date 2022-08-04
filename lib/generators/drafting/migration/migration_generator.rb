require 'rails/generators'
require 'rails/generators/migration'

module Drafting
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for Drafting'
    source_root File.expand_path('../templates', __FILE__)

    def create_migration_file
      Dir.glob("#{MigrationGenerator.source_root}/*.rb").each do |abs_path|
        filename = File.basename(abs_path)

        raise 'Migration file named wrongly' if filename !~ /migration.rb$/

        migration_template filename, "db/migrate/#{filename.gsub('migration.rb', 'drafting_migration.rb')}"
      end
    end

    def self.next_migration_number(dirname)
      if ActiveRecord.timestamped_migrations
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
