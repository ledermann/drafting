module Drafting
  module BaseClassMethods
    ALLOWED_DRAFT_OPTION_KEYS = [ :parent ]

    def has_drafts(options={})
      raise ArgumentError unless options.is_a?(Hash)
      raise ArgumentError unless options.keys.all? { |k| ALLOWED_DRAFT_OPTION_KEYS.include?(k) }

      class_attribute :draft_parent

      if options[:parent]
        parent_class = self.reflect_on_all_associations(:belongs_to).find { |a| a.name == options[:parent] }.try(:klass)
        raise ArgumentError unless parent_class

        unless parent_class.method_defined? :drafts
          parent_class.class_eval do
            def drafts(user)
              Draft.where(
                user: user,
                user_type: user.try(:class).try(:name),
                parent: self
              )
            end

            def self.child_drafts(user)
              Draft.where(
                user: user,
                user_type: user.try(:class).try(:name),
                parent_type: self.base_class.name
              )
            end
          end
        end

        self.draft_parent = options[:parent]
      end

      include Drafting::InstanceMethods
      extend Drafting::ClassMethods

      attr_accessor :draft_id
      after_create :clear_draft
    end
  end
end
