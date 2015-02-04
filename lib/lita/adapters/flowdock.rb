require 'flowdock'
require "lita/adapters/flowdock/connector"

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace "flowdock"

      config :api_token, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: [Symbol, Array], required: true

      attr_reader :connector, :flowdock_client

      def initialize(robot)
        super

        @flowdock_client = ::Flowdock::Client.new(api_token: config.api_token)
        @connector = Connector.new(
          robot,
          config.api_token,
          config.organization,
          config.flows,
          flowdock_client
        )
      end

      def mention_format(name)
        "@#{name}"
      end

      def run
        connector.run
      rescue Interrupt
        shut_down
      end

      def shut_down
        connector.source.close
      rescue RuntimeError
        robot.trigger(:disconnected)
        log.info("Disconnected")
      end

      def send_messages(target, messages)
        messages.each do |message|
          flowdock_client.chat_message(flow: target.room, content: message)
        end
      end
    end

    Lita.register_adapter(:flowdock, Flowdock)
  end
end
