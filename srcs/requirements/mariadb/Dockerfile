FROM	debian:bullseye

# Install MariaDB
EXPOSE	3306

# Set up the configuration file
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

# Set up the configuration file
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Set up the database
COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# Set up the entrypoint
CMD		["setup.sh", "mysqld_safe"]