module Drafting
  module ClassMethods
    def from_draft(data)
      draft = data.is_a?(Draft) ? data : Draft.find(data)
      target = self.new(draft.data)
      target.send("#{draft_parent}=", draft.parent) if draft_parent
      target.draft_id = draft.id
      target
    end

    def drafts(user)
      Draft.where(:user => user, :target_type => name)
    end
  end
end
