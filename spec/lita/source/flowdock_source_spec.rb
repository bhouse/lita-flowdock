require 'spec_helper'

describe Lita::FlowdockSource do
  let(:room){ "Main" }
  let(:room_id) { "123123123" }

  subject{ Lita::FlowdockSource.new(room: room) }

  describe "with a room" do
    it "looks up rooms" do
      expect(Lita.redis).to receive(:get).with("flows/#{room}").and_return(room_id)
      subject
    end
  end

  describe "without a room" do
    subject{ Lita::FlowdockSource.new(user: "Bob") }

    it "skips the room lookup if no room is given" do
      expect(Lita.redis).not_to receive(:get).with("flows/#{room}")
      subject
    end
  end


  describe "with a message id" do
    subject{ Lita::FlowdockSource.new(room: room, message_id: 123) }

    it "saves the message id" do
      allow(Lita.redis).to receive(:get).with("flows/#{room}").and_return(room_id)
      expect(subject.message_id).to eql(123)
    end
  end
end
