mount node[:opsworks_tmpfs][:cookbooks_cache][:path] do
  pass     0
  fstype   'tmpfs'
  device   '/dev/null'
  options  "size=#{node[:opsworks_tmpfs][:cookbooks_cache][:size]},\
            nr_inodes=#{node[:opsworks_tmpfs][:cookbooks_cache][:nr_inodes]},
            mode=#{node[:opsworks_tmpfs][:cookbooks_cache][:mode]},\
            uid=#{node[:opsworks_tmpfs][:cookbooks_cache][:uid]},\
            gid=#{node[:opsworks_tmpfs][:cookbooks_cache][:gid]}"
  options  "nr_inodes=999k,mode=755,uid=0,gid=0,size=50m"
  action   [:mount, :enable]
end
