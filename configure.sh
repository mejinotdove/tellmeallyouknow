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
# listen: 监听地址
listen: 0.0.0.0:$PORT

# inboundbuffersize: 入站缓冲区大小，单位 KB, 默认值 4
# 相同吞吐量和连接数情况下，缓冲区越大，消耗的内存越大，消耗 CPU 时间越少。在网络吞吐量较低时，缓存过大可能增加延迟。
inboundbuffersize: 4

# outboundbuffersize: 出站缓冲区大小，单位 KB, 默认值 32
outboundbuffersize: 32

# vhosts: 按照按照 tls sni 扩展划分为多个虚拟 host
vhosts:

    # name 对应 tls sni 扩展的 server name
  - name: $HOST

    # http: 识别出的 http 流量的处理方式
    http:

      # paths: 按 http 请求的 path 分流，从上到下匹配，找不到匹配项则使用 http 的 handler
      paths:
          # path: path 以该字符串开头的请求将应用此 handler
        - path: $VMESS_WS_PATH
          handler: proxyPass
          args: 127.0.0.1:12345

          # path: http/2 请求的 path 将被识别为 *
        - path: $SOCKS_WS_PASS
          handler: proxyPass
          args: 127.0.0.1:12346
EOF

/usr/local/bin/tls-shunt-proxy -config /usr/local/etc/tls-shunt-proxy/config.yaml
