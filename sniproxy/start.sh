#!/bin/sh

red='\033[0;31m'
plain='\033[0m'

# 文件路径
DOMAINS_FILE="/proxy-domains.txt"
SNIPROXY_CONF="/etc/sniproxy/sniproxy.conf"

# 检查必要文件是否存在
if [ ! -f "$DOMAINS_FILE" ]; then
  echo -e "[${red}Error:${plain}] 域名文件不存在: $DOMAINS_FILE"
  exit 1
fi

if [ ! -f "$SNIPROXY_CONF" ]; then
  echo -e "[${red}Error:${plain}] sniproxy 配置文件不存在: $SNIPROXY_CONF"
  exit 1
fi

# 更新 sniproxy 配置
echo "正在更新 sniproxy 配置..."
TMP_SNIPROXY_RULES="/tmp/sniproxy-domains.txt"
> "$TMP_SNIPROXY_RULES"
while read -r domain; do
  escaped_domain=$(echo "$domain" | sed 's/\./\\\./g')
  echo "    .*${escaped_domain}\$ *" >> "$TMP_SNIPROXY_RULES"
done < "$DOMAINS_FILE"

# 使用文件锁以避免并发访问 sniproxy 配置文件
{
  # 插入域名规则到 table { 块内
  echo "正在将域名规则插入到 table { 块中..."
  
  # 查找 table { 并将临时规则插入到 table { 后
  sed -i "/table {/r $TMP_SNIPROXY_RULES" "$SNIPROXY_CONF" || {
    echo -e "[${red}Error:${plain}] 插入 sniproxy 域名规则失败。"
    exit 1
  }
} 3>&1 1>&2 2>&3

# 启动 sniproxy
echo "启动 sniproxy..."
exec /usr/local/bin/sniproxy -c "$SNIPROXY_CONF" -f 