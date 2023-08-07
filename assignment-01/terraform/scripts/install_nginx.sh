#! /bin/bash

# Update apt repos and install nginx web server
echo "**** Startup Step 1/3: Update apt-get repositories. ****"
apt-get update

echo "**** Startup Step 2/3: Install Nginx web server. ****"
apt-get install -y nginx

# Query google's metadata server to get the VM details
echo "**** Startup Step 3/3: Create an index.html file with instance details for webserver. ****"

NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/hostname")
IP=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip")

cat <<EOF > /var/www/html/index.html
<h1>Compute Engine</h1>
<pre>
Instance Name: $NAME
Instance IP ADDRESS: $IP
</pre>
EOF
