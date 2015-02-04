require 'flowdock'
require "lita/adapters/flowdock/connector"

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace "flowdock"

      config :api_token, type: String, required: true
      config :bot_name, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: [Symbol, Array], required: true

      attr_reader :connector, :flowdock_client, :bot_name

      def initialize(robot)
        super

        @bot_name = config.bot_name
        @flowdock_client = ::Flowdock::Client.new(api_token: config.api_token)
        robot_id = begin
                     @flowdock_client.get('/users').select do |user|
                       user['name'].downcase == bot_name.downcase
                     end.first['id'].to_i
                   end
        log.debug("Bot id: #{robot_id}")
        @connector = Connector.new(
          robot,
          config.api_token,
          config.organization,
          config.flows,
          flowdock_client,
          robot_id
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
