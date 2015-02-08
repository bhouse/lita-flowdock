require 'spec_helper'

describe Lita::Adapters::Flowdock::UsersCreator do
  subject { described_class }

  describe "#create_user" do
    let(:user1) { user_hash(1) }

    it "creates a single Lita user" do
      expect(Lita::User).to receive(:create).with(
        1,
        {
          'name' => 'Test User1',
          'mention_name' => 'user1'
        }).and_return(user_double(1))

      subject.create_user(user1)
    end
  end

  describe "#create_users" do
    let(:users) { [ user_hash(1), user_hash(2), user_hash(3) ] }

    it "creates multiple Lita users" do
      (1..3).each do |id|
        expect(Lita::User).to receive(:create).with(
          id,
          {
            'name' => "Test User#{id}",
            'mention_name' => "user#{id}"
          }).and_return(user_double(id))
      end

      subject.create_users(users)
    end
  end
end
