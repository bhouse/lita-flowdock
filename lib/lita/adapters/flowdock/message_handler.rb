require 'lita/adapters/flowdock/users_creator'
require 'lita/source/flowdock_source'
require 'lita/message/flowdock_message'

module Lita
  module Adapters
    class Flowdock < Adapter
      class MessageHandler
        def initialize(robot, robot_id, data, flowdock_client)
          @robot = robot
          @robot_id = robot_id
          @data = data
          @flowdock_client = flowdock_client
          @type = data['event']
        end

        def handle
          case type
          when "comment"
            handle_message
          when "message"
            handle_message
          when "activity.user"
            handle_user_activity
          when "action"
            handle_action
          when "tag-change"
            handle_tag_change
          else
            handle_unknown
          end
        end

        private
          attr_reader :robot, :robot_id, :data, :type, :flowdock_client

          def body
            content = data['content'] || ""
            return content.is_a?(Hash) ? content['text'] : content
          end

          def dispatch_message(user)
            source = FlowdockSource.new(
              user: user,
              room: flow,
              private_message: private_message?,
              message_id: private_message? ? data['id'] : data['thread']['initial_message']
            )
            message = FlowdockMessage.new(robot, body, source, data)
            robot.receive(message)
          end

          def flow
            data['flow']
          end

          def from_self?(user)
            user.id.to_i == robot_id
          end

          def log
            Lita.logger
          end

          def handle_message
            log.debug("Handling message: #{data.inspect}")
            user = User.find_by_id(data['user']) || create_user(data['user'])
            log.debug("User found: #{user.inspect}")
            return if from_self?(user)
            dispatch_message(user)
          end

          def handle_user_activity
            log.debug("Handling user activity: #{data.inspect}")
          end

          def handle_action
            log.debug("Handling action: #{data.inspect}")
            if %w{add_people join}.include?(data['content']['type'])
              UsersCreator.create_users(flowdock_client.get('/users'))
            end
          end

          def handle_tag_change
            robot.trigger(:tag_change, added: data['content']['add'], removed: data['content']['remove'], message: data['content']['message'])
          end

          def handle_unknown
            log.debug("Unknown message type: #{data.inspect}")
          end

          def create_user(id)
            user = flowdock_client.get("/user/#{id}")
            UsersCreator.create_user(user)
          end

          def private_message?
            data.has_key?('to')
          end
      end
    end
  end
end
