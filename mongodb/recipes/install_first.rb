bash 'download the mongodb archive and extract it to /opt' do
  cwd '/tmp'
  code <<-EOC
    cd /tmp
    wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.9.tgz
    cd /opt
    tar -xvzf /tmp/mongodb-linux-x86_64-2.4.9.tgz
    chown -R root:root /opt/mongodb-linux-x86_64-2.4.9
  EOC
end
