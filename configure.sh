#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# Download and install tls-shunt-proxy
mkdir /tmp/tls-shunt-proxy
curl -L -H "Cache-Control: no-cache" -o /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip https://github.com/liberal-boy/tls-shunt-proxy/releases/latest/download/tls-shunt-proxy-linux-amd64.zip
unzip /tmp/tls-shunt-proxy/tls-shunt-proxy-linux-amd64.zip -d /tmp/tls-shunt-proxy
install -m 755 /tmp/tls-shunt-proxy/tls-shunt-proxy /usr/local/bin/tls-shunt-proxy

# Remove temporary directory
rm -rf /tmp/tls-shunt-proxy

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

/usr/local/bin/tls-shunt-proxy -config /usr/local/etc/tls-shunt-proxy/config.yaml
