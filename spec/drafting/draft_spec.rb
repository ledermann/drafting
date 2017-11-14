require 'spec_helper'

describe Draft do
  let(:user) { FactoryBot.create(:user) }
  let(:topic) { FactoryBot.create(:topic) }
  let(:message1) { topic.messages.build user: user, content: 'foo1' }
  let(:message2) { topic.messages.build user: user, content: 'foo2' }

  describe '#restore' do
    before { message1.save_draft(user) }

    subject(:restored_draft) { Draft.find(message1.draft_id).restore }

    it "should build new object with attributes" do
      expect(restored_draft.attributes).to eq(message1.attributes)
    end
  end

  describe '.restore_all' do
    before do
      Draft.delete_all

      message1.save_draft(user)
      message2.save_draft(user)
    end

    subject(:restored_drafts) { Draft.restore_all }

    it "should build new objects with attributes" do
      expect(restored_drafts.map(&:attributes)).to match_array([message1.attributes, message2.attributes])
    end
  end
end
