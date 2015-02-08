# lita-flowdock

[![Build Status](https://travis-ci.org/bhouse/lita-flowdock.svg?branch=master)](https://travis-ci.org/bhouse/lita-flowdock)
[![Coverage Status](https://coveralls.io/repos/bhouse/lita-flowdock/badge.svg?branch=master)](https://coveralls.io/r/bhouse/lita-flowdock?branch=master)

## Welcome!


[Lita](https://lita.io) is a chat service bot, similar to [hubot](http://hubot.github.com), but written in ruby. **lita-flowdock** is an adapter to connect Lita to the [Flowdock](http://flowdock.com) chat service.

### Disclaimer
This code is heavily based on the awesome work by [kenjij](https://github.com/kenjij) and [jimmycuadra](https://github.com/jimmycuadra) in the [lita-slack](https://github.com/kenjij/lita-slack) adapter. Changes were made for the difference in the API's between the services.

Slack uses a bi-directional Websockets API for listening to and posting messages, whereas Flowdock uses a one-way [Server-Sent Events](https://www.flowdock.com/api/streaming) stream for listening in real-time, and a [REST API](https://www.flowdock.com/api/rest) for posting messages.


## Installation

Add lita-flowdock to your Lita instance's Gemfile:

``` ruby
gem "lita-flowdock"
```

For quick setup, see the [Getting Started](https://github.com/bhouse/lita-flowdock/tree/master/GETTING_STARTED.md) page.

## Configuration

### Required Attributes
* `api_token` (String) - The bot's personal API token
 * Login to https://flowdock.com with the bot account
 * Get the personal API token from https://flowdock.com/account/tokens
* `organization` (String) - The organization for the flowdock account
* `flows` (Array) - Array of flows the bot should connect to, i.e. `main`

### Example

#### lita_config.rb
```ruby
Lita.configure do |config|
  config.robot.adapter = :flowdock
  config.robot.name = 'John_McClane'

  config.robot.adapters.flowdock.api_token = '210bf4d1ae890b20265313fdc907903c'
  config.robot.adapters.flowdock.organization = 'mycompany'
  config.robot.adapters.flowdock.flows = ['main', 'ops']
end
```

#### Using Chef cookbook attributes

```ruby
default['lita']['adapters'] = ['flowdock']
default['lita']['adapter_config']['flowdock'] = {
  'api_token'     => ENV['FLOWDOCK_API_TOKEN'],
  'organization'  => 'mycompany',
  'flows'         => ['main', 'ops']
}
```

## License

[MIT](http://opensource.org/licenses/MIT)
