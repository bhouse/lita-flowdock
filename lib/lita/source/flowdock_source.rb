module Lita
  class FlowdockSource < Source
    attr_reader :message_id

    def initialize(user: nil, room: nil, private_message: false, message_id: nil)
      room = Lita.redis.get("flows/#{room}") unless room.nil?
      super(user: user, room: room, private_message: private_message)
      @message_id = message_id
    end
  end
end
