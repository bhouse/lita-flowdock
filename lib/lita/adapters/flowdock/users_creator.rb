module Lita
  module Adapters
    class Flowdock < Adapter
      class UsersCreator
        class << self
          def create_user(flowdock_user)
            Lita.logger.debug("Creating user: #{flowdock_user['nick']}")
            User.create(
              flowdock_user['id'],
              name: flowdock_user['name'],
              mention_name: flowdock_user['nick']
            )
          end

          def create_users(flowdock_users)
            flowdock_users.each do |flowdock_user|
              create_user(flowdock_user)
            end
          end
        end
      end
    end
  end
end

