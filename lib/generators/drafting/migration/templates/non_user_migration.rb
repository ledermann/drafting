class NonUserDraftingMigration < Drafting::MIGRATION_BASE_CLASS
  def self.up
    add_column :drafts, :user_type, :string
    add_index :drafts, :user_type

    # add in user_type for existing drafts table
    # for migration from old version
    Draft.update_all(user_type: 'User')
  end

  def self.down
    remove_column :drafts, :user_type
  end
end
