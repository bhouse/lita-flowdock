require "lita/adapters/flowdock/connector"

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace "flowdock"

      config :api_key, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: [Symbol, Array], required: true

      attr_reader :connector

      def initialize(robot)
        super
        @connector = Connector.new(
          robot,
          config.api_key,
          config.organization,
          config.flows
        )
      end

      def mention_format(name)
        "@#{name}"
      end

      def run
        connector.connect
        robot.trigger(:connected)
        sleep
      end

      def shut_down
      end

      def send_messages(target, messages)
      end
    end

    Lita.register_adapter(:flowdock, Flowdock)
  end
end
