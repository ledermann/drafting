RSpec.shared_examples 'eventual output' do |root_dir|
  it 'creates 3 installation db migration files in order eventually' do
    migration_files =
      Dir.glob("#{root_dir}/db/migrate/*drafting*.rb").sort

    assert_equal migration_files.count, 3

    assert_file migration_files[0],
      /class DraftingMigration < Drafting::MIGRATION_BASE_CLASS/
    assert_file migration_files[1],
      /class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS/
    assert_file migration_files[2],
      /class MetadataDraftingMigration < Drafting::MIGRATION_BASE_CLASS/
  end
end
