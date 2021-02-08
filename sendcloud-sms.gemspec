Gem::Specification.new do |s|
  s.name        = 'sendcloud-sms'
  s.version     = '0.0.2'
  s.date        = '2016-07-13'
  s.summary     = 'An unofficial gem to send SMS with SendCloud API.'
  s.description = 'An unofficial gem to send SMS with SendCloud API.'
  s.authors     = ['HeckPsi Lab']
  s.email       = 'business@heckpsi.com'
  s.files       = ['lib/sendcloud-sms.rb']
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/heckpsi-lab/sendcloud-sms'
  s.license     = 'MIT'

  s.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  s.add_runtime_dependency 'rest-client', '>= 1.8.0'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-performance'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'webmock'
end
