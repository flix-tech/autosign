# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','autosign','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'autosign'
  s.version = Autosign::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','autosign.rdoc']
  s.rdoc_options << '--title' << 'autosign' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'autosign'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('fakefs', '0.6.7')
  s.add_runtime_dependency('gli','2.12.2')
  s.add_runtime_dependency('jwt','1.5.1')
end