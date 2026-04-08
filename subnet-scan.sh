#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH SUBNET SCANNER  v1.0                        ║
# ║   Scan reseau local via ping (pas besoin de nmap)    ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${CYAN}"
  cat << 'EOF'
  ____  _   _ ____  _   _ _____ _____
 / ___|| | | | __ )| \ | | ____|_   _|
 \___ \| | | |  _ \|  \| |  _|   | |
  ___) | |_| | |_) | |\  | |___  | |
 |____/ \___/|____/|_| \_|_____| |_|
EOF
  echo -e "${MAGENTA}  [ SUBNET SCANNER ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Detecte le subnet local automatiquement
get_local_subnet() {
  ip route 2>/dev/null | grep 'src' | head -1 | awk '{print $1}' \
    || echo "192.168.1"
}

# Ping scan — marche sans root, sans nmap
ping_scan() {
  local SUBNET="$1"
  local FOUND=0

  echo -e "${MAGENTA}[~] Scan du subnet ${SUBNET}.0/24...${NC}"
  echo -e "${DIM}  (Ctrl+C pour arreter)${NC}\n"

  for i in $(seq 1 254); do
    local IP="${SUBNET}.${i}"
    # -c 1 = 1 paquet, -W 1 = timeout 1s, -q = quiet
    if ping -c 1 -W 1 "$IP" &>/dev/null; then
      echo -e "  ${GREEN}[UP]  $IP${NC}"
      ((FOUND++))
    fi &
    # Limite la concurrence (50 pings en meme temps)
    [ $((i % 50)) -eq 0 ] && wait
  done
  wait

  echo -e "\n${CYAN}  Resultat : ${FOUND} host(s) actif(s) sur $SUBNET.0/24${NC}"
}

scan_auto() {
  local SUBNET
  SUBNET=$(get_local_subnet | sed 's|\.[0-9]*/.*||')
  echo -e "\n${DIM}  Subnet detecte : ${SUBNET}.0/24${NC}\n"
  ping_scan "$SUBNET"
}

scan_custom() {
  echo -ne "${YELLOW}  Subnet (ex: 192.168.1) : ${NC}"; read SUBNET
  [ -z "$SUBNET" ] && echo -e "${RED}[X] Vide.${NC}" && return
  ping_scan "$SUBNET"
}

menu() {
  echo -e "${BOLD}${GREEN}  Subnet Scanner :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Scan auto (reseau local detecte)"
  echo -e "  ${CYAN}[2]${NC}  Scan subnet custom"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[SCAN]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) scan_auto ;;
    2) scan_custom ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
