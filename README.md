# Kubernetes API Virtual IP

This provides an Alpine based container image to allow for a high-available
Kubernetes API endpoint.

Example systemd service unit to run the container on a CoreOS/Flatcar based
Kubernetes distribution:
```
[Unit]
Description=Virtual IP for Kubernetes API
Wants=kubelet.service
[Service]
ExecStartPre=-/usr/bin/rkt rm --uuid-file=/var/cache/k8s-vip-api.uuid
ExecStart=/usr/bin/rkt run \
  --uuid-file-save=/var/cache/k8s-vip-api.uuid \
  --insecure-options=image \
  --volume=kubeconfig,kind=host,source=/etc/kubernetes/kubeconfig \
  --mount=volume=kubeconfig,target=/etc/kubernetes/kubeconfig \
  docker://docker.pkg.github.com/pjoomen/k8s-api-vip/alpine-keepalived \
  --hosts-entry=host \
  --net=host \
  --dns=host \
  --caps-retain=CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_FSETID,CAP_FOWNER,CAP_MKNOD,CAP_NET_RAW,CAP_SETGID,CAP_SETUID,CAP_SETFCAP,CAP_SETPCAP,CAP_NET_BIND_SERVICE,CAP_SYS_CHROOT,CAP_KILL,CAP_AUDIT_WRITE,CAP_NET_ADMIN \
  --environment=KEEPALIVED_VIP=10.18.3.11
ExecStop=-/usr/bin/rkt stop --uuid-file=/var/cache/k8s-vip-api.uuid
Restart=always
RestartSec=10
[Install]
WantedBy=multi-user.target
```
