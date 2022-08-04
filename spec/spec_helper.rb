require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start do
  add_filter '/spec/'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'drafting'

Dir["#{Drafting.root}/lib/generators/drafting/migration/templates/*.rb"].each do |filename|
  require filename
end

require 'factory_bot'
FactoryBot.find_definitions

# Require some example models
require 'models/user'
require 'models/admin_user'
require 'models/topic'
require 'models/message'
require 'models/page'
require 'models/tag'
require 'models/author'
require 'models/post'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.after(:suite) do
    SpecMigration.down
    NonUserDraftingMigration.down
    DraftingMigration.down
  end
end

def setup_db
  ActiveRecord::Base.configurations = YAML.load_file(File.expand_path('database.yml', File.dirname(__FILE__)))

  ActiveRecord::Base.establish_connection(:sqlite)
  ActiveRecord::Migration.verbose = false

  DraftingMigration.up
  NonUserDraftingMigration.up
  SpecMigration.up
end

puts "Testing with ActiveRecord #{ActiveRecord::VERSION::STRING}"
setup_db
