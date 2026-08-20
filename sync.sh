#!/bin/bash
# Publie le dernier export Claude Design vers le site en ligne.
# Usage : ./sync.sh [chemin-vers-export.dc.html]
# Sans argument, prend le "Site maisonefficace*.dc.html" le plus récent de ~/Downloads.
set -euo pipefail
cd "$(dirname "$0")"

SRC="${1:-}"
if [ -z "$SRC" ]; then
  SRC=$(ls -t ~/Downloads/Site\ maisonefficace*.dc.html 2>/dev/null | head -1)
fi
if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
  echo "❌ Aucun export trouvé. Télécharge le fichier depuis Claude Design d'abord." >&2
  exit 1
fi
echo "📄 Export source : $SRC"

python3 - "$SRC" <<'PY'
import sys, io

src = sys.argv[1]
with io.open(src, encoding='utf-8') as f:
    html = f.read()

head_inject = '''<title>Maison Efficace — Thermopompes, climatisation et isolation au Québec</title>
<meta name="description" content="Thermopompes haute efficacité, climatisation et isolation pensées ensemble — pour une facture qui fond et un confort quatre saisons, partout au Québec. Soumission gratuite, réponse en 24 h.">
<meta property="og:title" content="Maison Efficace — Votre maison, à la bonne température.">
<meta property="og:description" content="Thermopompes, climatisation et isolation — une seule équipe, partout au Québec. Soumission gratuite.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://maisonefficace.ca">
<meta property="og:locale" content="fr_CA">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96'%3E%3Cpath d='M36 92 L16 92 L16 48 L48 22 L80 48 L80 92 L60 92' fill='none' stroke='%231C5D42' stroke-width='9'/%3E%3Cpath d='M48 92 L48 62' fill='none' stroke='%237FB94E' stroke-width='5'/%3E%3Cpath d='M48 66 C38 69 28 65 24 54 C36 51 45 57 48 66 Z' fill='%237FB94E'/%3E%3Cpath d='M48 66 C58 69 68 65 72 54 C60 51 51 57 48 66 Z' fill='%237FB94E'/%3E%3C/svg%3E">
<link rel="stylesheet" href="./overrides.css">
'''

if '<html>' in html and '<html lang=' not in html:
    html = html.replace('<html>', '<html lang="fr">', 1)
if '<title>' not in html:
    marker = '<script src="./support.js"></script>'
    html = html.replace(marker, head_inject + marker, 1)

with io.open('docs/index.html', 'w', encoding='utf-8') as f:
    f.write(html)
print('✅ docs/index.html mis à jour')
PY

if [ -d .git ]; then
  git add -A
  if git diff --cached --quiet; then
    echo "ℹ️  Aucun changement à publier."
  else
    git commit -m "Mise à jour du site depuis Claude Design ($(date '+%Y-%m-%d %H:%M'))" -m "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
    git pull --rebase
    git push
    echo "🚀 Poussé — le déploiement automatique est en cours."
  fi
else
  echo "ℹ️  Dépôt git non initialisé — fichier converti seulement."
fi
