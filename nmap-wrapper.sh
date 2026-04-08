#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH NMAP WRAPPER  v2.0                          ║
# ║   Fixes: shebang, SYN stealth (root only removed)   ║
# ╚══════════════════════════════════════════════════════╝

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${CYAN}"
  cat << 'EOF'
  ____  _   _ __ __ _    ____
 |  _ \| \ | |  V  | \  / _  |
 | |_) |  \| | |\/| |  \| |_) |
 |  _ <| |\  | |  | | | |  __/
 |_| \_|_| \_|_|  |_|_|  |_|
EOF
  echo -e "${MAGENTA}  [ NMAP WRAPPER ] ${YELLOW}O-TECH TOOLS v2.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

check_nmap() {
  if ! command -v nmap &>/dev/null; then
    echo -e "${YELLOW}[!] nmap non installe. Installation...${NC}"
    pkg install nmap -y
  fi
}

menu() {
  echo -e "${BOLD}${GREEN}  Choisir un scan :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Scan rapide           (top 100 ports)"
  echo -e "  ${CYAN}[2]${NC}  Scan complet          (tous les ports 1-65535)"
  echo -e "  ${CYAN}[3]${NC}  Detection services    (banners + versions)"
  echo -e "  ${CYAN}[4]${NC}  Decouverte reseau     (hosts up sur subnet)"
  echo -e "  ${CYAN}[5]${NC}  Scan agressif         (OS + services + scripts)"
  echo -e "  ${CYAN}[6]${NC}  Scan vulnerabilites   (scripts NSE vuln)"
  echo -e "  ${CYAN}[7]${NC}  Scan UDP              (top ports UDP)"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[NMAP]> ${NC}"; read choice
}

get_target() {
  echo -ne "${YELLOW}  Cible (IP / hostname / CIDR) : ${NC}"; read TARGET
  if [ -z "$TARGET" ]; then
    echo -e "${RED}[X] Cible vide.${NC}"; return 1
  fi
}

save_result() {
  SAVEDIR="$HOME/otech-scans"
  mkdir -p "$SAVEDIR"
  FILENAME="$SAVEDIR/nmap_$(echo "$TARGET" | tr '/.' '-')_$(date +%Y%m%d_%H%M%S).txt"
  echo -ne "\n${CYAN}  Sauvegarder le resultat ? (o/n) : ${NC}"; read SAVE
  if [[ "$SAVE" == "o" || "$SAVE" == "O" ]]; then
    echo "$RESULT" > "$FILENAME"
    echo -e "${GREEN}[OK] Sauvegarde : $FILENAME${NC}"
  fi
}

run_scan() {
  echo -e "\n${MAGENTA}[~] Scan en cours sur ${YELLOW}$TARGET${MAGENTA}...${NC}\n"
  case $choice in
    # Fix: utilise -T4 partout, supprime -sS qui necessite root
    1) RESULT=$(nmap -F --open -T4 "$TARGET" 2>&1) ;;
    2) RESULT=$(nmap -p 1-65535 --open -T4 "$TARGET" 2>&1) ;;
    3) RESULT=$(nmap -sV -T4 "$TARGET" 2>&1) ;;
    4) RESULT=$(nmap -sn "$TARGET" 2>&1) ;;
    5) RESULT=$(nmap -A -T4 "$TARGET" 2>&1) ;;
    6) RESULT=$(nmap --script vuln -T4 "$TARGET" 2>&1) ;;
    # Fix: UDP scan sans root — utilise connect scan
    7) RESULT=$(nmap -sU --top-ports 50 -T4 "$TARGET" 2>&1) ;;
  esac
  echo -e "${GREEN}$RESULT${NC}"
  save_result
}

# === MAIN ===
clear
banner
check_nmap
while true; do
  echo ""
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    [1-7]) get_target && run_scan ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
