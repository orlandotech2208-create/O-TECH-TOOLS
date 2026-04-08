#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH NETINFO  v2.0                               ║
# ║   Fix: dig -> nslookup fallback, traceroute fallback ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'; RED='\033[0;31m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${GREEN}"
  cat << 'EOF'
  _   _ _____ _____ ___ _   _ _____ ___
 | \ | | ____|_   _|_ _| \ | |  ___/ _ \
 |  \| |  _|   | |  | ||  \| | |_ | | | |
 | |\  | |___  | |  | || |\  |  _|| |_| |
 |_| \_|_____| |_| |___|_| \_|_|   \___/
EOF
  echo -e "${CYAN}  [ NET INFO ] ${YELLOW}O-TECH TOOLS v2.0${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Fix: installe bind-tools (pas dnsutils) pour avoir dig sur Termux
check_deps() {
  local MISS=()
  command -v whois &>/dev/null || MISS+=("whois")
  command -v curl &>/dev/null  || MISS+=("curl")
  # Sur Termux, dig vient de bind-tools
  if ! command -v dig &>/dev/null && ! command -v nslookup &>/dev/null; then
    MISS+=("bind-tools")
  fi
  if [ ${#MISS[@]} -gt 0 ]; then
    echo -e "${YELLOW}[!] Installation : ${MISS[*]}${NC}"
    pkg install "${MISS[@]}" -y
  fi
}

section() {
  echo -e "\n${CYAN}┌─ $1 ─────────────────────────────────${NC}"
}

menu() {
  echo -e "${BOLD}${GREEN}  Que veux-tu faire ?${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  WHOIS            (domaine ou IP)"
  echo -e "  ${CYAN}[2]${NC}  DNS Lookup       (A, MX, NS, TXT)"
  echo -e "  ${CYAN}[3]${NC}  HTTP Headers     (curl -I)"
  echo -e "  ${CYAN}[4]${NC}  Ping             (5 paquets)"
  echo -e "  ${CYAN}[5]${NC}  Traceroute"
  echo -e "  ${CYAN}[6]${NC}  Mon IP public"
  echo -e "  ${CYAN}[7]${NC}  Tout en un       (WHOIS + DNS + Headers)"
  echo -e "  ${CYAN}[8]${NC}  SSL/TLS Info     (certificat HTTPS)"
  echo -e "  ${CYAN}[9]${NC}  Sous-domaines    (recherche passive)"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[NETINFO]> ${NC}"; read choice
}

get_target() {
  echo -ne "${YELLOW}  Domaine ou IP : ${NC}"; read TARGET
  [ -z "$TARGET" ] && echo -e "${RED}[X] Vide !${NC}" && return 1
}

# Fix: utilise nslookup si dig indisponible
do_dns_lookup() {
  local host="$1" type="$2"
  if command -v dig &>/dev/null; then
    dig +short "$type" "$host" 2>/dev/null
  else
    nslookup -type="$type" "$host" 2>/dev/null | grep -v "^;" | grep -v "^$"
  fi
}

do_whois() {
  section "WHOIS — $TARGET"
  if command -v whois &>/dev/null; then
    whois "$TARGET" 2>&1 | grep -v "^%" | head -50
  else
    echo -e "${RED}[X] whois non installe. Lance : pkg install whois${NC}"
  fi
}

do_dns() {
  section "DNS — $TARGET"
  echo -e "${YELLOW}  [A]${NC}"; do_dns_lookup "$TARGET" A
  echo -e "${YELLOW}  [MX]${NC}"; do_dns_lookup "$TARGET" MX
  echo -e "${YELLOW}  [NS]${NC}"; do_dns_lookup "$TARGET" NS
  echo -e "${YELLOW}  [TXT]${NC}"; do_dns_lookup "$TARGET" TXT
  echo -e "${YELLOW}  [AAAA]${NC}"; do_dns_lookup "$TARGET" AAAA
}

do_headers() {
  section "HTTP Headers — $TARGET"
  # Fix: essaie HTTPS puis HTTP, affiche status code
  echo -e "${DIM}  Tentative HTTPS...${NC}"
  RESULT=$(curl -sI --max-time 10 "https://$TARGET" 2>&1)
  if [ -z "$RESULT" ]; then
    echo -e "${DIM}  Tentative HTTP...${NC}"
    RESULT=$(curl -sI --max-time 10 "http://$TARGET" 2>&1)
  fi
  echo -e "${GREEN}$RESULT${NC}"
}

do_ping() {
  section "PING — $TARGET"
  ping -c 5 "$TARGET" 2>&1
}

# Fix: traceroute -> utilise tracepath si traceroute absent (Termux)
do_trace() {
  section "TRACEROUTE — $TARGET"
  if command -v traceroute &>/dev/null; then
    traceroute -m 15 "$TARGET" 2>&1
  elif command -v tracepath &>/dev/null; then
    echo -e "${DIM}  traceroute absent, utilise tracepath...${NC}"
    tracepath "$TARGET" 2>&1
  else
    echo -e "${YELLOW}[~] Installation traceroute...${NC}"
    pkg install traceroute -y && traceroute -m 15 "$TARGET" 2>&1
  fi
}

do_myip() {
  section "MON IP PUBLIC"
  echo -ne "${CYAN}  IPv4 : ${NC}"
  curl -s --max-time 8 https://api.ipify.org 2>/dev/null || echo "N/A"
  echo -ne "\n${CYAN}  IPv6 : ${NC}"
  curl -s --max-time 8 https://api6.ipify.org 2>/dev/null || echo "N/A"
  echo ""
}

do_ssl() {
  section "SSL/TLS — $TARGET"
  echo -e "${DIM}  Recuperation certificat...${NC}"
  echo | timeout 8 openssl s_client -connect "$TARGET:443" -servername "$TARGET" 2>/dev/null \
    | openssl x509 -noout -text 2>/dev/null \
    | grep -E "Subject:|Issuer:|Not Before|Not After|DNS:" \
    || echo -e "${RED}[X] Impossible de recuperer le certificat SSL.${NC}"
}

do_subdomains() {
  section "SOUS-DOMAINES PASSIFS — $TARGET"
  echo -e "${DIM}  Recherche via crt.sh...${NC}"
  curl -s "https://crt.sh/?q=%25.$TARGET&output=json" 2>/dev/null \
    | tr ',' '\n' \
    | grep '"name_value"' \
    | sed 's/.*"name_value":"\(.*\)".*/\1/' \
    | sort -u \
    | head -30 \
    || echo -e "${RED}[X] Echec de la requete crt.sh.${NC}"
}

# === MAIN ===
clear
banner
check_deps
while true; do
  echo ""
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) get_target && do_whois ;;
    2) get_target && do_dns ;;
    3) get_target && do_headers ;;
    4) get_target && do_ping ;;
    5) get_target && do_trace ;;
    6) do_myip ;;
    7) get_target && do_whois && do_dns && do_headers ;;
    8) get_target && do_ssl ;;
    9) get_target && do_subdomains ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
