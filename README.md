# maisonefficace.ca

Site vitrine — Thermopompes, climatisation et isolation au Québec.

- Conçu dans **Claude Design** (projet « maisoneffica.ca », fichier `Site maisonefficace v2`)
- `docs/` — le site déployé (export Design + runtime autonome `support.js` + `overrides.css` responsive)
- `sync.sh` — republie le dernier export téléchargé depuis Claude Design

## Mettre à jour le site

1. Dans Claude Design : menu du fichier → Download (le `.dc.html` arrive dans ~/Downloads)
2. `./sync.sh` — convertit, commit et pousse → déploiement automatique
