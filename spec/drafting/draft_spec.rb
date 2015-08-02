require 'spec_helper'

describe Draft do
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic) }
  let(:message) { topic.messages.build :user => user, :content => 'foo' }

  describe 'restore' do
    before(:each) { message.save_draft(user) }
    let(:draft) { Draft.find(message.draft_id) }

    it "should build new object with attributes" do
      new_message = draft.restore

      expect(new_message.attributes).to eq(message.attributes)
    end
  end
end
