is_first_mongodb_node_me = (instances.keys.size == 1 && instances.keys.first == node['opsworks']['instance']['hostname'])
mongo_cmd_base = "#{::File.join(node['mongodb']['bindir'], 'mongo')} #{node['mongodb']['bind_ip']}"
replset_reconfig_js = ::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')

execute 'reconfigure Replica Set' do
  command "#{mongo_cmd_base} #{replset_reconfig_js}"
  action :nothing
  not_if is_first_mongodb_node_me
end

template "#{::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')}" do
  source 'replset_reconfig.js.erb'
  mode '0644'
  action :nothing
  notifies :run, 'execute[reconfigure Replica Set]'
end

ruby_block 'initiate Replica Set' do
  block do
    instances = node['opsworks']['layers']['mongodb']['instances']
    if is_first_mongodb_node_me
      Chef::Log.debug('Seem to be the first MongoDB node online - initiating Replica Set ...')
      system("#{mongo_cmd_base} --eval 'rs.initiate()'")
    else
      Chef::Log.debug('I am not the first MongoDB node online - waiting to be added the Replica Set by the Primary ...')
    end
  end
  notifies :create, "template[#{::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')}]"
end
