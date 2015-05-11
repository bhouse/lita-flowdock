require 'spec_helper'

describe Lita::FlowdockMessage, lita: true do
  let(:message_handler) do
    Lita::Adapters::Flowdock::MessageHandler.new(
      robot,
      123456,
      data,
      fd_client
    )
  end

  let(:source) { instance_double('Lita::FlowdockSource', private_message?: false, message_id: 1234) }

  let(:robot) { Lita::Robot.new(registry) }
  let(:fd_client) { instance_double('Flowdock::Client') }
  let(:test_flow) { 'testing:lita-test' }
  let(:test_user_id) { 3 }
  let(:test_fd_user) { user_hash(test_user_id) }
  let(:user) { user_double(test_user_id) }

  before do
    allow(fd_client).to receive(:get).with("/user/3").and_return(test_fd_user)
    allow(Lita::FlowdockSource).to receive(:new).with(
      user: user,
      room: test_flow,
      message_id: 1234
    ).and_return(source)
    allow(Lita::User).to receive(:find_by_id).and_return(user)
  end

  context "a message in a thread has a tag" do
    let(:tags) { ['down'] }
    let(:body) { 'the system is #down' }
    let(:data) do
      {
        'content'         => {
          'title'         => 'Thread title',
          'text'          => body
        },
        'event'           => 'comment',
        'flow'            => test_flow,
        'id'              => 2345,
        'initial_message' => 1234,
        'tags'            => tags,
        'user'            => 3
      }
    end

    it 'creates a message with tags' do
      expect(Lita::FlowdockMessage).to receive(:new).with(
        robot,
        body,
        source,
        tags
      )

      message_handler.handle
    end
  end

  context 'a regular message with a tag' do
    let(:tags) { ['world'] }
    let(:body) { 'Hello #world' }
    let(:data) do
      {
        'content'         => body,
        'event'           => 'message',
        'flow'            => test_flow,
        'id'              => 1234,
        'initial_message' => 1234,
        'tags'            => tags,
        'user'            => 3
      }
    end

    it 'creates a message with tags' do
      expect(Lita::FlowdockMessage).to receive(:new).with(
        robot,
        body,
        source,
        tags
      )

      message_handler.handle
    end
  end
end
