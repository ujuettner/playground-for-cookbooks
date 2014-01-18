include_recipe 'mongodb::download_install'

group node['mongodb']['group'] do
  system true
end

user node['mongodb']['user'] do
  gid node['mongodb']['group']
  shell '/bin/false'
  system true
end

directory node['mongodb']['dbpath'] do
  owner node['mongodb']['user']
  group node['mongodb']['group']
  mode '0755'
end

directory node['mongodb']['logdir'] do
  owner node['mongodb']['user']
  group node['mongodb']['group']
  mode '0755'
end

directory node['mongodb']['confdir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

template '/etc/init.d/mongodb' do
  source 'mongodb.init.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

include_recipe 'mongodb::service'

service 'mongodb' do
  action :enable
end

template node['mongodb']['conf_filename'] do
  source 'mongodb.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[mongodb]'
end
