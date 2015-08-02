class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :polymorphic => true

  serialize :data

  validates_presence_of :data, :target_type

  def rebuild
    target_type.constantize.from_draft(self)
  end
end
