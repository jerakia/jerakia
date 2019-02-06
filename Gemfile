source 'https://rubygems.org'

gemspec

group(:development, :test) do
  gem 'rspec-core'
  gem 'rspec'
  gem 'mocha'
  gem "puppet", ENV['PUPPET_GEM_VERSION'] || '~> 4.8.0'
  gem "webmock-rspec-helper"
  if RUBY_VERSION < '2.1'
    gem "nokogiri", '1.6.8'
  end
end

