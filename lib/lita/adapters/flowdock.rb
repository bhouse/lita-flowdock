require "lita/adapters/flowdock/stream"

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace "flowdock"

      config :api_token, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: [Symbol, Array], required: true

      attr_reader :stream

      def initialize(robot)
        super

        @stream = Stream.new(
          robot,
          config.api_token,
          config.organization,
          config.flows
        )
      end

      def mention_format(name)
        "@#{name}"
      end

      def run
        stream.run
      rescue Interrupt
        shut_down
      end

      def shut_down
        stream.source.close
      rescue RuntimeError
        robot.trigger(:disconnected)
        log.info("Disconnected")
      end

      def send_messages(target, messages)
      end
    end

    Lita.register_adapter(:flowdock, Flowdock)
  end
end
