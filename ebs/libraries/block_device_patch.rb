module BlockDevice
  def self.create_lvm(raid_device, options)
    Chef::Log.info "creating LVM volume out of #{raid_device} with #{options[:disks].size} disks at #{options[:mount_point]}"
    unless lvm_physical_group_exists?(raid_device)
      exec_command("pvcreate #{raid_device}") or raise "Failed to create LVM physical disk for #{raid_device}"
    end
    unless lvm_volume_group_exists?(raid_device)
      exec_command("vgcreate #{lvm_volume_group(raid_device)} #{raid_device}") or raise "Failed to create LVM volume group for #{raid_device}"
    end
    unless lvm_volume_exits?(raid_device)
      extends = `vgdisplay #{lvm_volume_group(raid_device)} | grep Free`.scan(/\d+/)[0]
      unless exec_command_with_retries("lvcreate -l #{extends} #{lvm_volume_group(raid_device)} -n #{File.basename(lvm_device(raid_device))}")
        exec_command("lvcreate -l #{extends} #{lvm_volume_group(raid_device)} -n #{File.basename(lvm_device(raid_device))} -Z n") or raise "Failed to create the LVM volume at #{raid_device}"
      end
    end
  end

  def self.exec_command_with_retries(command, max_tries=3, exponential_sleep_time_factor=10)
    try_count = 1
    while try_count <= max_tries
      Chef::Log.info "Try #{try_count}/#{max_tries}: #{command}"
      break if exec_command(command)
      sleep_time = exponential_sleep_time_factor * (2 ** (try_count - 1))
      Chef::Log.info "Try #{try_count}/#{max_tries} for '#{command}' failed - retrying in #{sleep_time} seconds."
      sleep sleep_time
      try_count += 1
    end
    success = try_count <= max_tries
    Chef::Log.info "'#{command}' successful after #{try_count}/#{max_tries} tries? #{success}"
    success
  end
end
