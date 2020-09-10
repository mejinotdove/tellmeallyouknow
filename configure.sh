#!/bin/sh

# tls-shunt-proxy new configuration
install -d /usr/local/etc/tls-shunt-proxy
cat << EOF > /usr/local/etc/tls-shunt-proxy/config.yaml
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

# Run proxy
/usr/local/bin/proxy -config /usr/local/etc/tls-shunt-proxy/config.yaml
