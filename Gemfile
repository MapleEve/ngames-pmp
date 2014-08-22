source 'https://ruby.taobao.org/'

gem "rails", "3.2.19"
gem "rake", "~> 10.1.1"
gem "sprockets-sass"
gem 'sass', '~> 3.3.9'
gem 'yui-compressor'
gem 'sass-rails'
gem 'coffee-rails', "~> 3.2.1"
gem 'uglifier'
gem "jquery-rails", "~> 2.0.2"
gem "coderay", "~> 1.1.0"
gem "fastercsv", "~> 1.5.0", :platforms => [:mri_18, :mingw_18, :jruby]
gem "builder", ">= 3.0.4"
gem "request_store", "1.0.5"
gem "mime-types"
gem "awesome_nested_set", "2.1.6"
gem "dalli"


# Optional gem for LDAP authentication
group :ldap do
  gem "net-ldap", "~> 0.3.1"
end

# Optional gem for OpenID authentication
group :openid do
  gem "ruby-openid", "~> 2.3.0", :require => "openid"
  gem "rack-openid"
end

platforms :mri, :mingw do
  group :rmagick do
    gem "rmagick", ">= 2.0.0"
  end
  group :markdown do
    gem "redcarpet", "~> 2.3.0"
  end
end

platforms :jruby do
  # jruby-openssl is bundled with JRuby 1.7.0
  gem "jruby-openssl" if Object.const_defined?(:JRUBY_VERSION) && JRUBY_VERSION < '1.7.0'
  gem "activerecord-jdbc-adapter", "~> 1.3.2"
end

# Include database gems for the adapters found in the database
# configuration file
require 'erb'
require 'yaml'
gem "mysql2", "0.3.11", :platforms => [:mri, :mingw]


group :development do
  gem "rdoc", ">= 2.4.2"
  gem "yard"
  gem "thin"
  gem 'compass', '~> 1.0.0.alpha.19'
end

group :production do
  gem 'puma','>= 2.8.2'
  gem 'therubyracer'
end

group :test do
  gem "shoulda", "~> 3.3.2"
  gem "mocha", ">= 0.14", :require => 'mocha/api'
  if RUBY_VERSION >= '1.9.3'
    gem "capybara", "~> 2.1.0"
    gem "selenium-webdriver"
  end
end

local_gemfile = File.join(File.dirname(__FILE__), "Gemfile.local")
if File.exists?(local_gemfile)
  puts "Loading Gemfile.local ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end

# Load plugins' Gemfiles
Dir.glob File.expand_path("../plugins/*/{Gemfile,PluginGemfile}", __FILE__) do |file|
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  eval_gemfile file
end
