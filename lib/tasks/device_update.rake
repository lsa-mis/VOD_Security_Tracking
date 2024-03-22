# Add crontask to server in order to run this at a specified time
#   run crontab -e
#================================
#   49 3 * * * /bin/bash -l -c 'cd /home/deployer/apps/vodsecurityproduction/current && RAILS_ENV=production /home/deployer/.asdf/shims/bundle exec rake devicinator >> /home/deployer/apps/vodsecurityproduction/shared/log/cronstuff.log 2>&1'
#================================

# https://en.wikipedia.org/wiki/Cron
# https://medium.com/@pawlkris/scheduling-tasks-in-rails-with-cron-and-using-the-whenever-gem-34aa68b992e3

desc "This will update all the devices in the system"
task devicinator: :environment do
  Device.all.each do |dev|
    device_class = DeviceManagment.new(dev.serial, dev.hostname)
    if device_class.update_device
      dev.update(device_class.device_attr)
    end
  end
  puts "The device update ran #{DateTime.now}"
end