default[:opsworks_tmpfs][:cookbooks_cache][:path] = ::File.join(Opsworks::InstanceAgent::Environment.file_cache_path, 'cookbooks')
default[:opsworks_tmpfs][:cookbooks_cache][:device] = 'tmpfs'
default[:opsworks_tmpfs][:cookbooks_cache][:size] = '200m'
default[:opsworks_tmpfs][:cookbooks_cache][:nr_inodes] = '999k'
default[:opsworks_tmpfs][:cookbooks_cache][:mode] = '755'
default[:opsworks_tmpfs][:cookbooks_cache][:uid] = 'aws'
default[:opsworks_tmpfs][:cookbooks_cache][:gid] = 'aws'

default[:opsworks_tmpfs][:berkshelf_cache][:path] = Opsworks::InstanceAgent::Environment.berkshelf_cache_path
default[:opsworks_tmpfs][:berkshelf_cache][:device] = 'tmpfs'
default[:opsworks_tmpfs][:berkshelf_cache][:size] = '200m'
default[:opsworks_tmpfs][:berkshelf_cache][:nr_inodes] = '999k'
default[:opsworks_tmpfs][:berkshelf_cache][:mode] = '755'
default[:opsworks_tmpfs][:berkshelf_cache][:uid] = 'aws'
default[:opsworks_tmpfs][:berkshelf_cache][:gid] = 'aws'

default[:opsworks_tmpfs][:data][:path] = '/var/lib/aws/opsworks/data'
default[:opsworks_tmpfs][:data][:device] = 'tmpfs'
default[:opsworks_tmpfs][:data][:size] = '500m'
default[:opsworks_tmpfs][:data][:nr_inodes] = '999k'
default[:opsworks_tmpfs][:data][:mode] = '700'
default[:opsworks_tmpfs][:data][:uid] = 'aws'
default[:opsworks_tmpfs][:data][:gid] = 'aws'
