require 'lita/adapters/flowdock/users_creator'

module Lita
  module Adapters
    class Flowdock < Adapter
      class MessageHandler
        def initialize(robot, data, flowdock_client)
          @robot = robot
          @data = data
          @flowdock_client = flowdock_client
          @type = data['event']
        end

        def handle
          case type
          when "message"
            handle_message
          when "activity.user"
            handle_user_activity
          when "action"
            handle_action
          else
            handle_unknown
          end
        end

        private
          attr_reader :robot, :data, :type, :flowdock_client

          def body
            data['content']
          end

          def dispatch_message(user)
            source = Source.new(user: user, room: flow)
            message = Message.new(robot, body, source)
            robot.receive(message)
          end

          def flow
            data['flow']
          end

          def log
            Lita.logger
          end

          def handle_message
            log.debug("Handling message: #{data.inspect}")
            user = User.find_by_id(data['user']) || User.create(data['user'])
            dispatch_message(user)
          end

          def handle_user_activity
            log.debug("Handling user activity: #{data.inspect}")
          end

          def handle_action
            log.debug("Handling action: #{data.inspect}")
            if %w{add_people invite join}.include?(data['content']['type'])
              UsersCreator.create_users(flowdock_client.get('/users'))
            end
          end

          def handle_unknown
            log.debug("Unknown message type: #{data.inspect}")
          end
      end
    end
  end
end
