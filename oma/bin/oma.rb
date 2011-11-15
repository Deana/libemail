#!/usr/bin/env ruby

require 'rubygems'
require 'opensrs/oma'
require 'pp'

o = OpenSRS::OMA.new :username => 'username', :password => 'password', :url => 'https://admin.a.hostedemail.com/api'

# Get all available methods
puts o.methods

pp o.get_user :user => 'pblair@tucows.com'
