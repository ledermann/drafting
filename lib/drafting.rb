require 'active_record'

require "drafting/version"
require "drafting/base_class_methods"
require "drafting/class_methods"
require "drafting/instance_methods"
require "drafting/draft"

module Drafting
  def self.included base
    base.class_exec do
      extend BaseClassMethods
    end
  end
end

ActiveRecord::Base.send :include, Drafting
