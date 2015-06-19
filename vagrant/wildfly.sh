#!/usr/bin/env bash

# Read installation parameters from config.cfg file.                            
if [ -f /vagrant/vagrant/config.cfg ]; then                                     
  source /vagrant/vagrant/config.cfg                                            
else                                                                            
  echo "ERROR: file config.cfg not found. Exiting."                             
  exit 1                                                                        
fi

# Download wildfly archive if it does not exist.
if [ ! -e "$WILDFLY_ARCHIVE" ]; then
  wget -q $WILDFLY_REPO
  if [ $? -ne 0 ]; then
    echo "Failed to download Wildfly."
    exit 1
  fi
fi

# Clean up old wildfly installation (important for provisioning).
rm -f "$WILDFLY_DIR"
rm -rf "$WILDFLY_FULL_DIR"
rm -rf "/var/run/$WILDFLY_SERVICE/"
rm -f "/etc/init.d/$WILDFLY_SERVICE"

# Create a new directory for wildfly, ...
mkdir $WILDFLY_FULL_DIR

# ... extract the downloaded archive into the target directory ...
tar -xzf $WILDFLY_ARCHIVE_NAME -C $INSTALL_DIR

# ... and create a symbolic link to the installation directory.
ln -s $WILDFLY_FULL_DIR/ $WILDFLY_DIR

# Create a new user for wildfly ...
useradd -s /sbin/nologin $WILDFLY_SYSTEM_USER

# ... and give him the proper rights for the new directories.
chown -R $WILDFLY_SYSTEM_USER:$WILDFLY_SYSTEM_USER $WILDFLY_DIR
chown -R $WILDFLY_SYSTEM_USER:$WILDFLY_SYSTEM_USER $WILDFLY_DIR/
