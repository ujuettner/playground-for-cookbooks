execute 'clean-yum-cache' do
  command 'rm -f /var/lib/rpm/__db* && rpm --rebuilddb && yum clean all'
  action :run
end

remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '0644'
  action :create_if_missing
  notifies :run, resources(:execute => 'clean-yum-cache'), :immediately
end

yum_package 'bprobe' do
    action :install
end

