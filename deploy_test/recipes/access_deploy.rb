node[:deploy].each do |application, deploy|
  Chef::Log.info("DEBUG: '../#{deploy[:vendor][:source_dir]}'")
end
