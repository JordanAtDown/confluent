#!/usr/bin/env bash
# PreToolUse / Bash : refuse `mv` sur les fichiers du projet Godot.
# `mv` deplace le fichier sans mettre a jour les chemins dans les .tscn,
# qui cassent alors silencieusement. filesystem_manage suit les uid://.
set -uo pipefail

payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

# Un appel a mv quelque part dans la commande (y compris `git mv`, `&& mv`)
if ! printf '%s' "$cmd" | grep -qE '(^|[;&|(]|[[:space:]])mv([[:space:]]|$)'; then
    exit 0
fi

# ... qui touche un fichier ou un dossier du projet Godot
if ! printf '%s' "$cmd" | grep -qE '\.(tscn|tres|gd|gdshader|gdshaderinc|godot|import|uid)\b|(^|[[:space:]./"])(src|resources|assets|globals|shaders|theme|test|addons)/'; then
    exit 0
fi

reason="mv deplace le fichier sans reecrire les chemins des .tscn, qui cassent silencieusement. Utiliser filesystem_manage (op rename ou move) du serveur MCP godot-ai. S'il refuse parce qu'une reference par chemin existe, demander un renommage depuis le FileSystem dock de l'editeur."

jq -n --arg reason "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
