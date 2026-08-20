#!/bin/bash
# Active https_enforced sur GitHub Pages dès que le certificat est émis (max ~2 h)
for i in $(seq 1 60); do
  R=$(gh api -X PUT repos/humancia/maisonefficace/pages -F https_enforced=true 2>&1)
  if echo "$R" | grep -q '"https_enforced":true'; then
    echo "$(date) — HTTPS forcé activé" >> ~/Desktop/MAISONEFFICACE/.https-watch.log
    exit 0
  fi
  sleep 120
done
echo "$(date) — expiré sans cert après 2 h" >> ~/Desktop/MAISONEFFICACE/.https-watch.log
