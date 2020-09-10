#!/bin/sh

# Download and install tls-shunt-proxy
mkdir /tmp/tls-shunt-proxy
curl -L -H "Cache-Control: no-cache" -o /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip https://github.com/liberal-boy/tls-shunt-proxy/releases/latest/download/tls-shunt-proxy-linux-amd64.zip
unzip /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip -d /tmp/tls-shunt-proxy
install -m 755 /tmp/tls-shunt-proxy/tls-shunt-proxy /proxy

# Remove temporary directory
rm -rf /tmp/tls-shunt-proxy

# tls-shunt-proxy new configuration
cat << EOF > /config.yaml
listen: 0.0.0.0:$PORT
inboundbuffersize: 4
outboundbuffersize: 32
vhosts:
  - name: $HOST
    http:
      paths:
        - path: $VMESS_WS_PATH
          handler: proxyPass
          args: 127.0.0.1:12345
        - path: $SOCKS_WS_PASS
          handler: proxyPass
          args: 127.0.0.1:12346
EOF

cat /config.yaml

ls -lh /proxy

/proxy -config /config.yaml
