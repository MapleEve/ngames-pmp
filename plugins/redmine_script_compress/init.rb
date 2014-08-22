require 'redmine'
require 'redmine_script_compress/version'
require 'redmine_script_compress/hooks'

Redmine::Plugin.register :redmine_script_compress do
  name 'Redmine Script Plugin plugin'
  description 'This plugin adds asset pipeline support for redmine plugins'
  author 'Maple'
  author_url 'mailto:jeanbaptiste.barth@gmail.com'
  url 'https://github.com/jbbarth/redmine_asset_pipeline'
  version RedminePluginCompress::VERSION
  requires_redmine :version_or_higher => '2.1.0'
end
