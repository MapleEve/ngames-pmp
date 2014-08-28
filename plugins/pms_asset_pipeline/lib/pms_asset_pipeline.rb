require "pms_asset_pipeline/version"

module PmsAssetPipeline
  # Run the classic redmine plugin initializer after rails boot
  class Plugin < ::Rails::Engine
    config.after_initialize do
      require File.expand_path("../../init", __FILE__)
    end

    #asset pipeline configuration
    #enable asset pipeline before sprockets boots
    initializer 'redmine.asset_pipeline', :before => 'sprockets.environment' do
      RedmineApp::Application.configure do
        config.assets.cache_store = :dalli_store, "127.0.0.1:11211", { namespace: 'assets_production', size: 64.megabytes }
        config.assets.enabled = true
        config.assets.debug = false
        config.assets.compile = false
        config.assets.digest = true
        config.assets.prefix = "/assets" #else we break the standard helpers / standard assets
        #add some paths
        config.assets.precompile << Proc.new { |path|
          if path =~ /\.(css|js)\z/
            full_path = Rails.application.assets.resolve(path).to_path
            asset_paths = %w( plugins/issue_hot_buttons plugins/a_common_libs plugins/clipboard_image_paste plugins/project_section plugins/redmine_agile plugins/redmine_workload plugins/redmine_stealth plugins/redmine_customized_report plugins/redmine_people plugins/redmine_lightbox plugins/redmine_timesheet_plugin plugins/redmine_banner public/themes public plugins/redmine_issue_checklist plugins/open_flash_chart plugins/redmine_knowledgebase plugins/redmine_nikoniko_calendar2 plugins/redmine_charts2 plugins/unread_issues plugins/redmine_monitoring_controlling plugins/redmine_login_audit app/assets vendor/assets lib/assets plugins/redmine_ckeditor plugins/redmine_issue_templates plugins/redmine_omniauth_ngames)
            if ((asset_paths.any? {|ap| full_path.include? ap}) && !path.starts_with?('_'))
              # puts "\tIncluding: " + full_path
              true
            else
              puts "\tExcluding: " + full_path
              false
            end
          else
           false
          end
        }
        config.assets.paths << "#{config.root}/public/stylesheets"
        config.assets.paths << "#{config.root}/public/javascripts"
        config.assets.paths << "#{config.root}/public/images"
        config.assets.paths << "#{config.root}/public/themes"
        #add all plugin directories in case some js/css/images are included directly or via relative css
        #it also avoids Sprocket's FileOutsidePaths errors
        config.assets.paths += Dir.glob("#{config.root}/plugins/*/assets")

        #compression
        config.assets.compress = true
        config.assets.css_compressor = :yui
        #The sass-rails gem is automatically used for CSS compression if included in Gemfile and no config.assets.css_compressor option is set.
        config.assets.js_compressor = :uglify
      end
    end


    #add our directory
    # config.assets.paths += Dir.glob("#{File.dirname(__FILE__)}/assets")


    # Register our processor (subclass of the standard one which adds a directive for redmine plugins)
    initializer 'redmine.sprockets_processor', :after => 'sprockets.environment' do
      require 'pms_asset_pipeline/sprockets_processor'
      env = RedmineApp::Application.assets
      env.unregister_preprocessor('text/css', Sprockets::DirectiveProcessor)
      env.unregister_preprocessor('application/javascript', Sprockets::DirectiveProcessor)
      env.register_preprocessor('text/css', PmsAssetPipeline::SprocketsProcessor)
      env.register_preprocessor('application/javascript', PmsAssetPipeline::SprocketsProcessor)
    end

    # Patch redmine's js/css helpers so they work with sprockets
    config.to_prepare do
      require_dependency 'pms_asset_pipeline/application_helper_patch'
    end
  end
end
