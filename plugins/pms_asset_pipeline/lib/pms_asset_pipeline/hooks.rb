module PmsAssetPipeline
  class Hooks < Redmine::Hook::ViewListener
    #adds all plugins css on each page
    def view_layouts_base_html_head(context)
      #stylesheet_link_tag("/assets/all_plugins") + javascript_include_tag("/assets/all_plugins")
    end
  end
end
