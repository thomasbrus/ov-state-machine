Gem::Specification.new do |s|
  s.name    = 'ov_state_machine-core'
  s.version = '0.0.1'
  s.author  = "Thomas Brus"  
  s.summary = "OV State Machine core class."
  s.files   = Dir['lib/ov_state_machine/**/*.rb']
  s.add_dependency 'facets', '~> 2.9.3'
end