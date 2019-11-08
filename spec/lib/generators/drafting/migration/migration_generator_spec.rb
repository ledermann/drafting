require 'generator_spec'
require 'spec_helper'
require 'generators/drafting/migration/migration_generator'

module Drafting
  describe MigrationGenerator, type: :generator do
    root_dir = File.expand_path("../../../../../../tmp", __FILE__)
    destination root_dir

    describe 'new app' do
      before :each do
        prepare_destination
        run_generator
      end

      it "creates two installation db migration" do
        migration_files =
          Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort

        assert_file migration_files[0],
          /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/
        assert_file migration_files[1],
          /class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS/
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
