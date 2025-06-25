# Run this before starating the container to the files are compatible with logrotate
dos2unix ./collectors/log_rotate/*.conf
chmod 644 ./collectors/log_rotate/*.conf
chmod 755 /var/log/services/postgres
chmod 755 /var/log/services/pgadmin
chmod 755 /var/log/services/qbittorrent
chmod 755 /var/log/services

# Interactive shell to run logrotate
docker exec -it logrotate sh

# Get into  container to run logrotate by starting a new container
docker compose run --rm logrotate sh

# When making changes to the logrotate configuration
docker compose build logrotate

# Force log rotation for the file (good for testing)
logrotate -v -f /etc/logrotate.d/pgadmin.conf
logrotate -v -f /etc/logrotate.d/postgres.conf
logrotate -v -f /etc/logrotate.d/qbittorrent.conf

logrotate -v -f /etc/logrotate.d/testing_dev_sandbox.conf