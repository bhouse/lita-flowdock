require 'spec_helper'

describe Lita::Adapters::Flowdock::Connector, lita: true do
  subject { described_class }

  let(:registry) { Lita::Registry.new }
  let(:robot) { Lita::Robot.new(registry) }
  let(:api_token) { 'a8f828cfe7efc65b53b3de06761e83e9' }
  let(:organization) { 'lita-test' }
  let(:flows) { ['testing'] }
  let(:fd_client) { instance_double('Flowdock::Client') }
  let(:users) {
    [
      {'id' => 1, 'name' => 'Test User1', 'nick' => 'user1'},
      {'id' => 2, 'name' => 'Test User2', 'nick' => 'user2'}
    ]
  }

  describe "#new" do
    it "creates users" do
      expect(fd_client).to receive(:get).with('/users').and_return(users)
      expect(Lita::Adapters::Flowdock::UsersCreator).to receive(
        :create_users
      ).with(users)
      subject.new(robot, api_token, organization, flows, fd_client)
    end
  end

  describe "#run" do
  end

  describe "#send_messages" do
    let(:target) { 'testing:lita-test' }
    let(:message) { 'foo' }
    subject {
      described_class.new(robot, api_token, organization, flows, fd_client)
    }

    before do
      allow(fd_client).to receive(:get).with('/users').and_return(users)
    end

    it "sends messages" do
      expect(fd_client).to receive(:chat_message).with(flow: target, content: message)
      subject.send_messages(target, [message])
    end
  end
end
