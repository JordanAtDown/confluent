# GDD — export local

Snapshot markdown du GDD. **La source de vérité est le doc en ligne**, pas ces fichiers :
les schémas, les commentaires et l'édition vivent là-bas.

- Doc : <https://claude.ai/artifact/GSE8uy5cevgHNtDevbwCr4>
- Exporté le **2026-10-10**
- Resynchroniser : `/gdd-sync` (voir `.claude/skills/gdd-sync/`)

| Fichier | Onglet | `rev` à l'export |
| --- | --- | --- |
| `gdd.md` | GDD v0.1 | 892 |
| `technique.md` | Technique | 178 |
| `decisions/00-index.md` | Décisions techniques v0.1 | 21 |
| `decisions/01-fondation.md` | 1. Fondation | 35 |
| `decisions/02-ressenti.md` | 2. Ressenti | 6 |
| `decisions/03-ocean-level-design.md` | 3. Océan et level design | 13 |
| `decisions/04-monde-plus-tard.md` | 4. Monde et plus tard | 2 |
| `feuille_de_route.md` | Feuille de route du prototype | 6 |
| `schemas.md` | les 8 schémas, en mermaid | tenu à la main |

## Ce que l'export perd

**Les 8 schémas de `gdd.md`** ne survivent pas à l'export : il ne reste qu'un placeholder
`[embedded content: …]`. Ils sont retranscrits en mermaid dans [`schemas.md`](schemas.md) —
les 2 boucles et les 14 dangers avec leur signe et leurs deux issues. Ce fichier est tenu à la
main : `/gdd-sync` ne le régénère pas.

Également aplatis en texte : les chips de date et de mention, les listes dans les cellules
de tableau, les chips d'énumération (statuts) de `technique.md`.

## Où vivent les chiffres

Les valeurs de la section « Monde & carte » du GDD sont dérivées en `.tres` dans
`resources/` — c'est là qu'on les change, pas dans le code ni ici. Le markdown explique
le *pourquoi*, les `.tres` portent la valeur.

## Contradiction résolue : Compatibility

Le doc décide maintenant « rendu Compatibility » (`decisions/00-index.md`, ligne Moteur, statut
**Décidé**), ce qui aligne le GDD sur `project.godot`
(`renderer/rendering_method="gl_compatibility"`). Résolu dans le doc le 2026-10-10 ; la
contradiction Forward+ listée jusque-là n'existe plus.

Les décisions que cette contradiction mettait en doute tiennent en Compatibility : #6 (couleur par
bandes, écume calculée sur la raideur, pas de SSR), #19 (brouillard de profondeur à 1,5 km),
#16 (global shader uniform) et #1 (Gerstner en vertex shader, FFT écarté).
