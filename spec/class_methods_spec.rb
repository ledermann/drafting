require 'spec_helper'

describe Drafting::ClassMethods do
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic) }
  let(:message) { topic.messages.build :user => user, :content => 'foo' }

  describe 'drafts' do
    before(:each) { message.save_draft(user) }

    it 'should find Draft objects' do
      expect(Message.drafts(user).count).to eq(1)
      expect(Message.drafts(user).first).to be_a(Draft)
    end
  end

  describe 'from_draft' do
    let(:draft_id) { message.save_draft(user); message.draft_id }

    it 'should build from Draft' do
      new_message = Message.from_draft(draft_id)

      expect(new_message).to be_a(Message)
      expect(new_message.new_record?).to eq(true)
      expect(new_message.draft_id).to eq(draft_id)

      expect(new_message.topic_id).to eq(topic.id)
      expect(new_message.content).to eq('foo')
    end
  end
end
