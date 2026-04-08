#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH PORT CHECKER  v1.0                          ║
# ║   Verification port ouvert via /dev/tcp (no nmap)   ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${CYAN}"
  cat << 'EOF'
  ____   ___  ____ _____
 |  _ \ / _ \|  _ \_   _|
 | |_) | | | | |_) || |
 |  __/| |_| |  _ < | |
 |_|    \___/|_| \_\|_|
   C H E C K E R
EOF
  echo -e "${MAGENTA}  [ PORT CHECKER ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Fonction principale : check via /dev/tcp (bash natif, pas besoin de nmap)
check_port() {
  local host="$1" port="$2" timeout=3
  (echo >/dev/tcp/"$host"/"$port") 2>/dev/null &
  local pid=$!
  sleep "$timeout"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null
    return 1  # timeout = closed
  fi
  wait "$pid" 2>/dev/null
  return $?
}

scan_single() {
  echo -ne "${YELLOW}  Hote cible : ${NC}"; read HOST
  [ -z "$HOST" ] && echo -e "${RED}[X] Vide.${NC}" && return
  echo -ne "${YELLOW}  Port : ${NC}"; read PORT
  [ -z "$PORT" ] && echo -e "${RED}[X] Vide.${NC}" && return

  echo -e "\n${DIM}  Verification ${HOST}:${PORT}...${NC}"
  if check_port "$HOST" "$PORT"; then
    echo -e "  ${GREEN}[OPEN]  ${HOST}:${PORT}${NC}"
  else
    echo -e "  ${RED}[CLOSED] ${HOST}:${PORT}${NC}"
  fi
}

scan_range() {
  echo -ne "${YELLOW}  Hote cible : ${NC}"; read HOST
  [ -z "$HOST" ] && echo -e "${RED}[X] Vide.${NC}" && return
  echo -ne "${YELLOW}  Port debut : ${NC}"; read P1
  echo -ne "${YELLOW}  Port fin   : ${NC}"; read P2

  if ! [[ "$P1" =~ ^[0-9]+$ && "$P2" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}[X] Ports invalides.${NC}"; return
  fi

  echo -e "\n${MAGENTA}[~] Scan $HOST ports $P1-$P2...${NC}"
  echo -e "${DIM}  (Ctrl+C pour arreter)${NC}\n"

  local open_count=0
  for port in $(seq "$P1" "$P2"); do
    if check_port "$HOST" "$port"; then
      echo -e "  ${GREEN}[OPEN]  port $port${NC}"
      ((open_count++))
    fi
  done
  echo -e "\n${CYAN}  Resultat : ${open_count} port(s) ouvert(s)${NC}"
}

scan_common() {
  echo -ne "${YELLOW}  Hote cible : ${NC}"; read HOST
  [ -z "$HOST" ] && echo -e "${RED}[X] Vide.${NC}" && return

  # Ports les plus communs
  local PORTS=(21 22 23 25 53 80 110 143 443 445 3306 3389 5432 6379 8080 8443 27017)
  local NAMES=(FTP SSH Telnet SMTP DNS HTTP POP3 IMAP HTTPS SMB MySQL RDP PostgreSQL Redis HTTP-Alt HTTPS-Alt MongoDB)

  echo -e "\n${MAGENTA}[~] Scan ports communs sur $HOST...${NC}\n"

  for i in "${!PORTS[@]}"; do
    port="${PORTS[$i]}"
    name="${NAMES[$i]}"
    if check_port "$HOST" "$port"; then
      echo -e "  ${GREEN}[OPEN]   ${port}/tcp  ${name}${NC}"
    else
      echo -e "  ${DIM}${RED}[CLOSED] ${port}/tcp  ${name}${NC}"
    fi
  done
}

menu() {
  echo -e "${BOLD}${GREEN}  Port Checker :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Verifier un port unique"
  echo -e "  ${CYAN}[2]${NC}  Scanner une plage de ports"
  echo -e "  ${CYAN}[3]${NC}  Scanner les ports communs (21,22,80,443...)"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[PORT]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) scan_single ;;
    2) scan_range ;;
    3) scan_common ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
