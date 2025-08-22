# Flux Compose with Spindle!

This is an adaptation of https://github.com/rse-ops/flux-compose for use with Spindle.
There is currently one example:

 - [plain-spindle](plain-spindle): a single node with a serial build of Spindle
 - [flux-spindle](flux-spindle): a four-node Flux setup with Spindle built with Flux support and the flux plugin.
  
This is modified from the upstream by:

- Configuring munged so that it can be used by Spindle.
- Installing Spindle dependencies.
- Installing Spindle into /home/fluxuser/spindle-inst.
- Mounting a shared volume to ease access to Spindle debug logs.

## General Setup

For examples you will need:

 - [Docker](https://docs.docker.com/get-docker/)
 - [Docker Compose](https://docs.docker.com/compose/)

Note that newer versions of docker include `compose` directly alongside the client (e.g., `docker compose`).
If you have an old version of Docker, you can [install docker compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04) and instead use `docker-compose`. It's not clear how long the older client will be supported, so it's recommended that you upgrade!

See the `README.md` inside each directory for specific usage instructions. 

#### License

This work is licensed under the [Apache-2.0](https://github.com/kubernetes-sigs/kueue/blob/ec9b75eaadb5c78dab919d8ea6055d33b2eb09a2/LICENSE) license.

SPDX-License-Identifier: Apache-2.0

Flux: LLNL-CODE-764420
