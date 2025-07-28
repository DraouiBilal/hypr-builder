#!/bin/bash
arg=$1
podman build -t "hypr-builder:$1-latest" -f "packages/$1/Containerfile" .
