execute 'FIX: ensure MySQL data owned by MySQL user' do
  command "ls -l #{node[:mysql][:datadir]} && chown -R #{node[:mysql][:user]}:#{node[:mysql][:group]} #{node[:mysql][:datadir]}"
  action :run
end
