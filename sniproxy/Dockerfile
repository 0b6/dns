# --- 构建阶段 ---
FROM debian:bookworm AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential autoconf automake libtool \
    libpcre3-dev libev-dev libudns-dev pkgconf ca-certificates && \
    git clone --depth=1 https://github.com/dlundquist/sniproxy.git /sniproxy && \
    cd /sniproxy && \
    ./autogen.sh && \
    # 添加静态编译选项
    ./configure --enable-dns LDFLAGS="-static" && \
    make && \
    strip src/sniproxy

# --- 运行阶段 ---
FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=builder /sniproxy/src/sniproxy /usr/local/bin/sniproxy
COPY sniproxy.conf /etc/sniproxy/sniproxy.conf
COPY proxy-domains.txt /proxy-domains.txt
COPY start.sh /start.sh

RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]