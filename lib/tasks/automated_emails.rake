# Add crontask to server in order to run this at a specified time
#   run crontab -e
#================================
#   49 3 * * * /bin/bash -l -c 'cd /home/deployer/apps/vodsecurityproduction/current && RAILS_ENV=production /home/deployer/.asdf/shims/bundle exec rake devicinator >> /home/deployer/apps/vodsecurityproduction/shared/log/cronstuff.log 2>&1'
#================================

# https://en.wikipedia.org/wiki/Cron
# https://medium.com/@pawlkris/scheduling-tasks-in-rails-with-cron-and-using-the-whenever-gem-34aa68b992e3

desc "Automated email report"
task send_report: :environment do
  sql = "Select support_poc, owner_username, legacy_os, hostname FROM legacy_os_records as lor join devices as dev on lor.device_id = dev.id WHERE IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date) = 1 AND YEAR(review_date) = YEAR(CURRENT_DATE()) +1), (MONTH(review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date) = YEAR(CURRENT_DATE())) AND lor.deleted_at IS NULL"
  result = []
  records_array = ActiveRecord::Base.connection.exec_query(sql) 
  result.push({"table" => "legacy_os_records", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
  ReportMailer.send_report(result).deliver_now
end