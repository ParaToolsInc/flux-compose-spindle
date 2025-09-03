#!/bin/bash
set -euxo pipefail

docker compose build
docker compose up -d
