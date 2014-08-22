cron "first task" do
  path "/usr/bin:/usr/local/bin"
  minute "*/2"
  command "cd /srv/www/myapp/current && bundle exec ruby -v"
end

cron_env = {PATH => "/usr/local/bin:$PATH"}
cron "second task" do
  environment cron_env
  minute "*/2"
  command "cd /srv/www/myapp/current && bundle exec ruby -v"
end
