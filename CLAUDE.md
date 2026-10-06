# confluent

Jeu Godot 4.7 en GDScript. Addons dans `addons/` : `gut` 9.7.1, `godot_ai` 4.3.0,
`godot-prototype-texture` — jamais édités à la main.

Rendu en Compatibility (`renderer/rendering_method="gl_compatibility"`). SDFGI, SSAO/SSIL/SSR,
brouillard volumétrique et shaders de calcul sont indisponibles. Si une fonctionnalité demandée
exige Forward+, le dire au lieu de l'implémenter.

## Commandes

```bash
GODOT=~/godot/Godot_v4.7.2-stable_linux.x86_64   # hors du PATH

$GODOT --display-driver x11 --path .      # lancer le jeu
$GODOT --display-driver x11 -e --path .   # ouvrir l'éditeur
$GODOT --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test -ginclude_subdirs -gexit
```

- `--path .` sur chaque commande ; `-gexit` pour que GUT rende la main à la fin du run.
- Un seul fichier : ajouter `-gtest=res://test/player/test_player.gd`.
- Si le serveur MCP `godot-ai` est connecté, utiliser `project_run` et `test_run` à la place.

## Structure

Organisation par fonctionnalité pour le jeu, par type pour le transversal. Une scène = un dossier,
qui contient sa scène, son script et ses assets propres.

- `src/` — tout le contenu jouable, un dossier par feature : `main/`, `player/`, `enemies/`,
  `levels/`, `ui/` (un dossier par écran).
- `globals/` — autoloads uniquement, 4 au maximum.
- `resources/` — les `.tres` de données de jeu : stats, vagues, courbes.
- `assets/` — `fonts/`, `music/`, `sfx/` ; seulement ce qui est partagé par plusieurs features.
- `shaders/`, `theme/` — transversal.
- `test/` — miroir de `src/` : `test/player/test_player.gd`.

Chaque dossier naît avec son premier fichier ; ne pas créer l'arborescence d'avance.

### Règles

- `snake_case` pour les dossiers et les fichiers, `PascalCase` pour les noms de nœuds et les
  `class_name` — l'export Linux/Android est sensible à la casse là où Windows laisse passer.
- Un script porte le nom de sa scène : `player.tscn` + `player.gd`. Pas de dossier `scripts/`.
  Seuls les scripts sans scène — classes de base, utilitaires statiques, resources — vivent seuls.
- Un test par fichier testé, nommé `test_*.gd`, classe `extends GutTest`.
- Les helpers GUT (`add_child_autofree`, `autofree`…) renvoient un type non déclaré :
  annoter la variable (`var main: Node3D = add_child_autofree(...)`), `:=` ne compile pas.
- Un enfant ne connaît pas son parent : il émet un signal.
- Ne jamais `preload` depuis un dossier frère de même niveau. Si le besoin apparaît, soit les deux
  features n'en font qu'une, soit la partie commune remonte d'un niveau.
- Les données de jeu sont des `.tres` dans `resources/`, pas des constantes dans le code.
- Renommer ou déplacer un fichier : `filesystem_manage` (op `rename` ou `move`). L'outil refuse si
  une référence par chemin existe — seules les `uid://` sont suivies ; demander alors un renommage
  depuis le FileSystem dock. Un hook `PreToolUse` refuse les `mv` sur les fichiers du projet.

## Design

Le GDD est exporté dans `docs/gdd/` ; la source de vérité est le doc en ligne (lien dans
`docs/gdd/README.md`), resynchronisable par `/gdd-sync`.

- Lire la section concernée avant toute décision de game design. Ne pas inventer une règle de
  navigation, de marée ou de tempête absente du GDD : la demander.
- Les chiffres d'échelle sont des `.tres` dans `resources/`. Ne jamais les redéfinir dans un script.
- `docs/gdd/README.md` liste une contradiction ouverte : le GDD décide Forward+, le projet tourne
  en Compatibility. Ne pas la trancher seul.

## Plans

Tout plan d'implémentation généré est écrit dans `.claude/plans/<feature>/`, un dossier par
feature, nommé comme la feature dans `src/` : `.claude/plans/ocean/maillage_vagues_etape1.md`.

- Jamais de plan ailleurs : ni à la racine, ni dans `docs/`, ni dans le dossier de la feature.
- `snake_case` pour le fichier, un plan par sujet, le numéro d'étape dans le nom s'il y en a une.
- Un plan est un document de travail, pas le GDD : il peut être repris, annoté, périmé. Les
  décisions qui deviennent définitives remontent dans `docs/gdd/decisions/`.

## Workflow

Trunk-based sur `main`, aucune Pull Request. Le hook `pre-commit` de `.githooks/` lance les tests
GUT : un commit échoue si la suite échoue.

<!-- À activer une fois par clone : git config core.hooksPath .githooks -->

- Travail cadré : commits conventionnels directement sur `main`. `--amend` sans hésiter tant que
  rien n'est poussé.
- Prototypage : branche `proto/<sujet>`, commits `wip: ...` libres, aucune discipline.
  - Concluant : `git merge --squash proto/<sujet>` dans `main`, puis un seul commit conventionnel.
  - Abandonné : `git tag archive/<sujet> proto/<sujet>` puis supprimer la branche.
- Tag `vX.Y.Z` à chaque build jouable ; sans tag, `git-cliff` n'a pas d'intervalle à générer.
  `0.x` tant que rien n'est stable : un `feat!` ne coûte rien.

## Commits

Conventional Commits, `type(scope): sujet`, en anglais, impératif présent, sans point final,
72 caractères maximum.

- Types : `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `style`, `chore`, `ci`.
- Scope optionnel, un seul mot en minuscules : `scene`, `script`, `ui`, `audio`, `input`,
  `addons`, `project`.
- Un commit = un changement logique. Ne pas mélanger un `feat` et un `refactor`.
- Corps de message seulement si le *pourquoi* n'est pas évident ; expliquer la raison, pas le diff.
- Changement cassant : `!` après le scope (`feat(input)!: ...`) et un bloc `BREAKING CHANGE:`
  dans le corps.
- Les `.import` et `.uid` générés par Godot sont commités avec l'asset concerné.
