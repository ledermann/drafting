class Page < ActiveRecord::Base
  has_drafts

  validates_presence_of :title, :content
end
