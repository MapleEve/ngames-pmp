class MyProjects < Redmine::Hook::ViewListener
  def view_welcome_index_right(context={})
    load_projects()
  end

  def load_projects()
      html = '<div class="box projects" id="statuses">'
      html += '<h2>' + l(:label_my_projects) + '</h2>'

      all_projects  = Project.visible().find(:all, :order => "projects.name")
      admin_projects = []
      my_projects = []

      all_projects.each do |project|
        if User.current.member_of?(project)
          my_projects << project
        else
          admin_projects << project
        end
      end

      if my_projects.first
        html += '<ul>'
        my_projects.each do |project|
          html += link_to_project(project)
        end
        html += '</ul>'
      else
        html += '<p class="nodata">' + l(:label_no_data) + '</p>'
      end

      if User.current.admin? && admin_projects.first
        html += '<h2>' + l(:label_admin_projects) + '</h2>'
        html += '<ul>'
        admin_projects.each do |project|
          html += link_to_project(project)
        end
        html += '</ul>'
      end
      html += '</div>'
      
      return html
  end
  
  def link_to_project(project)
    html = '<li>'
    html += "#{link_to h(project.name), { :controller => 'projects', :action => 'show', :id => project }, :class => 'projects', :id => 'admin-menu'  }"
    html += " | #{link_to l(:label_issue_view_all), { :controller => 'issues', :action=>'index', :project_id => project, :set_filter => 1 }, :class => 'projects', :id => 'admin-menu' } "
    html += " | #{link_to l(:label_assigned_to_me_issues), { :controller => 'issues', :action=>'index', :project_id => project, :set_filter => 1, :assigned_to_id => 'me' }, :class => 'projects', :id => 'admin-menu' } "
    html += " | #{link_to l(:label_overall_spent_time), project_time_entries_path(project), :spent_on => 'm', :user_id => 'me', :class => 'projects', :id => 'admin-menu' } "
    html += '</li>'
    
    return html
  end
    
end

