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

          include_examples 'eventual output', root_dir

          it "creates migration files of different timestamp" do
            migration_files =
              Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort

              timestamps = migration_files.map do |migration_file|
                File.basename(migration_file).split("_").first
              end

              assert_equal timestamps.size, 3
              assert_equal timestamps.uniq.size, 3
          end
        end

        describe 'existing app' do
          before :each do
            prepare_destination
            run_generator
          end

          describe 'before 0.5.x' do
            before :each do
              FileUtils.rm Dir.glob("#{root_dir}/db/migrate/*non_user_drafting_migration.rb")
              FileUtils.rm Dir.glob("#{root_dir}/db/migrate/*metadata_drafting_migration.rb")

              migration_files =
                Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort
              expect(migration_files.count).to eq 1
              assert_file migration_files[0],
                /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/

              run_generator
            end

            include_examples 'eventual output', root_dir
          end

          describe 'after 0.5.x' do
            before :each do
              FileUtils.rm Dir.glob("#{root_dir}/db/migrate/*metadata_drafting_migration.rb")

              migration_files =
                Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort
              expect(migration_files.count).to eq 2
              assert_file migration_files[0],
                /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/
              assert_file migration_files[1],
                /class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS/

              run_generator
            end

            include_examples 'eventual output', root_dir
          end
        end

        describe 'migration file not starting with "<number>-"' do
          let!(:filename) { "#{Drafting.root}/lib/generators/drafting/migration/templates/something.rb" }

          before :each do
            prepare_destination
            FileUtils.touch(filename)
          end

          after :each do
            FileUtils.rm(filename)
          end

          it 'should raise error' do
            expect { run_generator }.to raise_error('Migration files should start with a number followed by a dash to dictate the order of migration files to be generated')
          end
        end
      end
    end
  end
end
