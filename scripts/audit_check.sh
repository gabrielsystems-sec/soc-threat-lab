#!/bin/bash
LOG_FILE="/var/log/sysaudit/integrity.log"

echo "=========================================" >> $LOG_FILE
echo "ATIVIDADE DE AUDITORIA: $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG_FILE
echo "=========================================" >> $LOG_FILE

# 1. Checagem de integridade do passwd
echo "[+] Verificando Integridade do /etc/passwd:" >> $LOG_FILE
md5sum /etc/passwd >> $LOG_FILE

# 2. Monitoramento de armazenamento com Lógica de Alerta
DISK_USAGE=$(df -h / | tail -n 1 | awk '{print $5}' | tr -d '%')
DISK_AVAIL=$(df -h / | tail -n 1 | awk '{print $4}')

echo "[+] Espaço em Disco na Raiz (/): Usado: ${DISK_USAGE}% | Disponível: ${DISK_AVAIL}" >> $LOG_FILE

# No mundo real, definimos uma trigger (gatilho). Se o disco passar de 70% (seu caso é 77%):
if [ "$DISK_USAGE" -gt 70 ]; then
    echo "🚨 [ALERT] CRITICAL_RESOURCE_ALERT: Uso do disco ultrapassou o limite de segurança!" >> $LOG_FILE
else
    echo "[*] Status do recurso: SAUDÁVEL" >> $LOG_FILE
fi

echo -e "\n" >> $LOG_FILE
