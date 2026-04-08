# O-TECH TOOLS — [orlandotech2208-create/O-TECH-TOOLS](https://github.com/orlandotech2208-create/O-TECH-TOOLS)

```
   ___        _____ _____ ____ _   _
  / _ \      |_   _| ____/ ___| | | |
 | | | |_____  | | |  _|| |   | |_| |
 | |_| |_____| | | | |__| |___|  _  |
  \___/        |_| |_____\____|_| |_|
  T O O L S   S U I T E   v2.0
```

![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Termux](https://img.shields.io/badge/Termux-000000?style=for-the-badge&logo=android&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)

---

## Tools inclus

| Script | Description |
|--------|-------------|
| `otech.sh` | Menu principal — launcher de tous les tools |
| `tools/nmap-wrapper.sh` | Wrapper nmap — 7 modes de scan (v2: fixes root, shebang) |
| `tools/brute-ui.sh` | Brute-force UI Hydra — SSH/FTP/HTTP/MySQL/SMTP (v2: fixes wordlist) |
| `tools/netinfo.sh` | Reconnaissance reseau — WHOIS/DNS/Headers/SSL (v2: dig fallback) |
| `tools/port-checker.sh` | Verification port ouvert via bash natif — sans nmap |
| `tools/subnet-scan.sh` | Scan reseau local via ping — sans nmap, sans root |
| `tools/hash-tool.sh` | Generateur MD5 / SHA1 / SHA256 / SHA512 |
| `tools/passgen.sh` | Generateur mots de passe forts + analyseur |
| `tools/base64-tool.sh` | Encodage / decodage Base64 |
| `tools/geo-lookup.sh` | Geolocalisation IP (ipinfo.io) |
| `tools/sysinfo.sh` | Infos systeme Termux / Android |

---

## Installation rapide

```bash
git clone https://github.com/orlandotech2208-create/O-TECH-TOOLS
cd O-TECH-TOOLS
chmod +x otech.sh tools/*.sh
bash otech.sh
```

---

## Dependances

```bash
pkg update && pkg install git nmap hydra whois curl wget bind-tools traceroute openssl -y
```

---

## Details des tools

### NMAP Wrapper (v2 — fixes)
7 modes de scan disponibles :
- Scan rapide (top 100 ports)
- Scan complet (ports 1-65535)
- Detection versions/services (banners)
- Decouverte hosts sur reseau local
- Scan agressif (OS + services + scripts)
- Scan vulnerabilites (scripts NSE)
- Scan UDP (top 50 ports)

Correction v2 : suppression du scan SYN Stealth (-sS) qui necessite root, shebang corrige pour Termux.

---

### Brute-Force UI (v2 — fixes)
Wrapper Hydra pour :
- SSH
- FTP
- HTTP POST (formulaires)
- MySQL
- Telnet
- SMTP

Correction v2 : recherche automatique de rockyou.txt dans plusieurs paths Termux, verification hydra avant lancement, shebang corrige.

---

### Net Info (v2 — fixes)
Reconnaissance complete :
- WHOIS (domaine/IP)
- DNS Lookup (A, MX, NS, TXT, AAAA) — fallback nslookup si dig absent
- HTTP Headers (curl -I)
- Ping rapide
- Traceroute — fallback tracepath si traceroute absent
- IP publique (IPv4 + IPv6)
- SSL/TLS info (certificat HTTPS)
- Sous-domaines passifs (crt.sh)

Correction v2 : `dig` remplace par `nslookup` en fallback (Termux utilise `bind-tools` et non `dnsutils`), `tracepath` en fallback, shebang corrige.

---

### Port Checker
- Verification port unique
- Scanner une plage de ports
- Scanner les ports communs (21, 22, 80, 443, 3306...)
- Fonctionne via `/dev/tcp` bash natif — pas besoin de nmap

---

### Subnet Scanner
- Detection automatique du subnet local
- Ping sweep sans nmap, sans root
- Scan concurrent (50 pings en parallele)

---

### Hash Tool
- Hash texte et fichiers (MD5, SHA1, SHA256, SHA512)
- Verification/comparaison de hash
- 100% bash natif — pas de dependance externe

---

### Password Generator
- Alphanum + symboles (longueur personnalisable)
- PIN numerique
- Memorable (mots + chiffres + symboles)
- Analyseur de force de mot de passe
- Source entropique : `/dev/urandom`

---

### Base64 Tool
- Encoder / decoder texte
- Encoder / decoder fichier
- 100% bash natif

---

### IP Geo Lookup
- Lookup IP unique ou domaine
- Lookup de sa propre IP publique
- Bulk lookup (fichier)
- API : ipinfo.io (gratuit, sans cle)
- Affichage : ville, region, pays, ISP, coords, timezone, lien Google Maps

---

### System Info
- OS, kernel, architecture, hostname
- RAM (total, libre, disponible)
- Stockage
- IP locale et publique
- Info Termux (prefix, home, packages installes)

---

## Disclaimer

> Ces outils sont destines a un usage ethique uniquement.
> Teste uniquement sur tes propres systemes ou avec autorisation explicite.
> O-TECH decline toute responsabilite pour un usage malveillant.

---

## Contact

**O-TECH (Orlando Tech)**
GitHub : [orlandotech2208-create](https://github.com/orlandotech2208-create)
