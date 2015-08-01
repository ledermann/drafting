module Drafting
  module BaseClassMethods
    ALLOWED_DRAFT_OPTION_KEYS = [ :parent, :extra_attributes ]

    def has_drafts(options={})
      raise ArgumentError unless options.is_a?(Hash)
      raise ArgumentError unless options.keys.all? { |k| ALLOWED_DRAFT_OPTION_KEYS.include?(k) }

      class_attribute :draft_parent, :draft_extra_attributes

      if options[:parent]
        parent_class = self.reflect_on_all_associations(:belongs_to).find { |a| a.name == options[:parent] }.try(:klass)
        raise ArgumentError unless parent_class

        parent_class.class_eval do
          has_many :drafts, :as => :parent, :dependent => :nullify
        end

        self.draft_parent = options[:parent]
      end

      self.draft_extra_attributes = options[:extra_attributes]  || []

      include Drafting::InstanceMethods
      extend Drafting::ClassMethods

      attr_accessor :draft_id
      after_create :clear_draft
    end
  end
end
