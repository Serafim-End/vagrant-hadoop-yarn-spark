echo "Install postgresql server"
yum -y install postgresql-server

echo "Enabling postgres autoboot"
sudo systemctl enable postgresql.service

echo "Deleting old databases"
sudo rm -rf /var/lib/pgsql/*
sudo rm -rf /var/lib/pgsql/backups/*
sudo rm -rf /var/lib/pgsql/data/*

echo "Initiliazing DB"
sudo /usr/bin/postgresql-setup initdb


echo "Starting postgresql service"
sudo systemctl start postgresql.service

echo "User postgres, password: postgres"
sudo -u postgres psql postgres -c "ALTER ROLE postgres WITH PASSWORD 'postgres'"

#echo "Stopping postgresql service"
#sudo systemctl stop postgresql.service

# Edit to allow socket access, not just local unix access
echo "Patching postgresql configuration files by replacing them"
sudo /bin/cp -f /home/vagrant/Code/Python/pg_hba.conf /var/lib/pgsql/data/pg_hba.conf
sudo /bin/cp -f /home/vagrant/Code/Python/postgresql.conf /var/lib/pgsql/data/postgresql.conf

echo "Patching complete, restarting"
sudo systemctl restart postgresql.service
