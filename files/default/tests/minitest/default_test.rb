require File.expand_path('../support/helpers', __FILE__)

describe_recipe "irc_handler::default" do
  include Helpers::IRCHandler

  if node['chef_client'] &&
    node['chef_client']['handler'] &&
    node['chef_client']['handler']['irc'] &&
    node['chef_client']['handler']['irc']['hostname']

    it "creates IRC handler library" do
      file("#{node['chef_handler']['handler_path']}/chef-irc-snitch.rb").must_exist
    end
  end
end
