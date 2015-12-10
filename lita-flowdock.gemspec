Gem::Specification.new do |spec|
  spec.name          = "lita-flowdock"
  spec.version       = "0.3.0"
  spec.authors       = ["Ben House"]
  spec.email         = ["ben@benhouse.io"]
  spec.description   = %q{flowdock adapter for lita.io}
  spec.summary       = %q{connects lita.io to flowdock chat service}
  spec.homepage      = "https://github.com/bhouse/lita-flowdock"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", "~> 4.2"
  spec.add_runtime_dependency "em-eventsource"
  spec.add_runtime_dependency "flowdock", ">= 0.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "bump"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
