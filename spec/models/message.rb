class Message < ActiveRecord::Base
  belongs_to :topic
  belongs_to :user

  has_many :tags, :as => :taggable

  attr_accessor :priority
  has_drafts :parent => :topic

  validates_presence_of :topic_id, :user_id, :content
end
