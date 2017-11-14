require 'spec_helper'

describe Draft do
  let(:user) { FactoryBot.create(:user) }
  let(:topic) { FactoryBot.create(:topic) }
  let(:message) { topic.messages.build :user => user, :content => 'foo' }
  let(:message1) { topic.messages.build :user => user, :content => 'foo1' }

  describe 'restore' do
    before(:each) { message.save_draft(user) }
    let(:draft) { Draft.find(message.draft_id) }

    it "should build new object with attributes" do
      new_message = draft.restore

      expect(new_message.attributes).to eq(message.attributes)
    end
  end


  describe 'restore_all' do
    before(:each) { message.save_draft(user) }
    before(:each) { message1.save_draft(user) }
    let(:drafts) { Draft.where(id: message.draft_id) }

    it "should build new object with attributes" do
      new_messages = drafts.restore_all

      expect(new_messages.map(&:attributes)).to eq([message.attributes])
    end
  end
end
