include_recipe 'apache2::default'

%w(default 000-default).each do |site|
  apache_site site do
    enable false
  end
end

%w(proxy expires proxy_http proxy_connect).each do |m|
  apache_module m
end

