docker_image node['opsworks_docker']['image']

docker_container node['opsworks_docker']['image'] do
  detach true
end
