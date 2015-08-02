require 'spec_helper'

class Author < ActiveRecord::Base
  def self.columns; [] end
end

class Post < ActiveRecord::Base
  def self.columns; [] end

  belongs_to :author
  attr_accessor :tags
end

describe Drafting::BaseClassMethods do
  describe :has_drafts do
    it "should accept no argument" do
      expect {
        Post.has_drafts
      }.to_not raise_error
    end

    it "should accept :parent key" do
      expect {
        Post.has_drafts :parent => :author
      }.to_not raise_error

      expect(Author.new).to respond_to(:drafts)
    end

    it "should fail for non-hash argument" do
      expect {
        Post.has_drafts(42)
      }.to raise_error(ArgumentError)
    end

    it "should fail for invalid hash keys" do
      expect {
        Post.has_drafts :bar => 'baz'
      }.to raise_error(ArgumentError)
    end

    it "should fail for non-existing parent" do
      expect {
        Post.has_drafts :parent => :bar
      }.to raise_error(ArgumentError)
    end
  end
end
