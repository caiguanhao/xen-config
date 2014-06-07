#!/bin/bash

for domain in $(grep -Eo '[a-z0-9-]+(\.[a-z0-9-]+)*\.(com|net|org|edu|cn|info|me)' strings | sort -u); do
  echo $(dig +short $domain | grep -Eo '[0-9\.]{7,15}' | head -1) $domain
done
