
yum_repo = remote_file '/etc/yum.repos.d/boundary.repo' do
  source 'https://yum.boundary.com/boundary_centos6_64bit.repo'
  mode '0644'
end
yum_repo.run_action(:create_if_missing)

clean_yum_cache = execute 'clean-yum-cache' do
  command 'echo "== REMOVE RPM DB ===" && rm -f /var/lib/rpm/__db* && echo "=== REBUILD RPM DB ===" & rpm --rebuilddb && echo "=== YUM CLEAN ALL ===" && yum clean all && echo "=== REMOVE YUM CACHE ===" && rm -rf /var/cache/yum && echo "=== CREATE YUM CACHE ===" && yum makecache && echo "=== CHECK YUM ===" && yum check && echo "=== ENABLE REPO ===" && yum-config-manager --quiet --enable boundary && echo "=== QUERY NEW REPO ===" && repoquery --disablerepo=* --enablerepo=boundary -a && echo "=== YUM PKG INFO ===" && yum info bprobe'
  action :nothing
end
clean_yum_cache.run_action(:run)

package 'bprobe' do
    action :install
end

