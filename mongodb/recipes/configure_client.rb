node['deploy'].each do |application, deploy|
  unless deploy['application_type'] == 'nodejs' && deploy['application'] == node['mongodb']['app_name']
    Chef::Log.debug("Skipping application #{application} as we're not intereseted in it.")
    next
  end

  current_dir = ::File.join(deploy['deploy_to'], 'current')

  mongo_config = {}
  mongo_config['dbUrl'] = node['opsworks']['layers']['mongodb']['instances'].map{|k,v| "#{v['private_ip']}:27017/?auto_reconnect=true"}

  template ::File.join(current_dir, 'mongo.json') do
    source 'mongo.json.erb'
    mode '0644'
    variables({
      :mongo_config => mongo_config.to_json
    })
  end
end
