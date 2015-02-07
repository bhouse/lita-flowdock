require 'eventmachine'
require 'em-eventsource'
require 'flowdock'
require 'lita/adapters/flowdock/message_handler'
require 'lita/adapters/flowdock/users_creator'

module Lita
  module Adapters
    class Flowdock < Adapter
      class Connector

        def initialize(robot, api_token, organization, flows, flowdock_client=nil)
          @robot = robot
          @api_token = api_token
          @organization = organization
          @flows = flows
          @client =
            flowdock_client || Flowdock::Client.new(api_token: api_token)

          UsersCreator.create_users(client.get('/users'))
        end

        def run
          EM.run do
            @source = EventMachine::EventSource.new(
              "https://#{api_token}@stream.flowdock.com/flows?filter=#{request_flows}",
              {query: 'text/event-stream'},
              {'Accept' => 'text/event-stream'}
            )

            source.open do
              log.info('Connected to flowdock streaming API')
              robot.trigger(:connected)
            end

            source.message do |message|
              event = MultiJson.load(message)
              receive_message(event)
            end

            source.error do |error|
              log.error(error.inspect)
              EM.stop
            end

            source.start
          end
        end

        def send_messages(target, messages)
          messages.each do |message|
            client.chat_message(flow: target, content: message)
          end
        end

        def shut_down
          source.close
        end

        private
          attr_reader :robot, :api_token, :organization, :flows, :source,
            :client

          def log
            Lita.logger
          end

          def receive_message(event)
            log.debug("Event received: #{event.inspect}")
            MessageHandler.new(robot, robot_id, event, client).handle
          end

          def request_flows
            flows.map {|f| "#{organization}/#{f}" }.join(',')
          end

          def robot_id
            @robot_id ||= client.get('/user')['id']
          end
      end
    end
  end
end
