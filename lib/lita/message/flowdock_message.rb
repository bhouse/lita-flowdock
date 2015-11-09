module Lita
  class FlowdockMessage < Message
    attr_reader :tags, :thread_id
    def initialize(robot, body, source, tags, thread_id)
      @tags = tags
      @thread_id = thread_id
      super(robot, body, source)
    end
  end
end
