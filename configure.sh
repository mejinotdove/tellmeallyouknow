#!/bin/sh

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray
cat << EOF > /usr/local/etc/v2ray/config.json
{
  "log": {
    "access": null,
    "error": null,
    "loglevel": "debug"
  },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID",
            "level": 0,
            "email": "test@vless.com"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 80
          },
          {
            "path": "$VMESS_WS_PATH",
            "dest": 10000,
            "xver": 1
          },
          {
            "path": "$SOCKS_WS_PATH",
            "dest": 10001,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "none"
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10000,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "alterId": 0,
            "id": "$UUID",
            "level": 1,
            "security": "none"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "$VMESS_WS_PATH"
        }
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 10001,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": false
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "$SOCKS_WS_PATH"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Run V2Ray
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
