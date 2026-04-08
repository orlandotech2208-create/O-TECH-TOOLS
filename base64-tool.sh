#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH BASE64 TOOL  v1.0                           ║
# ║   Encodage / Decodage Base64 — bash natif            ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${BLUE:-\033[0;34m}"
  cat << 'EOF'
  ____    _    ____  _____   __   _  _
 | __ )  / \  / ___|| ____| / /_ | || |
 |  _ \ / _ \ \___ \|  _|  | '_ \| || |_
 | |_) / ___ \ ___) | |___ | (_) |__   _|
 |____/_/   \_\____/|_____| \___/   |_|
EOF
  echo -e "\033[0;35m  [ BASE64 TOOL ] \033[1;33mO-TECH TOOLS v1.0\033[0m"
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
}

encode_text() {
  echo -ne "${YELLOW}  Texte a encoder : ${NC}"; read INPUT
  [ -z "$INPUT" ] && echo -e "${RED}[X] Vide.${NC}" && return
  echo -e "\n  ${CYAN}Base64 :${NC} ${GREEN}$(echo -n "$INPUT" | base64)${NC}"
}

decode_text() {
  echo -ne "${YELLOW}  Base64 a decoder : ${NC}"; read INPUT
  [ -z "$INPUT" ] && echo -e "${RED}[X] Vide.${NC}" && return
  DECODED=$(echo "$INPUT" | base64 -d 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo -e "\n  ${CYAN}Decode :${NC} ${GREEN}$DECODED${NC}"
  else
    echo -e "\n  ${RED}[X] Chaine Base64 invalide.${NC}"
  fi
}

encode_file() {
  echo -ne "${YELLOW}  Fichier a encoder : ${NC}"; read FILEPATH
  [ ! -f "$FILEPATH" ] && echo -e "${RED}[X] Fichier introuvable.${NC}" && return
  OUTFILE="${FILEPATH}.b64"
  base64 "$FILEPATH" > "$OUTFILE"
  echo -e "\n  ${GREEN}[OK] Encode -> $OUTFILE${NC}"
}

decode_file() {
  echo -ne "${YELLOW}  Fichier Base64 a decoder : ${NC}"; read FILEPATH
  [ ! -f "$FILEPATH" ] && echo -e "${RED}[X] Fichier introuvable.${NC}" && return
  OUTFILE="${FILEPATH%.b64}.decoded"
  base64 -d "$FILEPATH" > "$OUTFILE" 2>/dev/null
  if [ $? -eq 0 ]; then
    echo -e "\n  ${GREEN}[OK] Decode -> $OUTFILE${NC}"
  else
    echo -e "\n  ${RED}[X] Fichier invalide ou corrompu.${NC}"
  fi
}

menu() {
  echo -e "${BOLD}${GREEN}  Base64 Tool :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Encoder un texte"
  echo -e "  ${CYAN}[2]${NC}  Decoder un texte Base64"
  echo -e "  ${CYAN}[3]${NC}  Encoder un fichier"
  echo -e "  ${CYAN}[4]${NC}  Decoder un fichier Base64"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[B64]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) encode_text ;;
    2) decode_text ;;
    3) encode_file ;;
    4) decode_file ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
done
