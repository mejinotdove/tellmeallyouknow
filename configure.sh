#!/bin/sh

# Download and install tls-shunt-proxy
mkdir /tmp/tls-shunt-proxy
curl -L -H "Cache-Control: no-cache" -o /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip https://github.com/liberal-boy/tls-shunt-proxy/releases/latest/download/tls-shunt-proxy-linux-amd64.zip
unzip /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip -d /tmp/tls-shunt-proxy
install -m 755 /tmp/tls-shunt-proxy/tls-shunt-proxy /usr/local/bin/tls-shunt-proxy

# Remove temporary directory
rm -rf /tmp/tls-shunt-proxy

/usr/local/bin/tls-shunt-proxy
