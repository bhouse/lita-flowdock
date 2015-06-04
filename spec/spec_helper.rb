require "simplecov"
require "coveralls"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start { add_filter "/spec/" }

require "lita-flowdock"
require "lita/rspec"

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
end

def user_double(id)
  instance_double(
    'Lita::User', id: id, name: "Test User#{id}", mention_name: "user#{id}"
  )
end

def user_hash(id)
  { 'id' => id, 'name' => "Test User#{id}", "nick" => "user#{id}" }
end

def flow_hash(id)
  { 'id' => id, 'name' => "Test Flow#{id}", 'parameterized_name' => "test_flow#{id}"}
end
