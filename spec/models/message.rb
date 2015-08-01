class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  has_drafts :parent => :topic
end
