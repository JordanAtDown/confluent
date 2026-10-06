---
name: gdd-sync
description: Resynchroniser l'export markdown du GDD dans docs/gdd/ depuis le doc Claude en ligne. À utiliser quand on dit que le GDD a changé, qu'il faut resynchroniser la doc, remettre à jour docs/gdd/, ou après une session de travail sur le doc.
---

# Resynchroniser le GDD

Le doc en ligne est la source de vérité ; `docs/gdd/` n'est qu'un snapshot markdown. Cette
procédure le remet à jour sans jamais retaper de contenu à la main.

**Ne jamais recopier l'export base64 dans un heredoc.** Une seule erreur de caractère produit de
l'UTF-8 invalide, invisible à la relecture. On passe par un blob et un fichier sur disque, et on
vérifie le sha256.

## Identité du doc

| | |
| --- | --- |
| Doc | `GSE8uy5cevgHNtDevbwCr4` |
| URL artifact | `https://claude.ai/code/artifact/7cfec50f-596e-443f-aea6-75fdeeb29899` |

| Onglet | `file` id | Destination |
| --- | --- | --- |
| GDD v0.1 | `892f1831-27cf` | `docs/gdd/gdd.md` |
| Technique | `76e9b42e-fb1a` | `docs/gdd/technique.md` |
| Décisions techniques v0.1 | `30d51cb1-e6b6` | `docs/gdd/decisions/00-index.md` |
| 1. Fondation | `e1ccf500-4817` | `docs/gdd/decisions/01-fondation.md` |
| 2. Ressenti | `380aa69b-e17f` | `docs/gdd/decisions/02-ressenti.md` |
| 3. Océan et level design | `186e8de9-21e2` | `docs/gdd/decisions/03-ocean-level-design.md` |
| 4. Monde et plus tard | `24daa79d-432e` | `docs/gdd/decisions/04-monde-plus-tard.md` |
| Feuille de route du prototype | `35728756-1bc2` | `docs/gdd/feuille_de_route.md` |

## Procédure

### 1. Relire la liste des onglets

```
mcp__claude_ai_Claude_Docs__read( ref = {"object":"project","id":"GSE8uy5cevgHNtDevbwCr4"} )
```

Comparer `files[]` au tableau ci-dessus. Un onglet ajouté, renommé ou supprimé → mettre à jour ce
tableau et `docs/gdd/README.md` dans le même passage.

### 2. Un blob markdown par onglet

Un appel par onglet. La réponse donne `data.asset` (32 hex), `data.sha256`, `data.bytes` et
`rev` — les relever tous les huit.

```
mcp__claude_ai_Claude_Docs__create(
  object = "blob", engine = "blob",
  container = {"kind":"project","id":"GSE8uy5cevgHNtDevbwCr4"},
  payload = {"from":{"object":"file","id":"<file id>"},"format":"markdown"} )
```

### 3. Descendre chaque asset sur disque

```
Artifact( action = "read",
          url = "https://claude.ai/code/artifact/7cfec50f-596e-443f-aea6-75fdeeb29899",
          path = "<data.asset>" )
```

Le fichier est écrit dans le scratchpad, sous `artifact-files/<slug>/<asset>.md`. Le résultat
redonne le sha256 : il doit être identique à celui de l'étape 2.

### 4. Installer et vérifier

`cp` vers les destinations du tableau, puis les deux contrôles — un `cp` silencieux ne prouve rien :

```bash
cd docs/gdd
for f in gdd.md technique.md decisions/*.md; do iconv -f UTF-8 -t UTF-8 "$f" >/dev/null || echo "FAIL $f"; done
sha256sum -c -   # les huit sha256 relevés à l'étape 2
```

Un `FAIL` ou un sha256 qui ne correspond pas : refaire l'étape 3 pour ce fichier. Ne jamais
corriger un export à la main.

### 5. Mettre à jour l'index

Dans `docs/gdd/README.md` : la date d'export et la colonne `rev` de chaque onglet.

### 6. Relire ce qui dérive

L'export ne met pas à jour ce qui en est dérivé. Vérifier, et le dire si quelque chose a bougé :

- **`resources/*.tres`** — toute valeur chiffrée du GDD qui a changé. C'est la seule copie des
  chiffres dans le repo ; `docs/gdd/` explique le pourquoi, les `.tres` portent la valeur.
- **`docs/gdd/schemas.md`** — les 8 schémas en mermaid, tenus à la main. Comparer le `pub` de
  chaque widget au tableau de ce fichier : s'il a changé, relire le widget
  (`read` sur le node, `engine = "widget"`) et retranscrire.
- **`.claude/rules/ocean.md`** — invariants et règles de lisibilité.
- **`CLAUDE.md` § Design** — seulement si la structure de `docs/gdd/` change.
- **Les contradictions** listées dans `docs/gdd/README.md` : résolues, ou toujours ouvertes ?

### 7. Commit

Un seul commit, l'export et ses dérivés séparés s'ils changent tous les deux :

```bash
git add docs/gdd && git commit -m "docs(gdd): sync v0.1"
```

## Ce que l'export perd

Les widgets — schémas de boucle, arbres « signe → bonne réponse / erreur » — deviennent
`[embedded content: …]`. Les chips de date, de mention et d'énumération sont aplatis en texte.

Les schémas vivent donc dans `docs/gdd/schemas.md`, en mermaid, retranscrits à la main depuis le
code des widgets. Ne jamais les recopier dans `gdd.md` : il est écrasé à chaque sync.

## Dans l'autre sens

Si le repo a raison et le doc a tort (un chiffre réglé au banc d'essai, une décision prise en
codant), ne pas corriger le markdown local : il serait écrasé au prochain sync. Modifier le doc
avec `mcp__claude_ai_Claude_Docs__update`, puis resynchroniser.
