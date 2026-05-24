# zone-baker-image

V-Sekai baker VM image: headless Godot asset validator + exporter
(zone-baker), run as a podman quadlet on top of `linux-base-image`.
Built once per release via packer; consumed by the `infra` repo as the
qcow2 for `harvester_virtualmachine.baker`.

## What's in the image

Inherits everything from `linux-base-image` (AlmaLinux 9 + podman +
chrony + qemu-guest-agent), and adds:

- `/etc/containers/systemd/zone-baker.container` — podman quadlet
  running `ghcr.io/v-sekai-multiplayer-fabric/zone-baker`
- `/var/lib/zone-baker` — mountpoint for staging assets and exporter
  output

zone-baker is `FROM godot-editor-double` (built by `godot-images`) and
runs the headless Godot editor for asset baking. The container image
is pre-pulled into podman's local store so first boot is fast. Tag
pinned in `configs/quadlets/zone-baker.container`; bumping is a
deliberate edit + re-bake.

Trigger model is TBD: zone-baker may run as an on-demand job (queue
consumer) rather than a daemon. The quadlet here assumes daemon mode
and will be revised when the trigger architecture lands.

## Build

CI on push to main + weekly schedule. Local:

```sh
cd packer
bash scripts/prepare-cidata.sh
packer init build.pkr.hcl
packer build build.pkr.hcl
ls ../output/
```

## Inheritance

Pin the parent version explicitly in `build.pkr.hcl`:

```hcl
variable "source_image_url" {
  default = "https://github.com/v-sekai-multiplayer-fabric/linux-base-image/releases/download/v0.1.0/linux-base-image.qcow2"
}
```
