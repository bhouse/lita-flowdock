require "spec_helper"

describe Lita::Adapters::Flowdock, lita: true do
  subject { described_class.new(robot) }

  let(:robot) { Lita::Robot.new(registry) }
  let(:connector) { instance_double('Lita::Adapters::Flowdock::Connector') }
  let(:api_token) { '46d96d3c91623d4cb6235bb94ac771fb' }
  let(:organization) { 'lita-test' }
  let(:flows) { ['test-flow'] }

  before do
    registry.register_adapter(:flowdock, described_class)
    registry.config.adapters.flowdock.api_token = api_token
    registry.config.adapters.flowdock.organization = organization
    registry.config.adapters.flowdock.flows = flows

    allow(
      described_class::Connector
    ).to receive(:new).with(
      robot,
      api_token,
      organization,
      flows
    ).and_return(connector)
    allow(connector).to receive(:run)
  end

  it "registers with Lita" do
    expect(Lita.adapters[:flowdock]).to eql(described_class)
  end

  describe "#run" do
    it "starts the streaming connection" do
      expect(connector).to receive(:run)
      subject.run
    end

    it "does nothing if the streaming connection is already created" do
      expect(connector).to receive(:run).once

      subject.run
      subject.run
    end
  end

  describe "#send_messages" do
    let(:room_source) { Lita::Source.new(room: '1234abcd') }
    let(:user) { Lita::User.new('987654') }
    let(:user_source) { Lita::Source.new(user: user) }

    it "sends messages to flows" do
      expect(connector).to receive(:send_messages).with(room_source.room, ['foo'])

      subject.run

      subject.send_messages(room_source, ['foo'])
    end
  end

  describe "#shut_down" do
    before { allow(connector).to receive(:shut_down) }

    it "shuts down the streaming connection" do
      expect(connector).to receive(:shut_down)

      subject.run
      subject.shut_down
    end

    it "does nothing if the streaming connection hasn't been created yet" do
      expect(connector).not_to receive(:shut_down)

      subject.shut_down
    end
  end
end
