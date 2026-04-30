#!/bin/bash
# =================================================================
# SCRIPT DE REMEDIAÇÃO AUTOMATIZADA - PCI DSS 10.6.1
# Autor: Gabriel (gabrielrsec)
# Objetivo: Desativar IP Forwarding e garantir persistência.
# =================================================================

LOG_FILE="/var/log/hardening_remediation.log"

echo "[$(date)] Iniciando aplicação de hardening..." | tee -a $LOG_FILE

# 1. REMEDIAÇÃO EM TEMPO REAL
# O sysctl -w aplica a mudança IMEDIATAMENTE no Kernel.
# net.ipv4.ip_forward = 0 desativa o roteamento de pacotes entre interfaces.
sudo sysctl -w net.ipv4.ip_forward=0 | tee -a $LOG_FILE

# 2. GARANTIA DE PERSISTÊNCIA (PÓS-REBOOT)
# Verificamos se a linha já existe no sysctl.conf para não duplicar.
if grep -q "net.ipv4.ip_forward" /etc/sysctl.conf; then
    # sed -i 's/antigo/novo/' faz a troca da linha inteira no arquivo original.
    sudo sed -i 's/net.ipv4.ip_forward.*/net.ipv4.ip_forward = 0/' /etc/sysctl.conf
else
    # Se não existir, o echo >> adiciona a linha ao final do arquivo.
    echo "net.ipv4.ip_forward = 0" | sudo tee -a /etc/sysctl.conf
fi

# 3. RECARREGAR CONFIGURAÇÕES
sudo sysctl -p | tee -a $LOG_FILE

echo "[$(date)] Hardening concluído com sucesso!" | tee -a $LOG_FILE
