service 'fix_mysql_dirs' do
  action :nothing
end

template '/etc/init.d/fix_mysql_dirs' do
  source 'fix_mysql_dirs.erb'
  backup false
  owner 'root'
  group 'root'
  mode 0700
  notifies :start, "service[fix_mysql_dirs]"
end

execute 'FIX: ensure MySQL data owned by MySQL user' do
  command "ls -l #{node[:mysql][:datadir]} && chown -R #{node[:mysql][:user]}:#{node[:mysql][:group]} #{node[:mysql][:datadir]}"
  action :run
end
