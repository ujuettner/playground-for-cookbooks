cron "first task" do
  path "/usr/local/bin:$PATH"
  minute "*/2"
  command "cd /srv/www/myapp/current && bundle exec ruby -v > /tmp/first_task 2>&1"
end

cron_env = {"PATH" => "/usr/local/bin:$PATH"}
cron "second task" do
  environment cron_env
  minute "*/2"
  command "cd /srv/www/myapp/current && bundle exec ruby -v > /tmp/second_task 2>&1"
end
