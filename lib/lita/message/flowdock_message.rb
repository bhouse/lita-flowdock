module Lita
  class FlowdockMessage < Message

    attr_reader :data

    def initialize(robot, body, source, data)
      @data = data
      super(robot, body, source)
    end

    def tags
      @data['tags']
    end

    def thread_id
      @data['thread_id']
    end

    def new_thread?
      @data['id'] == @data['thread']['initial_message']
    end
  end
end
