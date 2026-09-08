#!/usr/bin/env bash
hostname="$1"
sudo nixos-rebuild switch --flake ".#$hostname" --impure