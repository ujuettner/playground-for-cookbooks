execute 'clean-yum-cache' do
  command 'yum clean all'
  action :nothing
end

remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '0644'
  action :create_if_missing
  notifies :run, resources(:execute => 'clean-yum-cache'), :immediately
end

yum_package 'bprobe' do
    action :install
    flush_cache [:before]
end
