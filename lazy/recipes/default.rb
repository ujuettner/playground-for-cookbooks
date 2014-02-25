file_content = 'old content'

ruby_block 'set file content' do
  block do
    file_content = 'new content'
  end
end

file '/tmp/some_file' do
  owner 'root'
  group 'root'
  content lazy { file_content }
end
