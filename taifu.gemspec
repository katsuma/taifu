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
  s.add_development_dependency "rspec", "~> 3.0.0"
  s.add_development_dependency "rb-fsevent", "~> 0.9.4"
  s.add_development_dependency "guard", "~> 2.6.1"
  s.add_development_dependency "guard-rspec", "~> 4.3.1"
  s.add_development_dependency "growl", "~> 1.0.3"
  s.add_development_dependency "fakefs", "~> 0.5.3"
  s.add_development_dependency "coveralls", "~> 0.7.1"
  s.add_development_dependency "simplecov", "~> 0.9.0"
  s.add_development_dependency "pry", "~> 0.10.1"
  s.add_dependency "itunes-client", "~> 0.1.2"
end
