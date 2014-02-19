node["filesystem"].each do |device, filesystem|
  next if filesystem["mount"]

  mount_point = "/#{device.gsub("/", "_")}"

  directory mount_point do
    action :create
  end

  mount mount_point do
    device device
    options "defaults,nobootwait"
    action [:mount, :enable]
  end
end
