node[:deploy].each do |_, deploy|
  app_root = ::File.join(deploy[:deploy_to], "current")

  template "#{::File.join(app_root, "db-connect.php")}" do
    source "db-connect.php.erb"
    mode 0775
    owner node[:apache][:user]
    group deploy[:group]

    variables lazy {
      {
        :host => (deploy[:database][:host] rescue nil),
        :user => (deploy[:database][:username] rescue nil),
        :password => (deploy[:database][:password] rescue nil),
        :db => (deploy[:database][:database] rescue nil),
        :domain => (deploy[:deploy][:domains].first rescue "http://sandbox.example.net/" ),
        :rootpath => ::File.realpath(app_root)
      }
    }

    only_if do
      File.directory?(app_root)
    end
  end

  execute "chmod -R 775 #{app_root}" do
  end
end

