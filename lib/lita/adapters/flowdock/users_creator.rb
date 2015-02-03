module Lita
  module Adapters
    class Slack < Adapter
      class UserCreator
        class << self
          def create_user
            User.create(flowdock_user, robot, robot_id)
              flowdock_user.id,
              name: real_name(flowdock_user),
              mention_name: flowdock_user.name
            )

            update_robot(robot, flowdock_user) if flowdock_user.id == robot_id
          end

          def create_users(flowdock_users, robot, robot_id)
            flowdock_users.each { |slack_user| create_user(flowdock_user, robot, robot_id) }
          end

          private

            def real_name(flowdock_user)
              flowdock_user.real_name.size > 0 ? flowdock_user.real_name : flowdock_user.name
            end

            def update_robot(robot, flowdock_user)
              robot.name = flowdock_user.real_name
              robot.mention_name = flowdock_user.name
            end
        end
      end
    end
  end
end

