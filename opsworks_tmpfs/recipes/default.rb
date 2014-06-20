['cookbooks_cache', 'berkshelf_cache', 'data'].each do |dir|
  mount node[:opsworks_tmpfs][dir][:path] do
    pass     0
    fstype   'tmpfs'
    device   node[:opsworks_tmpfs][dir][:device]
    options  [
      "size=#{node[:opsworks_tmpfs][dir][:size]}",
      "nr_inodes=#{node[:opsworks_tmpfs][dir][:nr_inodes]}",
      "mode=#{node[:opsworks_tmpfs][dir][:mode]}",
      "uid=#{node[:opsworks_tmpfs][dir][:uid]}",
      "gid=#{node[:opsworks_tmpfs][dir][:gid]}"
    ].join
    action   [:mount, :enable]
  end
end
