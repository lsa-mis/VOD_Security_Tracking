require "whenever"

desc "This will update all the devices in the system"
task devicinator: :environment  do
  # All your magic here
  # Any valid Ruby code is allowed
  Device.all.each do |dev|
    device_class = DeviceManagment.new(dev.serial, dev.hostname)
    device_class.update_device
    dev.update(device_class.device_attr)
  end
end