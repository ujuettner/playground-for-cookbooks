docker_image 'centos'

docker_container 'centos' do
  detach true
  volume '/mnt/docker:/docker-storage'
end
