remote_file "/tmp/#{node['mongodb']['package_filename']}" do
  source "http://fastdl.mongodb.org/linux/#{node['mongodb']['package_filename']}"
end

execute "tar -xvzf /tmp/#{node['mongodb']['package_filename']}" do
  cwd '/tmp'
end

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

directory node['mongodb']['bindir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

ruby_block 'install binaries' do
  block do
    Chef::Log.debug "/tmp/#{node['mongodb']['package_basename']}/bin/*"
    ::Dir.glob("/tmp/#{node['mongodb']['package_basename']}/bin/*").each do |binary|
      Chef::Log.debug binary
      if !::File.directory?(binary) && ::File.executable?(binary)
        ::FileUtils.install binary, node['mongodb']['bindir'], :mode => 0755, :preserve => false, :verbose => true
      end
    end
  end
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
