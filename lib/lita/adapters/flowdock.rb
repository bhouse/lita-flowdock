require 'flowdock'
require 'lita/adapters/flowdock/connector'

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace 'flowdock'

      config :api_token, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: Array, required: true


      def mention_format(name)
        "@#{name}"
      end

      def run
        return if connector
        @connector = Connector.new(
          robot,
          config.api_token,
          config.organization,
          config.flows
        )

        connector.run
      end

      def shut_down
        return unless connector
        connector.shut_down
      end

      def send_messages(target, messages)
        connector.send_messages(target.room, messages)
      end

      private
        attr_reader :connector
    end

    Lita.register_adapter(:flowdock, Flowdock)
  end
end
