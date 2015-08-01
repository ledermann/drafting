module Drafting
  module ClassMethods
    def from_draft(data)
      draft = data.is_a?(Draft) ? data : Draft.find(data)
      target = self.new(draft.data)
      target.send("#{draft_parent}=", draft.parent)
      target.draft_id = draft.id
      target
    end

    def drafts(user)
      Draft.where(:user_id => user.id, :target_type => self.name)
    end
  end
end
