# -*- encoding: utf-8 -*-
require File.expand_path('../lib/advanced_listview/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kreeti Technologies"]
  gem.email         = ["skarmakar@kreeti.com"]
  gem.description   = %q{AdvancedListview provides basic sort, search, filter, csv export, and json response for list view.}
  gem.summary       = %q{Basic sort, filter, csv export and json response}
  gem.homepage      = "https://github.com/kreetitech/advanced_listview"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "advanced_listview"
  gem.require_paths = ["lib"]
  gem.version       = AdvancedListview::VERSION
end
