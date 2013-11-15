$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "accountable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "accountable"
  s.version     = Accountable::VERSION
  s.authors     = ["Alex Thomas"]
  s.email       = ["alex@gonetomorrow.co.uk"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Accountable."
  s.description = "TODO: Description of Accountable."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

    s.add_dependency "rails",   "~> 4.0.0"
    s.add_dependency "jquery-rails"
    s.add_dependency "devise", "~> 3.2.0"
    s.add_dependency "cancan", ">= 1.6.7"
    s.add_dependency 'paperclip'
    #     s.add_dependency 'uglifier', '>= 1.3.0'
    s.add_dependency "resque", "~> 1.0"
    s.add_dependency "will_paginate"
    #     s.add_dependency "twitter"
    s.add_dependency "ruby-mp3info"
    s.add_development_dependency "sqlite3"
    
  

end

