class User < ActiveRecord::Base
  has_many :messages
end
