# Copyright (c) 2012-2013 Brian Flad (<bflad417@gmail.com>)
# Copyright (c) 2013 Morgan Blackthorne (<stormerider@gmail.com>)
# Copyright (c) 2012 Sean Porter Consulting

# The below code is a fork of the original copyright holder. Original license
# included.

# Copyright (c) 2012 Sean Porter Consulting

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require "rubygems"
require "chef/handler"
require "uri"
require "json"
require "net/https"
require "carrier-pigeon"

class IRCSnitch < Chef::Handler
  attr_writer :irc_uri, :join, :nickserv_command, :nickserv_password, :register_first, :ssl, :timeout, :channel_password

  def initialize(options = {})
    [:irc_uri].each do |option|
      raise "You must provide an IRC #{option}" unless options.has_key?(option)
    end
    @gist_url = nil
    @irc_uri = options[:irc_uri]
    @join = options[:join]
    @nickserv_command = options[:nickserv_command]
    @nickserv_password = options[:nickserv_password]
    @channel_password = options[:channel_password]
    @register_first = options[:register_first]
    @ssl = options[:ssl] || false
    @timeout = options[:timeout] || 30
    @timestamp = Time.now.getutc
  end

  def formatted_run_list
    node.run_list.map { |r| r.type == :role ? r.name : r.to_s }.join(", ")
  end

  def formatted_gist
    ip_address = node.has_key?(:cloud) ? node.cloud.public_ipv4 : node.ipaddress
    node_info = [
      "Node: #{node.name} (#{ip_address})",
      "Run list: #{node.run_list}",
      "All roles: #{node.roles.join(', ')}"
    ].join("\n")
    [
      node_info,
      run_status.formatted_exception,
      Array(backtrace).join("\n")
    ].join("\n\n")
  end

  def create_gist
    begin
      timeout(10) do
        uri = URI.parse("https://api.github.com/gists")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = {
          "description" => "Chef run failed on #{node.name} @ #{@timestamp}",
          "public" => false,
          "files" => {
            "chef_exception.txt" => {
              "content" => formatted_gist
            }
          }
        }.to_json
        response = http.request(request)
        @gist_url = JSON.parse(response.body)["html_url"]
      end
      Chef::Log.info("Created a GitHub Gist @ #{@gist_url}")
    rescue Timeout::Error
      Chef::Log.error("Timed out while attempting to create a GitHub Gist")
    rescue => error
      Chef::Log.error("Unexpected error while attempting to create a GitHub Gist: #{error}")
    end
  end

  def message_irc
    message = "Chef failed on #{node.name} (#{formatted_run_list}) with: "
    if @gist_url
      message += "#{@gist_url}"
    else
      message += "#{run_status.formatted_exception}"
    end
    begin
      timeout(@timeout) do
        CarrierPigeon.send(
          :uri => @irc_uri,
          :message => message,
          :ssl => @ssl,
          :join => @join,
          :nickserv_command => @nickserv_command,
          :nickserv_password => @nickserv_password,
          :channel_password => @channel_password,
          :register_first => @register_first
        )
      end
      Chef::Log.info("Informed chefs via IRC: #{message}")
    rescue Timeout::Error
      Chef::Log.error("Timed out while attempting to message chefs via IRC")
    rescue => error
      Chef::Log.error("Unexpected error while attempting to message chefs via IRC: #{error}")
    end
  end

  def report
    if run_status.failed? && !STDOUT.tty?
      @timestamp = Time.now.getutc
      Chef::Log.error("Chef run failed @ #{@timestamp}, snitchin' to chefs via IRC (#{@irc_uri})")
      create_gist
      message_irc
    end
  end
end
