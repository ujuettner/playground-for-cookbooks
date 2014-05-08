node['opsworks_docker']['images'].each do |image|
  docker_image image

  docker_container image do
    detach true
  end
end
