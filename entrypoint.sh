cd /v2raybin
wget -O v2ray.zip http://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip
unzip v2ray.zip 
cd /v2raybin/v2ray-v$VER-linux-64
chmod +x v2ray
chmod +x v2ctl

echo -e -n "$V2RAY_CONFIG" > config.json

./v2ray
