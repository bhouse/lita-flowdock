require 'spec_helper'

describe Lita::Adapters::Flowdock::UsersCreator do
  subject { described_class }

  def stubbed_user(id)
    instance_double(
      'Lita::User', id: id, name: "Test User#{id}", mention_name: "user#{id}"
    )
  end

  describe "#create_user" do
    let(:user) do
      {
        'id'    => 1,
        'name'  => 'Test User1',
        'nick'  => 'user1'
      }
    end

    it "creates a single Lita user" do
      expect(Lita::User).to receive(:create).with(
        1,
        { 'name' => 'Test User1', 'mention_name' => 'user1' }
      ).and_return(stubbed_user(1))

      subject.create_user(user)
    end
  end

  describe "#create_users" do
    let(:users) do
      [
        {'id' => 1, 'name' => 'Test User1', 'nick' => 'user1'},
        {'id' => 2, 'name' => 'Test User2', 'nick' => 'user2'},
        {'id' => 3, 'name' => 'Test User3', 'nick' => 'user3'}
      ]
    end

    it "creates multiple Lita users" do
      (1..3).each do |id|
        expect(Lita::User).to receive(:create).with(
          id,
          { 'name' => "Test User#{id}", 'mention_name' => "user#{id}" }
        ).and_return(stubbed_user(id))
      end

      subject.create_users(users)
    end
  end
end
