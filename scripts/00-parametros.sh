#!/bin/bash
# Autor: Edson Andrade
# Github: https://github.com/EdsonAndrade-tech
# Data de criação: 02/09/2022
# Data de atualização: 
# Versão: 0.01
# Ubuntu Server 20.04.x LTS x64 
#============================================================================================#

#				VARIÁVEIS GLOBAIS UTILIZADAS EM TODOS OS SCRIPTS                       

# Calcular o tempo de execução do script
HORAINICIAL=$(date +%T)

# Verificando se o usuário é "Root" e versão do Ubuntu 
USUARIO=$(id -u)
UBUNTU=$(lsb_release -rs)

# Variável do Caminho e Nome do arquivo de Log utilizado em todos os script
LOGSCRIPT="/var/log/$(echo $0 | cut -d'/' -f2)"

# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração e
# nenhuma interação durante a instalação ou atualização do sistema via Apt ou Apt-Get
export DEBIAN_FRONTEND="noninteractive"
#============================================================================================#

#				VARIÁVEIS DE REDE DO SERVIDOR UTILIZADAS EM TODOS OS SCRIPTS  

# Variável do Usuário padrão utilizado no Servidor Ubuntu
USUARIODEFAULT="andrade"

# Variável da Senha padrão utilizado no Servidor Ubuntu
SENHADEFAULT="adr@2021"

# Variável do Nome (Hostname) do Servidor Ubuntu 
NOMESERVER="srvapsws01"

# Variável do Nome de Domínio do Servidor Ubuntu
DOMINIOSERVER="arena.intra"

# Variável do Nome de Domínio NetBIOS do Servidor Ubuntu
# OBSERVAÇÃO IMPORTANTE: essa variável será utilizada em outras variáveis
DOMINIONETBIOS="$(echo $DOMINIOSERVER | cut -d'.' -f1)"
#
# Variável do Nome (Hostname) FQDN (Fully Qualified Domain Name) do Servidor Ubuntu
# OBSERVAÇÃO IMPORTANTE: essa variável será utilizada em outras variáveis
FQDNSERVER="$NOMESERVER.$DOMINIOSERVER"
#
# Variável do Endereço IPv4 principal (padrão) do Servidor Ubuntu
IPV4SERVER="172.16.10.20"
#
# Variável do Nome da Interface Lógica do Servidor Ubuntu Server
# CUIDADO!!! o nome da interface de rede pode mudar dependendo da instalação do Ubuntu Server,.
INTERFACE="ens18"
#
# Variável do arquivo de configuração da Placa de Rede do Netplan do Servidor Ubuntu
NETPLAN="/etc/netplan/00-installer-config.yaml"
#===========================================================================================#

#				VARIÁVEIS UTILIZADAS NO SCRIPT: 01-openssh.sh                     
#
#	Arquivos de configuração (conf) do Serviço de Rede OpenSSH utilizados nesse script
# 		01. /etc/netplan/00-installer-config.yaml = arquivo de configuração da placa de rede
# 		02. /etc/hostname = arquivo de configuração do Nome FQDN do Servidor
# 		03. /etc/hosts = arquivo de configuração da pesquisa estática para nomes de host local
# 		04. /etc/nsswitch.conf = arquivo de configuração do switch de serviço de nomes de serviço
# 		05. /etc/ssh/sshd_config = arquivo de configuração do Servidor OpenSSH
# 		06. /etc/hosts.allow = arquivo de configuração de liberação de hosts por serviço de rede
# 		07. /etc/hosts.deny = arquivo de configuração de negação de hosts por serviço de rede
# 		08. /etc/issue.net = arquivo de configuração do Banner utilizado pelo OpenSSH no login
# 		09. /etc/default/shellinabox = arquivo de configuração da aplicação Shell-In-a-Box
# 		10. /etc/neofetch/config.conf = arquivo de configuração da aplicação Neofetch
# 		11. /etc/cron.d/neofetch-cron = arquivo de atualização do Banner Motd o Neofetch
# 		12. /etc/motd = arquivo de mensagem do dia gerado pelo Neofetch utilizando o CRON
# 		13. /etc/rsyslog.d/50-default.conf = arquivo de configuração do Syslog/Rsyslog
#
# 	Arquivos de monitoramento (log) do Serviço de Rede OpenSSH Server utilizados nesse script
# 		01. systemctl status ssh = status do serviço do OpenSSH
# 		02. journalctl -t sshd = todas as mensagens referente ao serviço do OpenSSH
# 		03. tail -f /var/log/syslog | grep sshd = filtrando as mensagens do serviço do OpenSSH
# 		04. tail -f /var/log/auth.log | grep ssh = filtrando as mensagens de autenticação do OpenSSH
# 		05. tail -f /var/log/tcpwrappers-allow-ssh.log = filtrando as conexões permitidas do OpenSSH
# 		06. tail -f /var/log/tcpwrappers-deny.log = filtrando as conexões negadas do OpenSSH
# 		07. tail -f /var/log/cron.log = filtrando as mensagens do serviço do CRON
#
# Variável das dependências do laço de loop do OpenSSH Server
SSHDEP="openssh-server openssh-client"

# Variável de instalação dos softwares extras do OpenSSH Server
SSHINSTALL="net-tools traceroute ipcalc nmap tree pwgen neofetch shellinabox"

# Variável da porta de conexão padrão do OpenSSH Server
PORTSSH="22"

# Variável da porta de conexão padrão do Shell-In-a-Box
PORTSHELLINABOX="4200"