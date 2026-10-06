---
name: build
description: Lancer un build GitHub Actions de confluent (proto sur sa branche, ou release taguée) et récupérer les artifacts. À utiliser quand on demande un build, un export, un paquet Windows/Linux/Web, ou une release.
---

# Build confluent

Les exports tournent dans GitHub Actions ; rien n'est exporté en local. Presets disponibles dans
`export_presets.cfg` : Windows Desktop, Linux, Web.

## Build d'un proto

`platforms` accepte `windows`, `linux`, `web` ou `all` (défaut `windows`).

```bash
gh workflow run build.yml --ref proto/<sujet> -f platforms=windows
gh run list --workflow build.yml --limit 1      # relever l'ID du run
gh run watch <id>
gh run download <id> -D build/artifacts
```

Les artifacts restent téléchargeables 14 jours.

## Release

Le tag déclenche `release.yml`. Pas de tag, pas de release.

```bash
git tag v0.1.0 && git push origin v0.1.0
gh release view v0.1.0
```

CHANGELOG généré avec `git-cliff`, installé hors projet ; pas de `cliff.toml` dans le repo pour
l'instant, donc la configuration par défaut s'applique.

### Non tranché : pré-release sur les `0.x`

`gh release create` est appelé sans `--prerelease`, donc un tag `v0.0.x` ou `v0.1.0` publie une
release pleine, marquée « Latest » sur la page du dépôt. Tant que rien n'est stable, on peut
vouloir que les `0.x` sortent en pré-release. Vérifié sur un tag jetable `v0.0.1` le 2026-10-09 :
le workflow fonctionne, c'est bien un choix d'affichage, pas un bug.

Si on le veut, un seul endroit à changer, la dernière étape de
`.github/workflows/release.yml`. Rester en `sh` : le job tourne sans bash.

```sh
case "$GITHUB_REF_NAME" in v0.*) PRE=--prerelease ;; *) PRE= ;; esac
gh release create "$GITHUB_REF_NAME" dist/* --title "$GITHUB_REF_NAME" --notes-file "$NOTES" $PRE
```

À décider au premier vrai build jouable, pas avant.
