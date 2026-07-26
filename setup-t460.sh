#!/usr/bin/env bash
#
# setup-t460.sh - Pós-instalação Pop!_OS para Cibersegurança e Infra
#

set -e

## URLS DE DOWNLOAD DIRETO
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_ANYDESK="https://download.anydesk.com/linux/anydesk_6.3.0-1_amd64.deb"

## DIRETÓRIOS
DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"
FILE="/home/$USER/.config/gtk-3.0/bookmarks"

# CORES PARA O TERMINAL
VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

# ------------------------------------------------------------------------ #

apt_update(){
  sudo apt update && sudo apt upgrade -y
}

testes_internet(){
if ! ping -c 1 8.8.8.8 -q &> /dev/null; then
  echo -e "${VERMELHO}[ERROR] - Sem conexão com a Internet.${SEM_COR}"
  exit 1
else
  echo -e "${VERDE}[INFO] - Conexão com a Internet OK.${SEM_COR}"
fi
}

travas_apt(){
  sudo rm -f /var/lib/dpkg/lock-frontend
  sudo rm -f /var/cache/apt/archives/lock
}

## PACOTES DO REPOSITÓRIO OFICIAL (O SEU ARSENAL)
PROGRAMAS_PARA_INSTALAR=(
  snapd # Gerenciador de pacotes Snap
  virtualbox
  virtualbox-ext-pack
  nmap
  wireshark
  net-tools
  docker.io
  docker-compose
  python3-pip
  git
  curl
  wget
  tlp
  powertop
  timeshift
  gufw
)

# ---------------------------------------------------------------------- #

install_debs(){
  echo -e "${VERDE}[INFO] - Baixando pacotes .deb (Chrome, AnyDesk)...${SEM_COR}"
  mkdir -p "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_GOOGLE_CHROME" -P "$DIRETORIO_DOWNLOADS"
  wget -c "$URL_ANYDESK"       -P "$DIRETORIO_DOWNLOADS"

  echo -e "${VERDE}[INFO] - Instalando pacotes .deb...${SEM_COR}"
  sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb || sudo apt --fix-broken install -y
}

install_apt_packages(){
  echo -e "${VERDE}[INFO] - Instalando ferramentas de Cyber, Infra e Dev...${SEM_COR}"
  for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
    if ! dpkg -l | grep -qw $nome_do_programa; then
      sudo apt install "$nome_do_programa" -y
    else
      echo "[INSTALADO] - $nome_do_programa"
    fi
  done
}

install_flatpaks(){
  echo -e "${VERDE}[INFO] - Instalando pacotes Flatpak essenciais...${SEM_COR}"
  flatpak install flathub org.flameshot.Flameshot -y
  flatpak install flathub com.bitwarden.desktop -y
  flatpak install flathub org.telegram.desktop -y
}

install_snaps(){
  echo -e "${VERDE}[INFO] - Instalando pacotes Snap...${SEM_COR}"
  # O core é fundamental para garantir o bom funcionamento de outros snaps
  sudo snap install core
  
  # Exemplo de instalação via Snap (remova o # se quiser instalar o Authy)
  # sudo snap install authy
}

# ----------------------------- CONFIGS EXTRAS ----------------------------- #

configuracoes_hardware(){
  echo -e "${VERDE}[INFO] - Aplicando otimizações para o ThinkPad T460...${SEM_COR}"
  
  # Adicionando seu usuário ao grupo do Docker e do VirtualBox
  sudo usermod -aG docker $USER
  sudo usermod -aG vboxusers $USER

  # Desativando o AnyDesk da inicialização automática
  sudo systemctl disable anydesk || true

  # Configurando o TLP para travar o carregamento em 80% (Power Bridge)
  sudo tlp start
  sudo tlp setthresholds 40 80 BAT0 || true
  sudo tlp setthresholds 40 80 BAT1 || true
}

extra_config(){
  echo -e "${VERDE}[INFO] - Criando pastas de trabalho...${SEM_COR}"
  mkdir -p /home/$USER/Projetos
  mkdir -p /home/$USER/VMs
  mkdir -p /home/$USER/Scripts

  if test -f "$FILE"; then
      echo "$FILE já existe"
  else
      touch /home/$USER/.config/gtk-3.0/bookmarks
  fi

  # Adiciona marcadores na barra lateral do gerenciador de arquivos
  echo "file:///home/$USER/Projetos 💻 Projetos" >> $FILE
  echo "file:///home/$USER/VMs 🖥️ VMs" >> $FILE
  echo "file:///home/$USER/Scripts 📜 Scripts" >> $FILE
}

system_clean(){
  echo -e "${VERDE}[INFO] - Limpando o sistema...${SEM_COR}"
  sudo apt autoclean -y
  sudo apt autoremove -y
}

# -------------------------------EXECUÇÃO----------------------------------------- #

testes_internet
travas_apt
apt_update
install_debs
install_apt_packages
install_flatpaks
install_snaps
configuracoes_hardware
extra_config
system_clean

echo -e "${VERDE}[INFO] - Instalação concluída com sucesso! Reinicie a máquina para aplicar os grupos de usuário.${SEM_COR}"
