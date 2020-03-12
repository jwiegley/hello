# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.box_check_update = false

  # config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh"
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  # config.vm.network :forwarded_port, guest: 80, host: 8080, host_ip: "127.0.0.1"

  config.vm.synced_folder ".", "/home/vagrant/src"

  config.vm.provider "vmware_desktop" do |v|
    v.vmx["memsize"] = "32768"
    v.vmx["numvcpus"] = "10"
    v.whitelist_verified = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    # apt-get update
    # apt-get dist-upgrade -y
    su vagrant -c 'bash -ilc "curl https://nixos.org/nix/install | sh"' > /dev/null 2>&1
    echo '. $HOME/.nix-profile/etc/profile.d/nix.sh' > ~vagrant/.bashrc
    chown vagrant ~vagrant/.bashrc
    su vagrant -c '. $HOME/.nix-profile/etc/profile.d/nix.sh; nix-env -u --leq; nix-env -i tmux'
    mkdir -p ~vagrant/.config/nix
    cat > ~vagrant/.config/nix/nix.conf <<EOF
max-jobs = 4
cores = 1
sandbox = true

substituters = https://nix.dfinity.systems https://cache.nixos.org/
trusted-substituters = https://nix.dfinity.systems
trusted-public-keys = cache.dfinity.systems-1:IcOn/2SVyPGOi8i3hKhQOlyiSQotiOBKwTFmyPX5YNw= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
require-sigs = true

trusted-users = vagrant
allowed-users = *
EOF
    chown -R vagrant ~vagrant/.config

    cat >> ~vagrant/.bashrc <<EOF
export CARGO_TARGET_DIR=$HOME/target
export CARGO_HOME=$CARGO_TARGET_DIR/.cargo-home
EOF
  SHELL
end
