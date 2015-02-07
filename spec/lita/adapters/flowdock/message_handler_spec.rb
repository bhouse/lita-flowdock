require 'spec_helper'

describe Lita::Adapters::Flowdock::MessageHandler, lita: true do
  subject { described_class.new(robot, robot_id, data, fd_client) }

  let(:fd_client) { instance_double('Flowdock::Client') }
  let(:robot) {
    instance_double('Lita::Robot', name: 'Lita', mention_name: 'lita')
  }
  let(:robot_id) { '123456' }

  describe "#handle" do
    context "with a normal message" do
      let(:data) do
        {
          'content' => 'Hello World!',
          'event'   => 'message',
          'flow'    => 'testing:lita-test',
          'user'  => 11211
        }
      end
      let(:message) { instance_double('Lita::Message', command!: false) }
      let(:source) { instance_double('Lita::Source', private_message?: false) }
      let(:user) { instance_double('Lita::User', id: 11211) }

      before do
        allow(Lita::User).to receive(:find_by_id).and_return(user)
        allow(Lita::Source).to receive(:new).with(
          user: user,
          room: 'testing:lita-test'
        ).and_return(source)
        allow(Lita::Message).to receive(:new).with(
          robot, 'Hello World!', source).and_return(message)
        allow(robot).to receive(:receive).with(message)
      end

      it "dispatches the message to lita" do
        expect(robot).to receive(:receive).with(message)

        subject.handle
      end
    end
  end
end
