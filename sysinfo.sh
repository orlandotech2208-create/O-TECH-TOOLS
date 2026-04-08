#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH SYSINFO  v1.0                               ║
# ║   Infos systeme Termux / Android                     ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${YELLOW}"
  cat << 'EOF'
  ______   _______ _____  _   _ _____ ___
 / ___\ \ / / ____|_   _|| \ | |  ___/ _ \
 \___ \\ V /|  _|   | |  |  \| | |_ | | | |
  ___) || | | |___  | |  | |\  |  _|| |_| |
 |____/ |_| |_____| |_|  |_| \_|_|   \___/
EOF
  echo -e "${MAGENTA}  [ SYSTEM INFO ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

section() {
  echo -e "${CYAN}┌─ $1 ───────────────────────────────${NC}"
}

show_sysinfo() {
  section "SYSTEME"
  echo -e "  ${BOLD}OS         :${NC} $(uname -o 2>/dev/null || uname -s)"
  echo -e "  ${BOLD}Kernel     :${NC} $(uname -r)"
  echo -e "  ${BOLD}Arch       :${NC} $(uname -m)"
  echo -e "  ${BOLD}Hostname   :${NC} $(hostname 2>/dev/null || echo 'N/A')"
  echo -e "  ${BOLD}Shell      :${NC} $SHELL"
  echo -e "  ${BOLD}Uptime     :${NC} $(uptime -p 2>/dev/null || uptime | awk '{print $3,$4}' | sed 's/,//')"
  echo ""

  section "MEMOIRE"
  if [ -f /proc/meminfo ]; then
    local TOTAL FREE AVAIL USED
    TOTAL=$(grep MemTotal /proc/meminfo | awk '{printf "%.0fMB", $2/1024}')
    FREE=$(grep MemFree /proc/meminfo | awk '{printf "%.0fMB", $2/1024}')
    AVAIL=$(grep MemAvailable /proc/meminfo | awk '{printf "%.0fMB", $2/1024}')
    echo -e "  ${BOLD}RAM Total  :${NC} $TOTAL"
    echo -e "  ${BOLD}Libre      :${NC} $FREE"
    echo -e "  ${BOLD}Disponible :${NC} $AVAIL"
  else
    echo -e "  ${DIM}/proc/meminfo non accessible${NC}"
  fi
  echo ""

  section "STOCKAGE"
  df -h "$HOME" 2>/dev/null | tail -1 | awk '{
    printf "  Utilise    : %s / %s (%s)\n", $3, $2, $5
  }'
  echo ""

  section "RESEAU"
  echo -e "  ${BOLD}IP locale  :${NC} $(ip route get 1 2>/dev/null | grep src | awk '{print $7}' || echo 'N/A')"
  echo -e "  ${BOLD}IP publique:${NC} $(curl -s --max-time 5 https://api.ipify.org 2>/dev/null || echo 'N/A')"
  echo ""

  section "TERMUX"
  echo -e "  ${BOLD}Prefix     :${NC} ${PREFIX:-/data/data/com.termux/files/usr}"
  echo -e "  ${BOLD}Home       :${NC} $HOME"
  echo -e "  ${BOLD}Packages   :${NC} $(dpkg -l 2>/dev/null | grep '^ii' | wc -l) installes"
  echo -e "  ${BOLD}CPU        :${NC} $(nproc 2>/dev/null) coeurs"

  echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

clear
banner
show_sysinfo
echo -e "\n${DIM}  Appuie ENTER pour revenir...${NC}"
read
