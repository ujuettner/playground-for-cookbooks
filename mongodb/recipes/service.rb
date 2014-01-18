service 'mongodb' do
  supports :status => true, :restart => false, :reload => false
  action :nothing
end
