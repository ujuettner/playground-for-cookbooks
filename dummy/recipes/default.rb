bash 'echo something into tmp file' do
  user 'root'
  cwd '/tmp'
  code <<-EOS
    date > dummy.out
    ls -l /srv/www/*/ >> dummy.out
    ps -ef >> dummy.out
  EOS
end
