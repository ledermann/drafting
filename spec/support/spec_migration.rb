class SpecMigration < Drafting::MIGRATION_BASE_CLASS
  def self.up
    create_table :users, force: true do |t|
      t.string :name, null: false
    end

    create_table :admin_users, force: true do |t|
      t.string :name, null: false
    end

    create_table :authors, force: true do |t|
      t.string :name, null: false
    end

    create_table :topics, force: true do |t|
      t.string :title, null: false
      t.timestamps null: false
    end

    create_table :messages, force: true do |t|
      t.references :topic, null: false, index: true
      t.references :user, null: false, index: true
      t.text :content, null: false
      t.timestamps null: false
    end

    create_table :pages, force: true do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps null: false
    end

    create_table :posts, force: true do |t|
      t.references :author, null: false
    end

    create_table :tags, force: true do |t|
      t.string :name, null: false
      t.references :taggable, polymorphic: true, null: false, index: true
    end
  end

  def self.down
    drop_table :tags
    drop_table :posts
    drop_table :pages
    drop_table :messages
    drop_table :topics
    drop_table :authors
    drop_table :users
    drop_table :admin_users
  end
end
