require 'spec_helper'

describe Lita::FlowdockSource do
  let(:room){ "Main" }
  let(:room_id) { "123123123" }

  subject{ Lita::FlowdockSource.new(room: room) }

  it "looks up rooms" do
    expect(Lita.redis).to receive(:get).with("flows/#{room}").and_return(room_id)
    subject
  end
end
