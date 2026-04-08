#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH PASSWORD GENERATOR  v1.0                    ║
# ║   Generateur de mots de passe forts — bash natif    ║
# ╚══════════════════════════════════════════════════════╝

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${MAGENTA}"
  cat << 'EOF'
  ____   _    ____ ____
 |  _ \ / \  / ___/ ___|
 | |_) / _ \ \___ \___ \
 |  __/ ___ \ ___) |__) |
 |_| /_/   \_\____/____/
   G E N E R A T O R
EOF
  echo -e "${CYAN}  [ PASS GENERATOR ] ${YELLOW}O-TECH TOOLS v1.0${NC}"
  echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

generate_pass() {
  local length="$1"
  local chars="$2"
  # Utilise /dev/urandom (disponible sur Termux)
  tr -dc "$chars" < /dev/urandom 2>/dev/null | head -c "$length"
  echo ""
}

check_strength() {
  local pass="$1"
  local score=0
  local hints=""

  [ ${#pass} -ge 8 ]  && ((score++)) || hints+="  - Au moins 8 caracteres\n"
  [ ${#pass} -ge 12 ] && ((score++))
  [[ "$pass" =~ [A-Z] ]] && ((score++)) || hints+="  - Ajouter des majuscules\n"
  [[ "$pass" =~ [a-z] ]] && ((score++)) || hints+="  - Ajouter des minuscules\n"
  [[ "$pass" =~ [0-9] ]] && ((score++)) || hints+="  - Ajouter des chiffres\n"
  [[ "$pass" =~ [^a-zA-Z0-9] ]] && ((score++)) || hints+="  - Ajouter des symboles\n"

  echo -ne "  Force : "
  case $score in
    0|1|2) echo -e "${RED}[FAIBLE]${NC}" ;;
    3|4)   echo -e "${YELLOW}[MOYEN]${NC}" ;;
    5|6)   echo -e "${GREEN}[FORT]${NC}" ;;
  esac
  [ -n "$hints" ] && echo -e "${DIM}$hints${NC}"
}

gen_classic() {
  echo -ne "${YELLOW}  Longueur (defaut: 16) : ${NC}"; read LEN
  LEN=${LEN:-16}
  ! [[ "$LEN" =~ ^[0-9]+$ ]] && echo -e "${RED}[X] Invalide.${NC}" && return

  echo -e "\n${BOLD}  Mots de passe generes :${NC}\n"
  for i in 1 2 3 4 5; do
    PASS=$(generate_pass "$LEN" 'A-Za-z0-9!@#$%^&*()_+')
    echo -e "  ${CYAN}[$i]${NC} ${GREEN}$PASS${NC}"
  done

  echo -e ""
  echo -ne "${YELLOW}  Analyser la force du [1] ? (o/n) : ${NC}"; read CHK
  [[ "$CHK" == "o" || "$CHK" == "O" ]] && {
    FIRST=$(generate_pass "$LEN" 'A-Za-z0-9!@#$%^&*()')
    check_strength "$FIRST"
  }
}

gen_pin() {
  echo -ne "${YELLOW}  Longueur PIN (defaut: 6) : ${NC}"; read LEN
  LEN=${LEN:-6}
  echo -e "\n${BOLD}  PINs :${NC}\n"
  for i in 1 2 3 4 5; do
    echo -e "  ${CYAN}[$i]${NC} ${GREEN}$(generate_pass "$LEN" '0-9')${NC}"
  done
}

gen_memorable() {
  local WORDS=("cyber" "tech" "hack" "root" "dark" "net" "otech" "shell" "code" "pass"
               "haiti" "nord" "zero" "fire" "storm" "blade" "iron" "ghost" "nova" "flux")
  echo -e "\n${BOLD}  Mots de passe memorables :${NC}\n"
  for i in 1 2 3 4 5; do
    W1=${WORDS[$RANDOM % ${#WORDS[@]}]}
    W2=${WORDS[$RANDOM % ${#WORDS[@]}]}
    NUM=$((RANDOM % 999))
    SYM=$(echo '!@#$%^&*' | tr -d ' ' | head -c 1)
    echo -e "  ${CYAN}[$i]${NC} ${GREEN}${W1^}${W2^}${NUM}${SYM}${NC}"
  done
}

gen_analyze() {
  echo -ne "${YELLOW}  Mot de passe a analyser : ${NC}"; read PASS
  [ -z "$PASS" ] && echo -e "${RED}[X] Vide.${NC}" && return
  echo -e "\n  Mot de passe : ${DIM}$PASS${NC}"
  echo -e "  Longueur    : ${#PASS} caracteres"
  check_strength "$PASS"
}

menu() {
  echo -e "${BOLD}${GREEN}  Password Generator :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  Generer (alphanum + symboles)"
  echo -e "  ${CYAN}[2]${NC}  Generer un PIN numerique"
  echo -e "  ${CYAN}[3]${NC}  Generer memorable (mots + chiffres)"
  echo -e "  ${CYAN}[4]${NC}  Analyser la force d'un mot de passe"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[PASS]> ${NC}"; read choice
}

clear
banner
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    1) gen_classic ;;
    2) gen_pin ;;
    3) gen_memorable ;;
    4) gen_analyze ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
