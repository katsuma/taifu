# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "taifu/version"

Gem::Specification.new do |s|
  s.name        = "taifu"
  s.version     = Taifu::VERSION
  s.authors     = ["Ryo Katsuma"]
  s.email       = ["katsuma@gmail.com"]
  s.homepage    = "http://github.com/katsuma/taifu"
  s.summary     = %q{YouTube sound converter for iTunes}
  s.description = %q{taifu brings YouTube sound to your iTunes library silently}

  s.rubyforge_project = "taifu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.licenses = ["MIT"]

  s.add_development_dependency "rake", "~> 10.0.3"
  s.add_development_dependency "rspec", "~> 2.13.0"
  s.add_development_dependency "rb-fsevent", "~> 0.9.3"
  s.add_development_dependency "guard", "~> 1.8.1"
  s.add_development_dependency "guard-rspec", "~> 3.0.2"
  s.add_development_dependency "growl", "~> 1.0.3"
  s.add_development_dependency "fakefs", "~> 0.4.2"
  s.add_development_dependency "coveralls", "~> 0.6.6"
  s.add_development_dependency "simplecov", "~> 0.7.1"
  s.add_development_dependency "pry", "~> 0.9.12.2"
  s.add_dependency "itunes-client", "~> 0.0.6"
end
