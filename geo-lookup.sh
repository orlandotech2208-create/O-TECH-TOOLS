#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH GEO LOOKUP  v1.0                            ║
# ║   Geolocalisation IP via ipinfo.io (gratuit)         ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${GREEN}"
  cat << 'EOF'
   ____ _____ ___
  / ___| ____/ _ \
 | |  _|  _|| | | |
 | |_| | |__| |_| |
  \____|_____\___/
  L O O K U P
EOF
  echo -e "${MAGENTA}  [ GEO LOOKUP ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

lookup_ip() {
  local IP="$1"
  echo -e "\n${DIM}  Requete vers ipinfo.io...${NC}\n"

  # Requete JSON via curl (pas besoin de jq)
  local RESPONSE
  RESPONSE=$(curl -s --max-time 10 "https://ipinfo.io/${IP}/json" 2>/dev/null)

  if [ -z "$RESPONSE" ]; then
    echo -e "${RED}[X] Pas de reponse. Verifie ta connexion.${NC}"
    return
  fi

  # Parse manuel sans jq
  local IP_ADDR ORG CITY REGION COUNTRY LOC TIMEZONE

  IP_ADDR=$(echo "$RESPONSE" | grep '"ip"' | sed 's/.*": *"\(.*\)".*/\1/')
  CITY=$(echo "$RESPONSE"    | grep '"city"' | sed 's/.*": *"\(.*\)".*/\1/')
  REGION=$(echo "$RESPONSE"  | grep '"region"' | sed 's/.*": *"\(.*\)".*/\1/')
  COUNTRY=$(echo "$RESPONSE" | grep '"country"' | sed 's/.*": *"\(.*\)".*/\1/')
  ORG=$(echo "$RESPONSE"     | grep '"org"' | sed 's/.*": *"\(.*\)".*/\1/')
  LOC=$(echo "$RESPONSE"     | grep '"loc"' | sed 's/.*": *"\(.*\)".*/\1/')
  TIMEZONE=$(echo "$RESPONSE"| grep '"timezone"' | sed 's/.*": *"\(.*\)".*/\1/')

  echo -e "${CYAN}┌─ RESULTAT ──────────────────────────────────${NC}"
  echo -e "  ${BOLD}IP        :${NC} ${GREEN}${IP_ADDR:-$IP}${NC}"
  echo -e "  ${BOLD}Ville     :${NC} ${CITY:-N/A}"
  echo -e "  ${BOLD}Region    :${NC} ${REGION:-N/A}"
  echo -e "  ${BOLD}Pays      :${NC} ${COUNTRY:-N/A}"
  echo -e "  ${BOLD}ISP/Org   :${NC} ${ORG:-N/A}"
  echo -e "  ${BOLD}Coords    :${NC} ${LOC:-N/A}"
  echo -e "  ${BOLD}Timezone  :${NC} ${TIMEZONE:-N/A}"
  echo -e "${CYAN}└─────────────────────────────────────────────${NC}"

  if [ -n "$LOC" ]; then
    LAT=$(echo "$LOC" | cut -d',' -f1)
    LON=$(echo "$LOC" | cut -d',' -f2)
    echo -e "\n  ${DIM}Google Maps : https://maps.google.com/?q=$LAT,$LON${NC}"
  fi
}

single_lookup() {
  echo -ne "${YELLOW}  IP ou domaine : ${NC}"; read TARGET
  [ -z "$TARGET" ] && echo -e "${RED}[X] Vide.${NC}" && return
  lookup_ip "$TARGET"
}

my_ip_lookup() {
  echo -e "\n${DIM}  Lookup de votre IP publique...${NC}"
  lookup_ip ""
}

bulk_lookup() {
  echo -ne "${YELLOW}  Fichier (une IP par ligne) : ${NC}"; read FILEPATH
  [ ! -f "$FILEPATH" ] && echo -e "${RED}[X] Fichier introuvable.${NC}" && return

  while IFS= read -r ip; do
    [ -z "$ip" ] && continue
    echo -e "\n${YELLOW}>>> $ip${NC}"
    lookup_ip "$ip"
    sleep 1  # evite le rate limit
  done < "$FILEPATH"
}

menu() {
  echo -e "${BOLD}${GREEN}  IP Geo Lookup :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Localiser une IP / domaine"
  echo -e "  ${CYAN}[2]${NC}  Localiser mon IP public"
  echo -e "  ${CYAN}[3]${NC}  Bulk lookup (fichier)"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[GEO]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) single_lookup ;;
    2) my_ip_lookup ;;
    3) bulk_lookup ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
