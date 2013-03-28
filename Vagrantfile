Vagrant::Config.run do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.host_name = "teamforge-berkshelf"

  config.vm.box = "centos-6.3"
  config.vm.box_url = "https://dl.dropbox.com/u/47541301/vagrantboxes/centos-6.3.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "33.33.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.

  # config.vm.network :bridged

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 80, 8088

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # Teamforge needs more memory than just a basebox, otherwise
  # JBoss won't start. See
  # http://help.collab.net/topic/sysadmin-620/faq/jbossfailerror.html
  config.vm.customize ["modifyvm", :id, "--memory", 4096]

  # The Teamforge RPMs are big. If you can, run a caching proxy somewhere
  # on your network while rebuilding the VM, to save yourself the download
  # times. (hence the proxy attribute)
  config.vm.provision :chef_solo do |chef|
    # chef.log_level = :debug
    chef.json = {
      :teamforge => {
        :server => {
          :public_site_name => 'localhost',
          :scm_default_shared_secret => 'stringbetw16&24chars'
        }
      },
      :yum => {
        :proxy => 'http://10.0.2.2:3128'
      }
    }

    chef.run_list = [
      "recipe[yum::yum]",
      "recipe[teamforge::server]"
    ]
  end
end
