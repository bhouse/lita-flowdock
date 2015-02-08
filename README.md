# lita-flowdock

[![Build Status](https://travis-ci.org/bhouse/lita-flowdock.svg?branch=master)](https://travis-ci.org/bhouse/lita-flowdock)
[![Coverage Status](https://coveralls.io/repos/bhouse/lita-flowdock/badge.svg?branch=master)](https://coveralls.io/r/bhouse/lita-flowdock?branch=master)

## Testing
```shell
git clone https://github.com/litaio/development-environment ~/lita-dev
git clone git@github.com:bhouse/lita-flowdock.git ~/lita-dev/lita-flowdock
cd ~/lita-dev
vagrant up
vagrant ssh
```

On the vagrant vm:

```shell
export $ORG=<flowdock organization name>
export $FLOW_NAME=<flowdock flow name>
export $FLOW_API_TOKEN=<flowdock flow api token>
```

```shell
cd /vagrant
lita new .
echo 'gem "lita-whois"' >> Gemfile
echo 'gem "lita-flowdock", git: "git@github.com:bhouse/lita-flowdock.git", branch: "master"' >> Gemfile
bundle config local.lita-flowdock /vagrant/lita-flowdock
cat << EOF > lita_config.rb
Lita.configure do |config|
  config.robot.name = "Lita"
  config.robot.log_level = :info
  config.robot.adapter = :flowdock
  config.adapters.flowdock.api_key = "$FLOW_API_TOKEN"
  config.adapters.flowdock.organization = "$ORG"
  config.adapters.flowdock.flows = ["$FLOW_NAME"]
end
EOF
apt-get update && apt-get install build-essential -y
bundle install --path vendor/bundle
bundle update
bundle exec lita
```
