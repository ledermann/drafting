require 'active_record'

require "drafting/version"
require "drafting/base_class_methods"
require "drafting/class_methods"
require "drafting/instance_methods"
require "drafting/draft"

ActiveRecord::Base.extend Drafting::BaseClassMethods
