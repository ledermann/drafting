require 'generator_spec'
require 'spec_helper'
require 'generators/drafting/migration/migration_generator'

module Drafting
  describe MigrationGenerator, type: :generator do
    root_dir = File.expand_path("../../../../../../tmp", __FILE__)
    destination root_dir

    [
      {
        configuration: 'timestamped migrations',
        timestamped_migrations: true
      },
      {
        configuration: 'numeric prefix migrations',
        timestamped_migrations: false
      }
    ].each do |test_suite|
      describe test_suite[:configuration] do
        before :each do
          ActiveRecord::Base.timestamped_migrations = test_suite[:timestamped_migrations]
        end

        describe 'new app' do
          before :each do
            prepare_destination
            run_generator
          end

          it "creates two installation db migration" do
            migration_files =
              Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort

            assert_equal migration_files.count, 2

            assert_file migration_files[0],
              /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/
            assert_file migration_files[1],
              /class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS/
          end

          it "creates migration files of different timestamp" do
            migration_files =
              Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort

              migration_no1 = File.basename(migration_files[0]).split("_").first
              migration_no2 = File.basename(migration_files[1]).split("_").first

              assert_not_equal migration_no1, migration_no2
          end
        end

        describe 'existing app' do
          before :each do
            prepare_destination
            run_generator
            FileUtils.rm Dir.glob("#{root_dir}/db/migrate/*non_user_drafting_migration.rb")

            migration_files =
              Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort
            expect(migration_files.count).to eq 1
            assert_file migration_files[0],
              /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/

            run_generator
          end

          it "creates only one more db migration" do
            migration_files =
              Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort
            expect(migration_files.count).to eq 2

            assert_file migration_files[0],
              /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/
            assert_file migration_files[1],
              /class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS/
          end
        end
      end
    end
  end
end
