class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  attr_accessor :priority
  has_drafts :parent => :topic, :extra_attributes => [ :priority ]

  validates_presence_of :topic_id, :user_id, :content
end
