if node['opsworks']['instance']['layers'].include?('java-app')
  include_recipe "opsworks_java::#{node['opsworks_java']['java_app_server']}_service"

  #execute "trigger #{node['opsworks_java']['java_app_server']} service restart" do
  #  command '/bin/true'
  #  notifies :restart, "service[#{node['opsworks_java']['java_app_server']}]", :immediately
  #end

  service node['opsworks_java']['java_app_server'] do
    action :restart
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
