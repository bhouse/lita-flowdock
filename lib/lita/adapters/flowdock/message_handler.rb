module Lita
  module Adapters
    class Flowdock < Adapter
      class MessageHandler
        def initialize(robot, robot_id, data)
          @robot = robot
          @robot_id = robot_id
          @data = data
          @type = data['event']
        end

        def handle
          case type
          when "message"
            handle_message
          when "activity.user"
            handle_user_activity
          end
        end

        private
          attr_reader :robot, :robot_id, :data, :type

          def handle_message
            log.debug("Handling message: #{data.inspect}")
          end
      end
    end
  end
end
