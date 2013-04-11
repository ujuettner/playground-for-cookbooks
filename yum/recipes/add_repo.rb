
execute 'clean-yum-cache' do
  command 'echo "== REMOVE RPM DB ===" && rm -f /var/lib/rpm/__db* && echo "=== YUM CLEAN ALL ===" && yum clean all && echo "=== REMOVE YUM CACHE ===" && rm -rf /var/cache/yum && echo "=== ENABLE REPO ===" && yum-config-manager --quiet --enable boundary && echo "=== CREATE YUM CACHE ===" && yum makecache && echo "=== CHECK YUM ===" && yum check && echo "=== REBUILD RPM DB ===" && rpm --rebuilddb && echo "=== QUERY NEW REPO ===" && repoquery --disablerepo=* --enablerepo=boundary -a && echo "=== YUM PKG INFO ===" && yum info bprobe && echo "=== YUM PKG LIST ===" && yum list bprobe'
  action :nothing
end

ruby_block "reload-internal-yum-cache" do
  block do
    Chef::Provider::Package::Yum::YumCache.instance.reload
  end
  action :nothing
end

remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '00644'
  action :create_if_missing
  notifies :run, resource(:execute => 'clean-yum-cache'), :immediately
  notifies :create, resource(:ruby_block => 'reload-internal-yum-cache'), :immediately
end

