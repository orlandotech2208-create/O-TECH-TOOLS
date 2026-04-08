#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH HASH TOOL  v1.0                             ║
# ║   MD5 / SHA1 / SHA256 / SHA512 — natif bash         ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${YELLOW}"
  cat << 'EOF'
  _   _    _    ____  _   _
 | | | |  / \  / ___|| | | |
 | |_| | / _ \ \___ \| |_| |
 |  _  |/ ___ \ ___) |  _  |
 |_| |_/_/   \_\____/|_| |_|
EOF
  echo -e "${MAGENTA}  [ HASH TOOL ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

hash_text() {
  echo -ne "${YELLOW}  Texte a hasher : ${NC}"; read INPUT
  [ -z "$INPUT" ] && echo -e "${RED}[X] Vide.${NC}" && return

  echo -e "\n${BOLD}  Hashes de : \"${DIM}$INPUT${NC}${BOLD}\"${NC}\n"
  echo -e "  ${CYAN}MD5    :${NC} $(echo -n "$INPUT" | md5sum | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA1   :${NC} $(echo -n "$INPUT" | sha1sum | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA256 :${NC} $(echo -n "$INPUT" | sha256sum | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA512 :${NC} $(echo -n "$INPUT" | sha512sum | cut -d' ' -f1)"
}

hash_file() {
  echo -ne "${YELLOW}  Chemin du fichier : ${NC}"; read FILEPATH
  [ ! -f "$FILEPATH" ] && echo -e "${RED}[X] Fichier introuvable.${NC}" && return

  echo -e "\n${BOLD}  Hashes de : ${DIM}$FILEPATH${NC}\n"
  echo -e "  ${CYAN}MD5    :${NC} $(md5sum "$FILEPATH" | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA1   :${NC} $(sha1sum "$FILEPATH" | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA256 :${NC} $(sha256sum "$FILEPATH" | cut -d' ' -f1)"
  echo -e "  ${CYAN}SHA512 :${NC} $(sha512sum "$FILEPATH" | cut -d' ' -f1)"
}

verify_hash() {
  echo -ne "${YELLOW}  Hash connu : ${NC}"; read KNOWN_HASH
  echo -ne "${YELLOW}  Texte a verifier : ${NC}"; read INPUT

  local algo=$(echo "$KNOWN_HASH" | wc -c | tr -d ' ')
  local computed=""

  case $algo in
    33) computed=$(echo -n "$INPUT" | md5sum | cut -d' ' -f1) ;;
    41) computed=$(echo -n "$INPUT" | sha1sum | cut -d' ' -f1) ;;
    65) computed=$(echo -n "$INPUT" | sha256sum | cut -d' ' -f1) ;;
    129) computed=$(echo -n "$INPUT" | sha512sum | cut -d' ' -f1) ;;
    *) echo -e "${RED}[X] Algo non reconnu (longueur hash inconnue).${NC}"; return ;;
  esac

  if [ "$KNOWN_HASH" == "$computed" ]; then
    echo -e "\n  ${GREEN}[OK] Hash VALIDE — correspondance confirmee.${NC}"
  else
    echo -e "\n  ${RED}[X] Hash INVALIDE — pas de correspondance.${NC}"
    echo -e "  ${DIM}  Calcule : $computed${NC}"
  fi
}

menu() {
  echo -e "${BOLD}${GREEN}  Hash Tool :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Hasher un texte"
  echo -e "  ${CYAN}[2]${NC}  Hasher un fichier"
  echo -e "  ${CYAN}[3]${NC}  Verifier un hash"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[HASH]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) hash_text ;;
    2) hash_file ;;
    3) verify_hash ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
