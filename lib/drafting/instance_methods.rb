module Drafting
  module InstanceMethods
    def save_draft(user=nil)
      return false unless self.new_record?

      draft = Draft.find_by_id(self.draft_id) || Draft.new

      draft.data = attributes_to_store_for_draft
      draft.target_type = self.class.name
      draft.user = user
      draft.parent = self.send(self.class.draft_parent) if self.class.draft_parent

      result = draft.save
      self.draft_id = draft.id if result
      result
    end

    def update_draft(user, attributes)
      with_transaction_returning_status do
        assign_attributes(attributes)
        save_draft(user)
      end
    end

  private

    def clear_draft
      if draft = Draft.find_by_id(self.draft_id)
        self.draft_id = nil if draft.destroy
      end
    end

    def attributes_to_store_for_draft
      # First, select attributes with values different from default
      new_object = self.class.new
      attrs = self.attributes.select { |k,v| v != new_object.attributes[k] }

      # Second, add extra attributes with values different from default
      self.draft_extra_attributes.each do |name|
        if (value = self.send(name)) != new_object.send(name)
          attrs[name.to_s] = value
        end
      end

      attrs
    end
  end
end
