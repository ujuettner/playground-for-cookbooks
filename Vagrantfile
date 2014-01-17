VAGRANTFILE_API_VERSION = '2'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu-precise64'
  config.vm.box_url = 'https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box'
  config.vm.network :private_network, ip: '10.0.0.169'
  config.vm.hostname = 'tiger13'
  config.vm.provider 'virtualbox' do |box|
    box.customize ['modifyvm', :id, '--memory', '1024']
  end
  config.omnibus.chef_version = '11.4.0'
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = '.'
    chef.log_level = :debug
    chef.json = {'key' => 'value'}
    chef.add_recipe 'dummy'
    #config.vm.synced_folder "cookbooks", "/var/lib/cookbooks"
  end
end
