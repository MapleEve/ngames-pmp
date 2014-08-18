require 'redmine'
require_dependency 'redmine_omniauth_ngames/hooks'

Redmine::Plugin.register :redmine_omniauth_ngames do
  name 'Redmine NGames oAuth'
  author 'Maple'
  description 'This is a plugin for Redmine registration through NGames OA'
  version '0.0.1'
  url 'http://oa.ngames.com'
  author_url ''

  settings :default => {
    :client_id => "",
    :client_secret => "",
    :oauth_autentification => false,
    :allowed_domains => ""
  }, :partial => 'settings/ngames_settings'
end
