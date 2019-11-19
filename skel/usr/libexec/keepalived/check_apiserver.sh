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

curl \
  --silent \
  --output /dev/null \
  --max-time 2 \
  --insecure \
  --key /usr/libexec/keepalived/client.key \
  --cert /usr/libexec/keepalived/client.crt \
  https://localhost:6443/healthz
