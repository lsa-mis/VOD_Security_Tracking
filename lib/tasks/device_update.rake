# Add crontask to server in order to run this at a specified time
#   run crontab -e
#================================
#   49 3 * * * /bin/bash -l -c 'cd /home/deployer/apps/vodsecurityproduction/current && RAILS_ENV=production /home/deployer/.asdf/shims/bundle exec rake devicinator >> /home/deployer/apps/vodsecurityproduction/shared/log/cronstuff.log 2>&1'
#================================

desc "This will update all the devices in the system"
task devicinator: :environment do
  Device.find_each do |dev|
    begin
      device_class = DeviceManagment.new(dev.serial, dev.hostname) #  correct spelling is Managment
      if device_class.update_device
        dev.update!(device_class.device_attr) # Use update! to raise an exception if the update fails
      end
    rescue => e
      puts "Failed to update device #{dev.id}: #{e.message}"
      # logging to a cronstuff.log via the crontab
    end
  end
  puts "The device update ran #{Time.current}" # Use Time.current for timezone awareness
end
