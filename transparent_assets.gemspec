Gem::Specification.new do |s|
  s.name        = 'transparent-assets'
  s.version     = '0.0.1'
  s.date        = '2013-01-19'
  s.summary     = "Transparent assets"
  s.description = "A gem that allows to store assets on any remote storage"
  s.authors     = ["jaturken", "l0ckdock"]
  s.email       = 'jaturken@gmail.com'
  s.files       = ["lib/transparent_assets.rb"]
  s.homepage    = 'https://github.com/jaturken/transparent-assets'
  s.add_dependency('uuid')
  s.add_dependency('carrierwave')
  s.add_dependency('fog')
end
