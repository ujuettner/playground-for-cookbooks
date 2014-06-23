script 'retry' do
  interpreter 'bash'
  user 'root'
  code <<-EOC
    /bin/date
    /bin/false
    EOC
  retries 10
end
