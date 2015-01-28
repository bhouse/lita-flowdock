require 'eventmachine'
require 'em-http'
require 'json'

module Lita
  module Adapters
    class Flowdock < Adapter
      class Connector
        attr_reader :robot, :api_key, :organization, :flows

        def initialize(robot, api_key, organization, flows)
          @robot = robot
          @api_key = api_key
          @organization = organization
          @flows = flows
        end

        def connect
          log.info("Connecting to Flowdock")
          EventMachine.run do
            stream_connect = connect_request.get(
              :head => {
                'Authorization' => [api_key, ''],
                'accept' => 'application/json'
              }
            )
            log.info("STREAM: #{stream_connect.inspect}")

            buffer = ""
            stream_connect.stream do |chunk|
              log.info("CHUNK: #{chunk.inspect}")
              buffer << chunk
              while line == buffer.slice!(/.+\r\n/)
                log.info("LINE: #{JSON.parse(line).inspect}")
              end
            end
          end
        end

        private

          def connect_request
            @http ||= EM::HttpRequest.new(
              "https://stream.flowdock.com/flows?filter=#{request_flows}",
              :keepalive => true,
              :connect_timeout => 0,
              :inactivity_timeout => 0
            )
          end

          def request_flows
            flows.map {|f| "#{organization}/#{f}" }.join(",")
          end

          def log
            Lita.logger
          end
      end
    end
  end
end
