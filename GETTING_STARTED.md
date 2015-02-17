# Getting Started

## Flowdock setup

1. Create a new Flowdock user for your bot and sign-in as the bot
1. Get the Personal API token for the bot from the [API tokens](https://flowdock.com/account/tokens) page.
1. Invite the bot account to the flows it should monitor

## Bot setup

Development can be done using vagrant and the [development-environment](https://github.com/litaio/development-environment) supplied by the lita project.

See the [getting started](http://docs.lita.io/getting-started/installation/) docs page on the lita site for more information.

Assuming you have vagrant installed:

```shell
git clone https://github.com/litaio/development-environment ~/lita-dev
cd ~/lita-dev
vagrant up
vagrant ssh
```

Once you're logged into the vagrant vm:

```shell
export $BOT_NAME=<name of the bot>
export $ORG=<flowdock organization name>
export $FLOW_NAME=<flowdock flow name>
export $FLOWDOCK_API_TOKEN=<flowdock bot's personal api token>
```

```shell
cd /vagrant
lita new .
echo 'gem "lita-whois"' >> Gemfile
echo 'gem "lita-flowdock"' >> Gemfile
cat << EOF > lita_config.rb
Lita.configure do |config|
  config.robot.name = "$BOT_NAME"
  config.robot.mention_name = "!"
  config.robot.log_level = :debug
  config.robot.adapter = :flowdock
  config.adapters.flowdock.api_token = "$FLOWDOCK_API_TOKEN"
  config.adapters.flowdock.organization = "$ORG"
  config.adapters.flowdock.flows = ["$FLOW_NAME"]
end
EOF
apt-get update && apt-get install build-essential -y
bundle install --path vendor/bundle
bundle update
bundle exec lita
```

## Test it out

In flowdock, try

```
!help

<should output help for lita commands>

!whois github.com

Whois Server Version 2.0

Domain names in the .com and .net domains can now be registered
with many different competing registrars. Go to http://www.internic.net
for detailed information.
...
```

# Production
For a production setup, try the [chef cookbook](https://github.com/litaio/chef-lita) for lita
