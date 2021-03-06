# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "video_info/version"

Gem::Specification.new do |s|
  s.name         = "video_info"
  s.version      = VideoInfoVersion::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Thibaud Guillaume-Gentil', 'Florian LAMACHE']
  s.email        = ['thibaud@thibaud.me']
  s.homepage     = 'http://rubygems.org/gems/video_info'
  s.summary      = 'Vimeo, Dailymotion & Youtube parser'
  s.description  = 'Get video info from youtube and vimeo url.'

  s.rubyforge_project = "video_info"

  s.add_dependency 'hpricot', '~> 0.8.4'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec', '~> 2.8'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'vcr', '~> 1.11'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_paths = ["lib"]
end
