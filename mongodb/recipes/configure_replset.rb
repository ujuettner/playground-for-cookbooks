instances = node['opsworks']['layers']['mongodb']['instances']
is_first_mongodb_node_me = (instances.keys.size == 1 && instances.keys.first == node['opsworks']['instance']['hostname'])
mongo_cmd_base = "#{::File.join(node['mongodb']['bindir'], 'mongo')} #{node['mongodb']['bind_ip']}"
replset_reconfig_js = ::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')
rs_conf = {}
rs_conf['_id'] = node['mongodb']['replica_set']
rs_conf['members'] = []
node['opsworks']['layers']['mongodb']['instances'].each_with_index do |(k,v),i|
  member = {}
  member['_id'] = i
  member['host'] = "#{v['private_ip']}:#{node['mongodb']['port']}"
  rs_conf['members'] << member
end

execute 'reconfigure Replica Set' do
  command "#{mongo_cmd_base} #{replset_reconfig_js}"
  action :nothing
  not_if { is_first_mongodb_node_me }
end

template "#{::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')}" do
  source 'replset_reconfig.js.erb'
  mode '0644'
  variables({
    :rs_conf => rs_conf.to_json
  })
  action :nothing
  notifies :run, 'execute[reconfigure Replica Set]'
end

ruby_block 'initiate Replica Set' do
  block do
    if is_first_mongodb_node_me
      Chef::Log.debug('Seem to be the first MongoDB node online - initiating Replica Set ...')
      system("#{mongo_cmd_base} --eval 'rs.initiate()'")
    else
      Chef::Log.debug('I am not the first MongoDB node online - waiting to be added the Replica Set by the Primary ...')
    end
  end
  not_if { node['mongodb']['replica_set'].empty? }
  notifies :create, "template[#{::File.join(node['mongodb']['confdir'], 'replset_reconfig.js')}]"
end
