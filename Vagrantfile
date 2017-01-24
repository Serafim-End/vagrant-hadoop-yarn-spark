Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	numNodes = 4
	r = numNodes..1
	(r.first).downto(r.last).each do |i|
		config.vm.define "node-#{i}" do |node|
			node.vm.box = "centos/7"
			#node.vm.box_url = "http://files.brianbirkinbine.com/vagrant-centos-65-i386-minimal.box"
			node.vm.provider "virtualbox" do |v|
			  v.name = "node#{i}"
			  v.customize ["modifyvm", :id, "--memory", "1024"]
			end
			if i < 10
				node.vm.network :private_network, ip: "10.211.55.10#{i}"
			else
				node.vm.network :private_network, ip: "10.211.55.1#{i}"
			end
			node.vm.hostname = "node#{i}"
			node.vm.provision "shell", path: "scripts/setup-centos.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-centos-hosts.sh"
				s.args = "-t #{numNodes}"
			end
			if i == 2
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 3 -t #{numNodes}"
				end
			end
			if i == 1
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-centos-ssh.sh"
					s.args = "-s 2 -t #{numNodes}"
				node.vm.synced_folder "~/Code/Python", "/home/vagrant/Code/Python", :mount_options => ["dmode=777","fmode=666"]
				end
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-pip.sh"
				end
				node.vm.provision "shell" do |s|
					s.path = "scripts/setup-postgresql.sh"
				end

				# RabbitMQ
				config.vm.network :forwarded_port, guest: 5672, host: 5672, auto_correct: true

				# Reddis
				config.vm.network :forwarded_port, guest: 6379, host: 6379, auto_correct: true
				
				# Портал
				config.vm.network :forwarded_port, guest: 8000, host: 8000, auto_correct: true
				config.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true
				config.vm.network :forwarded_port, guest: 8088, host: 8088, auto_correct: true

				# Postgres
				config.vm.network :forwarded_port, guest: 32, 	host: 5432, auto_correct: true
				config.vm.network :forwarded_port, guest: 5432, host: 32, 	auto_correct: true

				# Spark + Hive
				config.vm.network :forwarded_port, guest: 1521, host: 1521, auto_correct: true

			end
			node.vm.provision "shell", path: "scripts/setup-java.sh"
			node.vm.provision "shell", path: "scripts/setup-hadoop.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-hadoop-slaves.sh"
				s.args = "-s 3 -t #{numNodes}"
			end
			node.vm.provision "shell", path: "scripts/setup-spark.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-spark-slaves.sh"
				s.args = "-s 3 -t #{numNodes}"
			end
		end
	end
end
