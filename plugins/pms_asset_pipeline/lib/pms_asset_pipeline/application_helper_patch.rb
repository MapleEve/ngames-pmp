require_dependency 'application_helper'

module ApplicationHelper
  def stylesheet_link_tag(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop : {}
    plugin = options.delete(:plugin)
    sources = sources.map do |source|
      if plugin
        "/assets/stylesheets/#{source}"
      elsif current_theme && current_theme.stylesheets.include?(source)
        "/assets/#{Setting.ui_theme}/stylesheets/#{source}"
      else
        source
      end
    end
    #MODIFIED (sprockets doesn't accept an array of sources it seems)
    #sources.map{|source|super source, options}.join.html_safe
    super *sources, options
  end

  def javascript_include_tag(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop : {}
    if plugin = options.delete(:plugin)
      sources = sources.map do |source|
        if plugin
          "/assets/javascripts/#{source}"
        else
          source
        end
      end
    end
    #MODIFIED (sprockets doesn't accept an array of sources it seems)
    #sources.map{|source|super source, options}.join.html_safe
    super *sources, options
  end
end
