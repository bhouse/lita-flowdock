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
      private_message: false,
      message_id: 1234
    ).and_return(source)
    allow(Lita::User).to receive(:find_by_id).and_return(user)
  end

  context "a message" do
    let(:body) { 'the system is #down' }
    let(:initial_message){ 1234 }
    let(:data) do
      {
        'content'         => {
          'title'         => 'Thread title',
          'text'          => body
        },
        'thread_id'       => 'a385473',
        'event'           => 'comment',
        'flow'            => test_flow,
        'id'              => 2345,
        'thread'          => {
          'initial_message' => initial_message
        },
        'tags'            => ['down'],
        'user'            => 3
      }
    end

    it 'creates a message with data' do
      expect(Lita::FlowdockMessage).to receive(:new).with(
        robot,
        body,
        source,
        data
      )

      message_handler.handle
    end

    context 'instance methods' do
      subject{ Lita::FlowdockMessage.new( robot, body, source, data) }
      it 'has #tags' do
        expect(subject.tags).to eq(['down'])
      end

      it 'has #thread_id' do
        expect(subject.thread_id).to eq('a385473')
      end

      context 'new_thread?' do
        context 'non new-thread' do
          it 'is false' do
            expect(subject.new_thread?).to be false
          end
        end

        context 'a new thread' do
          let(:initial_message){ 2345 }
          it 'is true' do
            expect(subject.new_thread?).to be true
          end
        end
      end
    end
  end
end
