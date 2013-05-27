# chef-irc_handler [![Build Status](https://secure.travis-ci.org/bflad/chef-irc_handler.png?branch=master)](http://travis-ci.org/bflad/chef-irc_handler)

## Description

Chef cookbook that installs Chef handler for notifying IRC on Chef client
failures (non-TTY runs).

Currently uses a modified version of chef-irc-snitch.rb (additional options can
be passed in and Gist SSL broken by default in Ruby 1.9, so disabled Gist
creation):
* https://github.com/portertech/chef-irc-snitch

Which uses:
* https://github.com/portertech/carrier-pigeon

## Requirements

### Platforms

* RedHat 6.3 (Santiago)
* Ubuntu 12.04 (Precise)

### Cookbooks

* chef_hander

## Attributes

* `node['chef_client']['handler']['irc']['channel']` - IRC channel, defaults to
  "#admins"
* `node['chef_client']['handler']['irc']['channel_password']` - Optional password
  for the IRC channel.
* `node['chef_client']['handler']['irc']['hostname']` - _required_ IRC hostname,
  defaults to nil
* `node['chef_client']['handler']['irc']['join']` - Join IRC channel prior to
  messaging (required by some IRC servers like FreeNode), defaults to false
* `node['chef_client']['handler']['irc']['nick']` - IRC nick, defaults to
  "chef_client"
* `node['chef_client']['handler']['irc']['nickserv_command']` - if different
  Nickserv command is needed for identifying with Nickserv, see CarrierPigeon
  documentation/code for more information, defaults to nil
* `node['chef_client']['handler']['irc']['nickserv_password']` - IRC Nickserv
  password, defaults to nil
* `node['chef_client']['handler']['irc']['password']` - IRC server password,
  defaults to nil
* `node['chef_client']['handler']['irc']['port']` - IRC server port, defaults to
  6667
* `node['chef_client']['handler']['irc']['register_first']` - Register nick with
  IRC before messaging (required by some IRC servers), defaults to false
* `node['chef_client']['handler']['irc']['ssl']` - Use SSL for messaging IRC,
  defaults to false
* `node['chef_client']['handler']['irc']['timeout']` - Handler timeout in
  seconds for messaging IRC, defaults to 30

## Recipes

* `recipe[irc_handler]` installs and enables IRC chef_handler.

## Usage

* Set at least `node['chef_client']['handler']['irc']['hostname']`
* Add `recipe[irc_handler]` to your node's run list

## Contributing

Please use standard Github issues/pull requests.

## License and Author
      
* Author:: Brian Flad (<bflad417@gmail.com>)
* Author:: Morgan Blackthorne (<stormerider@gmail.com>)
* Copyright:: 2012-2013 Brian Flad
* Copyright:: 2013 Morgan Blackthorne
* Copyright:: 2012 University of Pennsylvania
* Copyright:: 2012 Sean Porter Consulting

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

