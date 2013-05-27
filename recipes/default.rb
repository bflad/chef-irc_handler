#
# Cookbook Name:: irc_handler
# Recipe:: default
#
# Copyright 2012
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

irc = node['chef_client']['handler']['irc'] if node['chef_client'] && node['chef_client']['handler']
irc ||= {}

if irc['hostname']
  include_recipe "chef_handler"

  chef_gem "carrier-pigeon"

  cookbook_file "#{node['chef_handler']['handler_path']}/chef-irc-snitch.rb" do
    source "chef-irc-snitch.rb"
    mode "0600"
  end.run_action(:create)

  irc_uri = "irc://#{irc['nick']}"
  irc_uri += ":#{irc['password']}" if irc['password']
  irc_uri += "@#{irc['hostname']}:#{irc['port']}/#{irc['channel']}"

  chef_handler "IRCSnitch" do
    source "#{node['chef_handler']['handler_path']}/chef-irc-snitch.rb"
    arguments [
      :irc_uri => irc_uri,
      :ssl => irc['ssl'],
      :join => irc['join'],
      :nickserv_command => irc['nickserv_command'],
      :nickserv_password => irc['nickserv_password'],
      :channel_password => irc['channel_password'],
      :register_first => irc['register_first'],
      :timeout => irc['timeout']
    ]
    supports :exception => true
    action :nothing
  end.run_action(:enable)
end
