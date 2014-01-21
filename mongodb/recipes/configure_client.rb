execute 'kill node process' do
  command 'pkill node; /bin/true'
  action :nothing
end

node['deploy'].each do |application, deploy|
  unless deploy['application_type'] == 'nodejs' && deploy['application'] == node['mongodb']['app_name']
    Chef::Log.debug("Skipping application #{application} as we're not intereseted in it.")
    next
  end

  current_dir = ::File.join(deploy['deploy_to'], 'current')

  mongo_config = {}
  unless node['mongodb']['replica_set'].empty?
    mongo_config['dbUrl'] = node['opsworks']['layers']['mongodb']['instances'].map{|k,v| "#{v['private_ip']}:#{node['mongodb']['port']}/?auto_reconnect=true"}
  else
    mongo_config['dbUrl'] = "#{node['opsworks']['layers']['mongodb']['instances'].first['private_ip'] rescue 'localhost'}:#{node['mongodb']['port']}/?auto_reconnect=true"
  end
  mongo_config['rsName'] = node['mongodb']['replica_set']

  template ::File.join(current_dir, 'mongo.json') do
    source 'mongo.json.erb'
    mode '0644'
    variables({
      :mongo_config => mongo_config.to_json
    })
    notifies :run, 'execute[kill node process]'
  end
end
