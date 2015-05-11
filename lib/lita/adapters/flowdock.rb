require 'flowdock'
require 'lita/adapters/flowdock/connector'

module Lita
  module Adapters
    class Flowdock < Adapter
      namespace 'flowdock'

      config :api_token, type: String, required: true
      config :organization, type: String, required: true
      config :flows, type: Array, required: true
      config :thread_responses, type: Symbol, required: false, default: :enabled
      config :private_messages, type: Symbol, required: false, default: :enabled
      config :active_user, type: Symbol, required: false, default: :enabled


      def mention_format(name)
        "@#{name}"
      end

      def run
        return if connector
        @connector = Connector.new(
          robot,
          config.api_token,
          config.organization,
          config.flows,
          nil,
          query_params
        )

        connector.run
      end

      def shut_down
        return unless connector
        connector.shut_down
      end

      def send_messages(target, messages)
        connector.send_messages(
          target,
          messages,
          config.thread_responses.eql?(:enabled)
        )
      end

      private
        attr_reader :connector

        def query_params
          {
            user: respond_to_private_messages?,
            active: show_user_as_active?
          }
        end

        def respond_to_private_messages?
          [:enabled, :help].include?(config.private_messages) ? 1 : 0
        end

        def show_user_as_active?
          config.active_user.eql?(:enabled) ? 'true' : 'idle'
        end
    end

    Lita.register_adapter(:flowdock, Flowdock)
  end
end
