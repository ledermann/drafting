class MetadataDraftingMigration < Drafting::MIGRATION_BASE_CLASS
  def self.up
    add_column :drafts, :metadata, :text
  end

  def self.down
    remove_column :drafts, :metadata
  end
end
