namespace :redmine_update_reminder do
  task :send_reminders => :environment do
    trackers=Tracker.all
    
    trackers.each do |t|
      logger = Rails.logger
      logger.info "Tracker:#{t.name}"
      
      open_issue_status_ids = IssueStatus.select('id').where(is_closed: false).collect { |is| is.id}

      update_duration = Setting.plugin_redmine_update_reminder["#{t.id}_update_duration"]
      if !update_duration.blank? && update_duration.to_f > 0
        updated_since = Time.now - (update_duration.to_f * 24).hours
      	issues = Issue.where(['tracker_id = ? AND assigned_to_id IS NOT NULL AND status_id IN (?) AND (updated_on < ?)',
                            t.id, open_issue_status_ids, updated_since])

        issues.each do |issue|       
          RemindingMailer.reminder_email(issue.assigned_to,issue).deliver unless issue.assigned_to.nil?         
        end
      end
    end
  end
end
