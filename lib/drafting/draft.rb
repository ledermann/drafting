class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, :polymorphic => true
  serialize :data

  def rebuild
    target_type.constantize.from_draft(self)
  end
end
