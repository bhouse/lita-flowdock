module Lita
  module Adapters
    class Flowdock < Adapter
      class FlowsCreator
        class << self
          def create_flow(flow)
            Lita.logger.debug("Creating flow: #{flow['parameterized_name']}")
            Lita.redis.set("flows/#{flow['parameterized_name']}", flow['id'])
          end

          def create_users(flows)
            flows.each do |flow|
              create_flow(flow)
            end
          end
        end
      end
    end
  end
end
