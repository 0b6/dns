# 使用你指定的 Alpine 版本
ARG ALPINE_RELEASE=edge
FROM alpine:$ALPINE_RELEASE

# 安装必要的软件包
RUN apk --no-cache add --upgrade dnsmasq-dnssec bash

# 暴露需要的端口
EXPOSE 53 53/udp 67/udp 69/udp

# 将 proxy-domains.txt 文件复制到容器中
COPY proxy-domains.txt /proxy-domains.txt

# 添加启动脚本到容器
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 设置默认的公共 IP（可以通过环境变量覆盖）
ENV PUBLIC_IP=192.168.1.1

COPY dnsmasq.conf /etc/dnsmasq.conf:ro

# 设置容器的启动命令为执行脚本
ENTRYPOINT ["/start.sh"]
