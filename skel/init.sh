#!/bin/sh

# Copyright (c) 2019 Pepijn Oomen <oomen@piprograms.com>
#
# This is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with kube-apiserver-vip.  If not, see <http://www.gnu.org/licenses/>.

[ -n "${KEEPALIVED_VIP}" ] || {
  echo "missing KEEPALIVED_VIP from environment"
  exit 1
}

[ -f /etc/kubernetes/kubeconfig ] || {
  echo "missing /etc/kubernetes/kubeconfig"
  exit 1
}

cat <<EOF > /etc/keepalived/keepalived.conf
! Configuration File for keepalived
vrrp_script check_apiserver {
  script "/usr/bin/curl -sk -m 2 -E /etc/keepalived/client.crt https://127.0.0.1:6443/healthz -o /dev/null"
}
vrrp_instance VI_51 {
  interface eth0
  virtual_router_id 51
  virtual_ipaddress {
    ${KEEPALIVED_VIP}
  }
  track_script {
    check_apiserver
  }
}
EOF

grep 'client-key-data' /etc/kubernetes/kubeconfig | awk '{print $2}' | base64 -d > /etc/keepalived/client.crt
grep 'client-certificate-data' /etc/kubernetes/kubeconfig | awk '{print $2}' | base64 -d >> /etc/keepalived/client.crt

exec keepalived -lnGP
