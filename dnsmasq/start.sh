#!/bin/sh

# 检查是否设置了公共 IP 地址
if [ -z "$PUBLIC_IP" ]; then
  echo "公共 IP 地址没有设置，请确保设置了 PUBLIC_IP 环境变量"
  exit 1
fi

# 检查是否设置了允许的 IP 地址白名单
# if [ -z "$ALLOWED_IPS" ]; then
#   echo "允许的 IP 地址没有设置，请确保设置了 ALLOWED_IPS 环境变量"
#   exit 1
# fi

# 使用传入的 proxy-domains.txt 文件并添加到 dnsmasq 配置中
echo "正在使用 proxy-domains.txt 文件更新配置..."
while read -r domain; do
  echo "address=/$domain/$PUBLIC_IP" >> /etc/dnsmasq.d/custom_netflix.conf
done < /proxy-domains.txt

# 配置多个 IP 白名单
# echo "配置 IP 白名单..."
# for ip in $ALLOWED_IPS; do
#   echo "allow-ips=$ip" >> /etc/dnsmasq.d/custom_netflix.conf
# done

# 启动 dnsmasq 服务并保持在前台运行
echo "启动 dnsmasq 服务..."
exec /usr/sbin/dnsmasq --keep-in-foreground
