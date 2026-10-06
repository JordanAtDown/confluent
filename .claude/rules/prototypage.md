---
paths:
  - "src/**/*.tscn"
  - "**/*.tres"
  - "assets/materials/**"
---

# Prototypage

Un proto valide un comportement — déplacement, collision, timing, feel — pas une apparence.
La géométrie et les matériaux sont jetables.

- Volumes low poly : primitives Godot (`BoxMesh`, `CapsuleMesh`, `CylinderMesh`, `PlaneMesh`) ou
  CSG (`csg_manage`). Pas de mesh importé, pas de détail modélisé. Un ennemi est une capsule,
  une porte est une boîte.
- Taille, pivot et point d'origine sont ceux de l'objet final : les proportions sont ce qui est testé.
- Jamais d'`albedo_color` nu. Texture du pack, par exemple
  `addons/godot-prototype-texture/PNG/grid_512x512/grid_red_512x512.png` — variantes `grid_` et
  `checker_`, 9 couleurs (black, blue, cyan, lime, orange, pink, red, white, yellow), `512x512`
  ou `1024x1024`. Ce sont des PNG, rien à activer.
- Un pas de grille = 1 mètre : `uv1_scale` = les dimensions du volume en mètres. `uv1_triplanar`
  activé sur les volumes CSG étirés.
- Une couleur par rôle, la même dans toute la scène : joueur `lime`, ennemis `red`, sol et décor
  statique `white`, zones de déclenchement `cyan`, objets interactifs `yellow`.
- Matériau propre à une scène : `.tres` dans le dossier de la scène. Partagé par plusieurs
  features : `assets/materials/`.
