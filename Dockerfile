FROM alpine:3.10

LABEL \
  name="pjoomen/k8s-api-vip/alpine-keepalived" \
  maintainer="Pepijn Oomen <oomen@piprograms.com>" \
  description="Alpine Linux platform for Kubernetes API Virtual IP" \
  io.k8s.description="Alpine Linux platform for Kubernetes API Virtual IP" \
  io.k8s.display-name="Alpine Linux Kubernetes API Virtual IP"

RUN apk add --no-cache keepalived curl && \
  adduser -D -u 1001 -G root -g keepalived_script -s /sbin/nologin keepalived_script
COPY skel /

CMD ["/init.sh"]
