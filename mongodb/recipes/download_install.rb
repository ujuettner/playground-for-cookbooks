remote_file "/tmp/#{node['mongodb']['package_filename']}" do
  source "http://fastdl.mongodb.org/linux/#{node['mongodb']['package_filename']}"
end

execute "tar -xvzf /tmp/#{node['mongodb']['package_filename']}" do
  cwd '/tmp'
end

directory node['mongodb']['bindir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
end

ruby_block 'install binaries' do
  block do
    Chef::Log.debug "/tmp/#{node['mongodb']['package_basename']}/bin/*"
    ::Dir.glob("/tmp/#{node['mongodb']['package_basename']}/bin/*").each do |binary|
      Chef::Log.debug binary
      if !::File.directory?(binary) && ::File.executable?(binary)
        ::FileUtils.install binary, node['mongodb']['bindir'], :mode => 0755, :preserve => false, :verbose => true
      end
    end
  end
end

%w(mongo bson_ext).each do |gem|
  gem_package gem do
    gem_binary '/usr/local/bin/gem'
  end
end
