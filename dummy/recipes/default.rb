if node['opsworks']['instance']['layers'].include?('java-app')
  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
    command '/bin/true'
    not_if { node['opsworks_java'][node['opsworks_java']['java_app_server']]['auto_deploy'].to_s == 'true' }
    notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]", :immediately
  end
end

bash 'echo something into tmp file' do
  user 'root'
  cwd '/tmp'
  code <<-EOS
    date > dummy.out
    ls -l /srv/www/*/ >> dummy.out
    ps -ef >> dummy.out
  EOS
end
