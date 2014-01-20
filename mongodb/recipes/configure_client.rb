node['deploy'].each do |application, deploy|
  unless deploy['application_type'] == 'nodejs' && deploy['application'] == node['mongodb']['app_name']
    Chef::Log.debug("Skipping application #{application} as we're not intereseted in it.")
    next
  end

  current_dir = ::File.join(deploy['deploy_to'], 'current')

  db_url = {}
  db_url['dbUrl'] = node['opsworks']['layers']['mongodb']['instances'].map{|k,v| "mongodb://#{v['ip']}:27017/todo?auto_reconnect"}

  template ::File.join(current_dir, 'mongo.json') do
    source 'mongo.json.erb'
    mode '0644'
    variables({
      db_url => db_url.to_json
    })
  end
end
