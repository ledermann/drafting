require 'spec_helper'

describe Drafting::ClassMethods do
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic) }
  let(:message) { topic.messages.build :user => user, :content => 'foo' }
  let(:page) { Page.new :title => 'First post' }

  describe 'drafts' do
    it 'should find Draft objects for user' do
      message.save_draft(user)

      expect(Message.drafts(user).count).to eq(1)
      expect(Message.drafts(user).first).to be_a(Draft)
    end

    it 'should find Draft objects without user' do
      page.save_draft

      expect(Page.drafts(nil).count).to eq(1)
      expect(Page.drafts(nil).first).to be_a(Draft)
    end
  end

  describe 'from_draft' do
    context 'with parent' do
      let(:draft_id) { message.save_draft(user); message.draft_id }

      it 'should build new object' do
        new_message = Message.from_draft(draft_id)

        expect(new_message).to be_a(Message)
        expect(new_message.new_record?).to eq(true)
        expect(new_message.draft_id).to eq(draft_id)

        expect(new_message.topic_id).to eq(topic.id)
        expect(new_message.content).to eq('foo')
      end

      it 'should delete Draft after save' do
        new_message = Message.from_draft(draft_id)

        expect {
          new_message.save!
          expect(new_message.draft_id).to eq(nil)
        }.to change(Draft, :count).by(-1)

        expect(Draft.find_by_id(draft_id)).to eq(nil)
      end
    end

    context 'without parent' do
      let(:draft_id) { page.save_draft(user); page.draft_id }

      it 'should build new object' do
        new_page = Page.from_draft(draft_id)

        expect(new_page).to be_a(Page)
        expect(new_page.new_record?).to eq(true)
        expect(new_page.draft_id).to eq(draft_id)

        expect(new_page.title).to eq('First post')
      end

      it 'should delete Draft after save' do
        new_page = Page.from_draft(draft_id)
        new_page.content = 'lorem ipsum'

        expect {
          new_page.save!
          expect(new_page.draft_id).to eq(nil)
        }.to change(Draft, :count).by(-1)

        expect(Draft.find_by_id(draft_id)).to eq(nil)
      end
    end

    it "should fail for non existing draft" do
      expect {
        Page.from_draft(555)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail for other draft target" do
      message.save_draft(user)

      expect {
        Page.from_draft(message.draft_id)
      }.to raise_error(ArgumentError)
    end
  end
end
