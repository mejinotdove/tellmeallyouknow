#!/bin/sh

mkdir /usr/local/nginx/logs

cat << EOF > /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
pid /usr/local/nginx/logs/nginx.pid;
pcre_jit on;
include /etc/nginx/modules/*.conf;
events {
	worker_connections 1024;
}
http {
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	server_tokens off;
	client_max_body_size 1m;
	keepalive_timeout 65;
	sendfile on;
	tcp_nodelay on;
	ssl_prefer_server_ciphers on;
	ssl_session_cache shared:SSL:2m;
	gzip_vary on;
 include /etc/nginx/conf.d/*.conf;
}
EOF

cat << EOF > /etc/nginx/conf.d/default.conf
server { 
 listen $PORT;
 server_name _;
 location /takashi {
  proxy_pass http://127.0.0.1:12345;
  proxy_redirect off;
  proxy_http_version 1.1;
  proxy_set_header Upgrade \$http_upgrade;
  proxy_set_header Connection "upgrade";
  proxy_set_header Host \$http_host;
 }
}
EOF

nginx

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
    "log":{
        "access": null,
        "error":  null,
        "loglevel": "info"
    },
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": 12345,
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "security": "none",
                        "alterId": 0
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/takashi"
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
