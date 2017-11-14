class Draft < ActiveRecord::Base
  belongs_to :user
  belongs_to :parent, polymorphic: true

  validates_presence_of :data, :target_type

  def restore
    target_type.constantize.from_draft(self)
  end

  class << self
    def restore_all
      find_each.map(&:restore)
    end
  end
end
