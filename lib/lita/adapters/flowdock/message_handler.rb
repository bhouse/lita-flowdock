module Lita
  module Adapters
    class Flowdock < Adapter
      class MessageHandler
        def initialize(robot, data)
          @robot = robot
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
          attr_reader :robot, :data, :type

          def handle_message
            log.debug("Handling message: #{data.inspect}")
          end

          def handle_user_activity
            log.debug("Handling user activity: #{data.inspect}")
          end

          def log
            Lita.logger
          end
      end
    end
  end
end
