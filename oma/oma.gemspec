Gem::Specification.new do |s|
  s.name        = 'oma'
  s.version     = '0.0.2'
  s.date        = '2012-09-27'
  s.summary     = "OpenSRS's OMA Ruby client library"
  s.description = "Communicate with OpenSRS' Email Platform using the OMA protocol"
  s.authors     = ["Peter Blair"]
  s.email       = 'petermblair@gmail.com'
  s.files       = ["lib/opensrs/oma.rb"]
  s.homepage    =
    'http://rubygems.org/gems/oma'

  s.add_dependency('addressable')
  s.add_dependency('json')
end
