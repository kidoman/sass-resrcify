# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sass/resrcify/version"

Gem::Specification.new do |s|
  s.name        = "sass-resrcify"
  s.version     = Sass::Resrcify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karan Misra"]
  s.email       = ["kidoman@gmail.com"]
  s.homepage    = "http://kidoman.io/"
  s.summary     = %q{Allows resrcifying asset paths}
  s.description = %q{Allows resrcifying asset paths}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sass', '>= 3.1'
end
