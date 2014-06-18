default[:opsworks_tmpfs][:cookbooks_cache][:path] = ::File.join(Opsworks::InstanceAgent::Environment.file_cache_path, 'cookbooks')
default[:opsworks_tmpfs][:cookbooks_cache][:size] = '200m'
default[:opsworks_tmpfs][:cookbooks_cache][:nr_inodes] = '999k'
default[:opsworks_tmpfs][:cookbooks_cache][:mode] = '755'
default[:opsworks_tmpfs][:cookbooks_cache][:uid] = 0
default[:opsworks_tmpfs][:cookbooks_cache][:gid] = 0
