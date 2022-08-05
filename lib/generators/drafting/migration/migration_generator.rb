require 'rails/generators'
require 'rails/generators/migration'

module Drafting
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc 'Generates migration for Drafting'
    source_root File.expand_path('../templates', __FILE__)

    def self.loop_through_migration_files(reverse: false)
      files = Dir.glob("#{MigrationGenerator.source_root}/*.rb")

      files = files.reverse if reverse

      files.each_with_index do |abs_path, index|
        original_filename = File.basename(abs_path)
        filename = original_filename.split('-').last

        yield original_filename, filename, index
      end
    end

    def validation
      Drafting::MigrationGenerator.loop_through_migration_files do |original_filename|
        # these numbers will keep the migration files generated in order
        # for backwards compatibility, do NOT change the order of existing migration file templates🙏
        raise 'Migration files should start with a number followed by a dash to dictate the order of migration files to be generated' if original_filename !~ /^[\d]+\-.*drafting_migration\.rb/
      end
    end

    #########
    # USAGE #
    #########

    # Instance methods in this Generator will run in sequence (starting from `validation` above👆)
    # The methods generated dynamically below will create the migration file in order
    # This order is dictated by the number prefix in the name of the migration template files
    # naming format should follow: `<number>-custom_name_drafting_migration.rb`

    loop_through_migration_files do |original_filename, filename, index|
      define_method "create_migration_file#{index}" do
        migration_template original_filename, "db/migrate/#{filename}"
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
