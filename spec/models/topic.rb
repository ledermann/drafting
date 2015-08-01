class Topic < ActiveRecord::Base
  has_many :messages
end
