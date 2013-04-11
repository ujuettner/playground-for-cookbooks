
yum_repo = remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '0644'
  notifies :run, resources(:execute => 'clean-yum-cache'), :immediately
end
yum_repo.run_action(:create_if_missing)

clean_yum_cache = execute 'clean-yum-cache' do
  command 'rm -f /var/lib/rpm/__db* && rpm --rebuilddb && yum clean all && rm -rf /var/cache/yum && yum makecache && yum check && yum-config-manager --quiet --enable boundary && repoquery --disablerepo=* --enablerepo=boundary -a'
  action :nothing
end
clean_yum_cache.run_action(:run)

yum_package 'bprobe' do
    action :install
end

