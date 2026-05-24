#!/usr/bin/env bash
# Provisioner: layers zone-baker bits on top of linux-base-image.
# Runs as root via `sudo -E bash`.
set -euo pipefail

install -d -m 0755 /etc/containers/systemd
install -m 0644 /tmp/quadlets/*.container /etc/containers/systemd/
rm -rf /tmp/quadlets

# Staging dir for assets in / exporter output out.
install -d -m 0755 /var/lib/zone-baker

# Pre-pull the baker image. Tag pinned in the quadlet; bumping it is a
# deliberate change to this repo (and re-bake).
podman pull ghcr.io/v-sekai-multiplayer-fabric/zone-baker:latest || \
  echo "Warning: zone-baker:latest pull failed; first boot will pull on demand"

dnf clean all
cloud-init clean --logs
: > /etc/machine-id
rm -f /var/lib/dbus/machine-id || true
fstrim -av || true
