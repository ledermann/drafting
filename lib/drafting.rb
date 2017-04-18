require 'active_record'

require "drafting/version"
require "drafting/base_class_methods"
require "drafting/class_methods"
require "drafting/instance_methods"
require "drafting/draft"

ActiveRecord::Base.extend Drafting::BaseClassMethods

Drafting::MIGRATION_BASE_CLASS = if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration[5.0]
else
  ActiveRecord::Migration
end
