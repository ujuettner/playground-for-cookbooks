execute 'clean-yum-cache' do
  command 'yum clean all'
  action :nothing
end

rf = remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '0644'
  notifies :run, resources(:execute => 'clean-yum-cache'), :immediately
end

rf.run_action(:create_if_missing)

yum_package 'bprobe' do
    action :install
end

