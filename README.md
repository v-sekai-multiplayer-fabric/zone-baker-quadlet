# zone-baker-quadlet

Podman [quadlet](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)
source for zone-baker — a headless Godot asset validator + exporter
(`FROM godot-editor-double`). Run by systemd on an AlmaLinux host.

This repo is the source of truth for the unit; it is installed onto a
host rather than baked into a VM image.

## Layout

- `quadlets/zone-baker.container` — the quadlet. Tag pinned here.
- `install.sh` — installs the unit, creates `/var/lib/zone-baker`
  (staging in / exporter output), pre-pulls the image, reloads systemd.

The trigger model is TBD: zone-baker may become an on-demand job (queue
consumer) rather than a daemon. The quadlet here assumes daemon mode and
will be revised when the trigger architecture lands.

## Install

```sh
sudo ./install.sh
# write /etc/zone-baker/env if the deployment needs it
sudo systemctl start zone-baker.service
```

## Configuration (per-deployment, NOT in this repo)

- `/etc/zone-baker/env` — per-deployment config.
- `/var/lib/zone-baker` — staging + output dir.

## CI

`.github/workflows/lint.yml` validates the unit via podman's systemd
generator on every push/PR.
