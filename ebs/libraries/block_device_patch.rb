module BlockDevice
  def self.assemble_raid(raid_device, options)
    Chef::Log.info("Resuming existing RAID array #{raid_device} with #{options[:disks].size} disks, RAID level #{options[:raid_level]} at #{options[:mount_point]}")
    unless exec_command("mdadm --assemble --verbose #{raid_device} #{options[:disks].join(' ')}")
      plain_disks = options[:disks].map{|disk| disk.gsub('/dev/', '')}
      affected_volume_groups = []
      File.readlines('/proc/mdstat').each do |line|
        md_device = nil
        md_device = line.split.first if plain_disks.any?{|disk| line.include?(disk)}
        if md_device
          begin
            physical_volume_info = OpsWorks::ShellOut.shellout("pvdisplay -c /dev/#{md_device}").lines.select{|pv_line| pv_line =~ /\/dev\/#{md_device}/}.first
            if physical_volume_info
              volume_group = physical_volume_info.split(':')[1] rescue nil
              if volume_group
                affected_volume_groups << volume_group
                Chef::Log.info("Deactivating volume group #{volume_group}")
                exec_command("vgchange --available n #{volume_group}")
              end
            end
          rescue RuntimeError => e
            Chef::Log.debug("Getting attributes of /dev/#{md_device} failed: #{e.class} - #{e.message} - #{e.backtrace.join("\n")}")
            Chef::Log.info("Getting attributes of /dev/#{md_device} failed: #{e.message}")
          ensure
            Chef::Log.info("Stopping /dev/#{md_device}")
            exec_command("mdadm --stop --verbose /dev/#{md_device}")
          end
        end
      end
      exec_command("mdadm --assemble --verbose #{raid_device} #{options[:disks].join(' ')}") or raise "Failed to assemble the RAID array at #{raid_device}"
      affected_volume_groups.each do |volume_group|
        Chef::Log.info "(Re-)activating volume group #{volume_group}"
        exec_command("vgchange --available y #{volume_group}")
      end
    end
  end
end
