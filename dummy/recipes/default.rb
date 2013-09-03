bash 'echo something into tmp file' do
  user 'root'
  cwd '/tmp'
  code <<-EOS
    date > dummy.out
  EOS
end
