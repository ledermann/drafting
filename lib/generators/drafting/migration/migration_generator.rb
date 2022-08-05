require 'rails/generators'
require 'rails/generators/migration'

module Drafting
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for Drafting'
    source_root File.expand_path('../templates', __FILE__)

    def validation
      Drafting::MigrationGenerator.loop_through_migration_files do |abs_path|
        basename = File.basename(abs_path)
        filename = basename.split('-').last

        # these numbers will keep the migration files generated in order
        # for backwards compatibility, do NOT change the order of existing migration file templates🙏
        raise 'Migration files should start with a number followed by a dash' if basename !~ /^[\d]+\-.*/
      end
    end

    # TODO: make these methods metaprogramming
    def create_migration_file1
      migration_template 'drafting_migration.rb', "db/migrate/drafting_migration.rb"
    end

    def create_migration_file2
      migration_template 'non_user_drafting_migration.rb', "db/migrate/non_user_drafting_migration.rb"
    end

    def create_migration_file3
      migration_template 'metadata_drafting_migration.rb', "db/migrate/metadata_drafting_migration.rb"
    end

    def self.loop_through_migration_files
      Dir.glob("#{MigrationGenerator.source_root}/*.rb").each do |abs_path|
        yield abs_path
      end
    end

    def self.next_migration_number(dirname)
      format = '%Y%m%d%H%M%S'

      # check if migration number already a timestamp for timestamped migrations
      # strptime throws error, and rescue handles if not the case
      DateTime.strptime(current_migration_number(dirname).to_s, format)

      (DateTime.parse(current_migration_number(dirname).to_s) + 1.second).strftime(format)
    rescue ArgumentError
      if ActiveRecord::Base.timestamped_migrations
        # this will only run the first migration file is generated
        Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
end
