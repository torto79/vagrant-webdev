# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/precise32"

  # Hostname
  config.vm.hostname = "dev.torto.net"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # AHCTUNG: Anpassung der hosts-Datei auf dem host nicht vergessen !!!

    # Projektordner synchronisieren
  config.vm.synced_folder "./", "/var/www",
    id: "vagrant-root",
    owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=775,fmode=664"]

  # Provisioning
  config.vm.provision "shell", path: "bootstrap.sh"
end
