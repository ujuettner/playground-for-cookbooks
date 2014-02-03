node[:deploy].each do |application, deploy|
  if deploy[:vendor] && deploy[:vendor][:source_dir]
    Chef::Log.info("DEBUG: '../#{deploy[:vendor][:source_dir]}'")
  else
    Chef::Log.info("DEBUG: 'deploy[:vendor][:source_dir]' not found - ignoring")
  end
end
