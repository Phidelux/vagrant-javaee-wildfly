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

# Copy the wildfly service init script to its proper location, ...  
cp $WILDFLY_DIR/bin/init.d/wildfly-init-debian.sh /etc/init.d/$WILDFLY_SERVICE

# ... set the wildfly user and service name within the configuration ... 
sed -i -e 's,NAME='$WILDFLY_SYSTEM_USER',NAME='$WILDFLY_SERVICE',g' /etc/init.d/$WILDFLY_SERVICE

# ... and save the wildfly configuration path.
WILDFLY_SERVICE_CONF=/etc/default/$WILDFLY_SERVICE

# Set the proper access rights for the service configuration.
chmod 755 /etc/init.d/$WILDFLY_SERVICE
 
# Set environment variables for wildfly.
if [ ! -z "$WILDFLY_SERVICE_CONF" ]; then
  echo JBOSS_HOME=\"$WILDFLY_DIR\" > $WILDFLY_SERVICE_CONF
  echo JBOSS_USER=$WILDFLY_USER >> $WILDFLY_SERVICE_CONF
  echo STARTUP_WAIT=$WILDFLY_STARTUP_TIMEOUT >> $WILDFLY_SERVICE_CONF
  echo SHUTDOWN_WAIT=$WILDFLY_SHUTDOWN_TIMEOUT >> $WILDFLY_SERVICE_CONF
fi

# Apply minor changes to standalone.xml.
sed -i -e 's,<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000"/>,<deployment-scanner path="deployments" relative-to="jboss.server.base.dir" scan-interval="5000" deployment-timeout="'$WILDFLY_STARTUP_TIMEOUT'"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<inet-address value="${jboss.bind.address:127.0.0.1}"/>,<any-address/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<socket-binding name="ajp" port="${jboss.ajp.port:8009}"/>,<socket-binding name="ajp" port="${jboss.ajp.port:28009}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<socket-binding name="http" port="${jboss.http.port:8080}"/>,<socket-binding name="http" port="${jboss.http.port:28080}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<socket-binding name="https" port="${jboss.https.port:8443}"/>,<socket-binding name="https" port="${jboss.https.port:28443}"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
sed -i -e 's,<socket-binding name="osgi-http" interface="management" port="8090"/>,<socket-binding name="osgi-http" interface="management" port="28090"/>,g' $WILDFLY_DIR/standalone/configuration/standalone.xml
                     
service $WILDFLY_SERVICE start
