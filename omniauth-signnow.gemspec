require File.expand_path('../lib/omniauth-signnow/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andres Bravo"]
  gem.email         = ["hola@andresbravo.com"]
  gem.description   = %q{Unofficial OmniAuth strategy for Signnow.com.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/andresbravog/omniauth-signnow"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-signnow"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Signnow::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.1'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
