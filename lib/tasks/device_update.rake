# Add crontask to server in order to run this at a specified time
#   run crontab -e
#================================
#   49 3 * * * /bin/bash -l -c 'cd /home/deployer/apps/vodsecurityproduction/current /home/deployer/.rbenv/shims/bundle exec rake devicinator --silent'
#================================

# https://en.wikipedia.org/wiki/Cron
# https://medium.com/@pawlkris/scheduling-tasks-in-rails-with-cron-and-using-the-whenever-gem-34aa68b992e3

desc "This will update all the devices in the system"
task :devicinator do
  Device.all.each do |dev|
    device_class = DeviceManagment.new(dev.serial, dev.hostname)
    device_class.update_device
    dev.update(device_class.device_attr)
  end
  puts "The device update ran #{DateTime.now}"
end