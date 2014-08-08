include_recipe 'apache2::default'

directory node[:myapp][:apache][:docroot] do
  action :create
  owner  "root"
  group  "root"
  mode   "0755"
end

%w(default 000-default 000-default.conf).each do |site|
  apache_site site do
    enable false
  end
end

%w(proxy expires proxy_http proxy_connect).each do |m|
  apache_module m
end

web_app "myapp" do
  template          "myapp.conf.erb"
  docroot           node[:myapp][:apache][:docroot]
  port              node[:myapp][:apache][:port]
  proxy_port        node[:myapp][:routed_port]
  server_name       node[:myapp][:apache][:server_name]
  max               node[:myapp][:apache][:max]
  ttl               node[:myapp][:apache][:ttl]
  acquire           node[:myapp][:apache][:acquire]
  retrytimeout      node[:myapp][:apache][:retrytimeout]
  connectiontimeout node[:myapp][:apache][:connectiontimeout]
  requesttimeout    node[:myapp][:apache][:requesttimeout]
  base_uri          node[:myapp][:apache][:base_uri]
end

apache_site "myapp" do
  action :enable
end

