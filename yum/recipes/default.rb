execute 'reload-external-yum-cache' do
  command 'yum makecache'
  action :nothing
end

ruby_block 'reload-internal-yum-cache' do
  block do
    Chef::Provider::Package::Yum::YumCache.instance.reload
  end
  action :nothing
end

remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '00644'
  action :create_if_missing
  notifies :run, resources(:execute => 'reload-external-yum-cache'), :immediately
  notifies :create, resources(:ruby_block => 'reload-internal-yum-cache'), :immediately
end

yum_package 'bprobe' do
  action :install
end
