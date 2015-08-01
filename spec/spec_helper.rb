$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'drafting'
require 'generators/drafting/migration/templates/migration.rb'

require 'factory_girl'
FactoryGirl.find_definitions

require 'database_cleaner'

# Requires some ActiveRecord models
require 'models/user'
require 'models/topic'
require 'models/message'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:suite) do
    DraftingMigration.down
    SpecMigration.down
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

def setup_db
  ActiveRecord::Base.configurations = YAML.load_file(File.expand_path('database.yml', File.dirname(__FILE__)))

  ActiveRecord::Base.establish_connection(:sqlite)
  ActiveRecord::Migration.verbose = false

  ActiveRecord::Base.connection.tables.each do |table|
    next if table == 'schema_migrations'
    ActiveRecord::Base.connection.execute("DROP TABLE #{table}")
  end

  DraftingMigration.up
  SpecMigration.up
end

setup_db
