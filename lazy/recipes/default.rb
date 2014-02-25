data_from_json = {}

cookbook_file 'input.json' do
  path '/tmp/some.json'
end

ruby_block 'parse JSON' do
  block do
    data_from_json = JSON.parse(::File.read('/tmp/some.json'))
  end
end

Chef::Log.debug "XXX: #{data_from_json.inspect}"
package 'xxx' do
  package_name lazy { data_from_json['package_name'] }
  action :install
end
