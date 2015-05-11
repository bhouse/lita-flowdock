module Lita
  class FlowdockMessage < Message
    attr_reader :tags
    def initialize(robot, body, source, tags)
      @tags = tags
      super(robot, body, source)
    end
  end
end
