#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH TOOLS — MENU PRINCIPAL  v2.0               ║
# ║   github.com/orlandotech2208-create/O-TECH-TOOLS    ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'; RED='\033[0;31m'; BLUE='\033[0;34m'
WHITE='\033[1;37m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/tools"

banner() {
  clear
  echo -e "${CYAN}"
  cat << 'EOF'
   ___        _____ _____ ____ _   _
  / _ \      |_   _| ____/ ___| | | |
 | | | |_____  | | |  _|| |   | |_| |
 | |_| |_____| | | | |__| |___|  _  |
  \___/        |_| |_____\____|_| |_|
EOF
  echo -e "${MAGENTA}         T O O L S   S U I T E  v2.0${NC}"
  echo -e "${DIM}${CYAN}      Security Tools for Termux | O-TECH Haiti${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${DIM}Author  : O-TECH (Orlando Tech)${NC}"
  echo -e "  ${DIM}GitHub  : github.com/orlandotech2208-create/O-TECH-TOOLS${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

menu() {
  echo -e "${BOLD}${WHITE}  [ NETWORK & RECON ]${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  ${BOLD}NMAP Wrapper${NC}          — Scanner de ports et services"
  echo -e "  ${CYAN}[2]${NC}  ${BOLD}Brute-Force UI${NC}        — Hydra wrapper SSH/FTP/HTTP"
  echo -e "  ${CYAN}[3]${NC}  ${BOLD}Net Info${NC}              — WHOIS / DNS / Headers / Traceroute"
  echo -e "  ${CYAN}[4]${NC}  ${BOLD}Port Checker${NC}          — Verifier si un port est ouvert"
  echo -e "  ${CYAN}[5]${NC}  ${BOLD}Subnet Scanner${NC}        — Scan rapide du reseau local"
  echo -e ""
  echo -e "${BOLD}${WHITE}  [ UTILITAIRES ]${NC}\n"
  echo -e "  ${CYAN}[6]${NC}  ${BOLD}Hash Generator${NC}        — Generer MD5 / SHA1 / SHA256"
  echo -e "  ${CYAN}[7]${NC}  ${BOLD}Password Generator${NC}    — Generer des mots de passe forts"
  echo -e "  ${CYAN}[8]${NC}  ${BOLD}Base64 Tool${NC}           — Encoder / Decoder Base64"
  echo -e "  ${CYAN}[9]${NC}  ${BOLD}IP Geo Lookup${NC}         — Localiser une IP (pays, ville, ISP)"
  echo -e ""
  echo -e "${BOLD}${WHITE}  [ SYSTEME ]${NC}\n"
  echo -e "  ${CYAN}[10]${NC} ${BOLD}Installer deps${NC}        — Installer tous les paquets requis"
  echo -e "  ${CYAN}[11]${NC} ${BOLD}System Info${NC}           — Info Termux, RAM, stockage"
  echo -e "  ${CYAN}[12]${NC} ${BOLD}A propos${NC}"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[O-TECH]> ${NC}"; read choice
}

install_all() {
  echo -e "\n${CYAN}[~] Installation des dependances O-TECH Tools...${NC}\n"
  pkg update -y
  pkg install -y git nmap hydra whois curl wget bind-tools traceroute openssl
  echo -e "\n${GREEN}[OK] Dependances installees !${NC}"
}

about() {
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BOLD}${YELLOW}  O-TECH TOOLS SUITE v2.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  Suite d'outils de securite reseau pour Termux"
  echo -e "  Concu par O-TECH Haiti — usage ethique uniquement"
  echo -e ""
  echo -e "  ${GREEN}Tools :${NC}"
  echo -e "  nmap-wrapper.sh   — Scans reseau (fixes v2)"
  echo -e "  brute-ui.sh       — Tests de force brute (fixes v2)"
  echo -e "  netinfo.sh        — Reconnaissance (fixes v2)"
  echo -e "  port-checker.sh   — Verification ports"
  echo -e "  subnet-scan.sh    — Scan reseau local"
  echo -e "  hash-tool.sh      — Hashing MD5/SHA1/SHA256"
  echo -e "  passgen.sh        — Generateur de mots de passe"
  echo -e "  base64-tool.sh    — Encodage/decodage"
  echo -e "  geo-lookup.sh     — Geolocalisation IP"
  echo -e "  sysinfo.sh        — Infos systeme Termux"
  echo -e ""
  echo -e "  ${YELLOW}[!] Testez uniquement vos propres systemes !${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

run_tool() {
  local script="$1"
  if [ -f "$script" ]; then
    chmod +x "$script"
    bash "$script"
  else
    echo -e "${RED}[X] Script introuvable : $script${NC}"
    echo -e "${DIM}    Verifie que le fichier est dans : $TOOLS_DIR${NC}"
  fi
}

# === MAIN ===
while true; do
  banner
  menu
  case $choice in
    0)  echo -e "\n${CYAN}[O-TECH] A+ bro.${NC}\n"; exit 0 ;;
    1)  run_tool "$TOOLS_DIR/nmap-wrapper.sh" ;;
    2)  run_tool "$TOOLS_DIR/brute-ui.sh" ;;
    3)  run_tool "$TOOLS_DIR/netinfo.sh" ;;
    4)  run_tool "$TOOLS_DIR/port-checker.sh" ;;
    5)  run_tool "$TOOLS_DIR/subnet-scan.sh" ;;
    6)  run_tool "$TOOLS_DIR/hash-tool.sh" ;;
    7)  run_tool "$TOOLS_DIR/passgen.sh" ;;
    8)  run_tool "$TOOLS_DIR/base64-tool.sh" ;;
    9)  run_tool "$TOOLS_DIR/geo-lookup.sh" ;;
    10) install_all ;;
    11) run_tool "$TOOLS_DIR/sysinfo.sh" ;;
    12) about ;;
    *)  echo -e "${RED}[X] Option invalide${NC}" ;;
  esac
  echo -e "\n${DIM}${CYAN}[Appuie ENTER pour revenir au menu...]${NC}"
  read
done
