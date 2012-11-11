#
# Cookbook Name:: irc_handler
# Attributes:: chef_client::handler::irc
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

default['chef_client']['handler']['irc']['channel'] = "#admins"
default['chef_client']['handler']['irc']['hostname'] = nil
default['chef_client']['handler']['irc']['join'] = false
default['chef_client']['handler']['irc']['nick'] = "chef_client"
default['chef_client']['handler']['irc']['nickserv_command'] = nil
default['chef_client']['handler']['irc']['nickserv_password'] = nil
default['chef_client']['handler']['irc']['password'] = nil
default['chef_client']['handler']['irc']['port'] = 6667
default['chef_client']['handler']['irc']['register_first'] = false
default['chef_client']['handler']['irc']['ssl'] = false
default['chef_client']['handler']['irc']['timeout'] = 30
