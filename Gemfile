source 'https://rubygems.org'
gem 'rake'
gem 'faster_require'
gem 'psych'
gem 'rspec-core'
gem 'rspec'
gem 'mocha'
gem 'lookup_http'
gem 'thor'
gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 3.8.0'
gem "deep_merge"

# JSON must be 1.x on Ruby 1.9
if RUBY_VERSION < '2.0'
  gem 'json', '~> 1.8'
  gem 'json_pure', '~> 1.8'
else
  gem 'json'
end
