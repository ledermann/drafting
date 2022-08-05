class Draft < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  belongs_to :parent, polymorphic: true

  validates_presence_of :data, :target_type

  store :metadata, accessors: [], coder: JSON

  def restore
    target_type.constantize.from_draft(self)
  end

  def self.restore_all
    find_each.map(&:restore)
  end

  private

  def method_missing(name, *args)
    method_name = name.to_s
    if method_name !~ /[a-z0-9_]+=?$/
      super
    else
      # TODO: executing on instance's class, not on it's eigenclass, so that store_accessors are permanent in application lifecycle, good idea? 🤔
      Draft.store_accessor :metadata, method_name.gsub('=', "").to_sym
      public_send(name, *args)
    end
  end

  def respond_to_missing?(sym, include_private)
    true
  end
end
