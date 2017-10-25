FROM nethost/alpine:3.6
MAINTAINER billgo <cocobill@vip.qq.com>
RUN apk --no-cache add ca-certificates
RUN set -ex; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		armhf) arch='arm' ;; \
		aarch64) arch='arm64' ;; \
		x86_64) arch='amd64' ;; \
		*) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
	esac; \
	apk add --no-cache --virtual .fetch-deps libressl; \
	wget -O /usr/local/bin/traefik "https://github.com/containous/traefik/releases/download/v1.4.1/traefik_linux-$arch"; \
	apk del .fetch-deps; \
	chmod +x /usr/local/bin/traefik
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]