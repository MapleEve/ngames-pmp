require 'redmine'
require 'pms_asset_pipeline/version'
require 'pms_asset_pipeline/hooks'

Redmine::Plugin.register :pms_asset_pipeline do
  name 'PMS Asset Pipeline plugin'
  description 'This plugin adds asset pipeline support for PMS and plugins'
  author 'NGames Maple'
  author_url 'mailto:maple@ngames.cn'
  url 'https://github.com/jbbarth/redmine_asset_pipeline'
  version PmsAssetPipeline::VERSION
  requires_redmine :version_or_higher => '2.1.0'
end
