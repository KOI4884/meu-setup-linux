# 🐧 Setup Automático Pop!_OS (ThinkPad T460)

Este repositório contém o script de automação de pós-instalação (`setup-t460.sh`) desenvolvido para configurar rapidamente um ambiente de trabalho focado em **Cibersegurança**, **Infraestrutura** e **Desenvolvimento** no Pop!_OS (24.04 LTS).

## 🎯 Objetivo

O objetivo deste script é transformar uma instalação limpa do sistema em uma estação de trabalho completa em poucos minutos, automatizando o download de pacotes, configuração de permissões de usuário e otimização de gerenciamento de energia para o hardware do ThinkPad T460.

## 🛠️ Ferramentas e Tecnologias Instaladas

O script automatiza a instalação das seguintes categorias de ferramentas:

* **Segurança e Redes:** `nmap`, `wireshark`, `net-tools`, `gufw`.
* **Virtualização e Containers:** `virtualbox`, `docker.io`, `docker-compose` (Ideal para instanciar laboratórios de pentest e agentes locais de IA).
* **Desenvolvimento e Versionamento:** `git`, `python3-pip`, `curl`, `wget`.
* **Otimização de Hardware:** `tlp`, `powertop` (Configurados para otimizar o sistema Power Bridge e limitar a carga da bateria em 80%).
* **Utilitários Essenciais:** Google Chrome, AnyDesk, Bitwarden, Flameshot, Telegram.

## 🚀 Como Utilizar

Para executar este script na sua máquina, siga os passos abaixo no terminal:

1. Clone este repositório:
   ```bash
   git clone [https://github.com/SEU_USUARIO/meu-setup-linux.git](https://github.com/SEU_USUARIO/meu-setup-linux.git)
