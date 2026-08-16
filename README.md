# SOC & Defensive Security Infrastructure 🛡️

Laboratório de **monitoramento defensivo, detecção de ameaças e resposta a incidentes** utilizando Wazuh, Suricata e automações de segurança.

O projeto documenta a construção de um ambiente de Blue Team com centralização de logs, avaliação de segurança, detecção de atividades suspeitas, enriquecimento de alertas e resposta automatizada.

| Categoria | Tecnologias | Status |
| :--- | :--- | :--- |
| **SIEM/XDR** | Wazuh Manager, Indexer e Dashboard | ✅ Operacional |
| **Detecção** | Suricata, Wazuh Agent, FIM | ✅ Validado |
| **Threat Intelligence** | VirusTotal, AbuseIPDB | ✅ Integrado |
| **Resposta** | Active Response, Firewall | ✅ Automatizado |
| **Notificação** | Telegram Bot | ✅ Integrado |

---

## 🎯 Objetivo Técnico

Construir um ambiente de segurança capaz de centralizar eventos, identificar comportamentos suspeitos e reduzir o tempo entre a detecção e a resposta a incidentes.

O laboratório também explora troubleshooting de agentes, pipelines de logs, configurações do Wazuh, hardening e automação de respostas defensivas.

---

## 📁 1. Implantação e Conectividade do Wazuh

### Contexto do Problema
O agente aparecia como desconectado no Dashboard mesmo com a conectividade de rede disponível, comprometendo a coleta de eventos do host.

### Troubleshooting e Resolução
* **Causa Raiz:** O Agent estava na versão `4.14`, enquanto o Manager utilizava a versão `4.10`.
* **Resolução:** Padronização das versões, ajustes no `ossec.conf` e validação da autenticação via `authd`.

### Evidência Técnica
<details>
<summary>📂 Clique para ver o Deploy e Troubleshooting</summary>

* **Estrutura do Host:** ![Setup](./docs/assets/01-agent-inventory-host.png)
* **Erro de Version Mismatch:** ![Erro Handshake](./docs/assets/03-troubleshooting-version-mismatch.png)
* **Comunicação Restabelecida:** ![Conexão OK](./docs/assets/02-ubuntu-agent-deployment.png)
* **Transferência via SCP:** ![SCP Transfer](./docs/assets/scp-transfer-success-ubuntu-agent.png)

</details>

---

## 📁 2. Avaliação de Segurança e Hardening

### Contexto do Problema
Identificar configurações inseguras, serviços desnecessários e falhas de compliance que poderiam aumentar a superfície de ataque.

### Estratégia Aplicada
Uso do **Security Configuration Assessment (SCA)** do Wazuh para avaliar o host com base em políticas de segurança. Durante o processo, erros de permissão na leitura de logs foram investigados e corrigidos.

### Evidência Técnica
<details>
<summary>📂 Clique para ver a Auditoria de Segurança</summary>

* **Falhas de Compliance:** ![SCA Diagnóstico](./docs/assets/02-hardening-audit-sca.png)
* **Troubleshooting de Permissões:** ![Correção de Permissão](./docs/assets/bash-permission-denied-remediation-log.png)
* **Hardening Aplicado:** ![Hardening OK](./docs/assets/sudo-bash-hardening-success-ubuntu-compliance.png)

</details>

---

## 📁 3. Detecção de Intrusão em Tempo Real

### Estratégia de Defesa
Implementação de duas camadas complementares de monitoramento:

* **NIDS:** Suricata para análise do tráfego de rede.
* **HIDS:** Wazuh Agent para monitoramento de arquivos e logs de autenticação.

### Evidência Técnica
<details>
<summary>📂 Clique para ver a Detecção</summary>

* **Detecção de Rede:** ![NIDS Rede](./docs/assets/03-nids-detection-network.png)
* **Detecção de Brute Force:** ![HIDS Autenticação](./docs/assets/04-hids-detection-auth.png)

</details>

---

## 📁 4. Resposta Ativa e Inteligência de Ameaças

### Contexto do Problema
Automatizar a resposta a eventos críticos para reduzir o tempo de exposição durante incidentes.

### Troubleshooting e Resolução
Durante a configuração das integrações, o Wazuh Manager deixou de iniciar.

* **Causa Raiz:** Caracteres invisíveis no `ossec.conf` e tags obsoletas na configuração.
* **Resolução:** Limpeza da configuração via `sed`, correção do bloco `<integration>` e validação com `wazuh-analysisd -t`.

### Evidência Técnica
<details>
<summary>📂 Clique para ver a Automação e Integrações</summary>

* **Fluxo de Alerta:** ![Alerta](./docs/assets/wazuh-integration-virustotal-telegram-alert.png)
* **Investigação do ossec.conf:** ![Configuração](./docs/assets/ossec-conf-xml-syntax-conflict.png)
* **Erro de Parsing XML:** ![Análise XML](./docs/assets/wazuh-xml-parsing-error-investigation.png)
* **Parâmetro Inválido:** ![Tag Inválida](./docs/assets/wazuh-invalid-parameter-detection.png)

</details>

---

## 📁 5. Simulação de Ameaças e Detecção de Ataques

### Contexto do Problema
Validar a capacidade do ambiente de detectar e responder a comportamentos ofensivos simulados.

### Testes Realizados
* Simulação de injeção SQL contra DVWA.
* Tentativas de força bruta utilizando Hydra.
* Automação de tarefas de verificação via Crontab.
* Validação da Active Response bloqueando automaticamente o IP identificado.

### Evidência Técnica
<details>
<summary>📂 Clique para ver as Simulações</summary>

* **Correlação de Ataque Web:** ![Ataque Web](./docs/assets/wazuh-threat_intel-web_attack_correlation.png)
* **Alerta de Hydra no Telegram:** ![Notificação](./docs/assets/hydra-attack-wazuh-alert-telegram.png)
* **Automação via Crontab:** ![Cron](./docs/assets/crontab-active-scheduled_tasks_automation.png)

</details>

---

## 📁 6. Ingestão de Logs AWS e Tuning de Alertas

### Contexto do Problema
Integrar eventos de ambiente AWS ao pipeline de monitoramento e reduzir alertas que não exigiam ação operacional.

### Troubleshooting e Ajustes
* **Pipeline:** Migração para Filebeat devido a limitações encontradas durante a ingestão.
* **Tuning:** Ajustes no `local_rules.xml` para reduzir *alert fatigue*.

### Evidência Técnica
<details>
<summary>📂 Clique para ver a Ingestão e o Tuning</summary>

* **Troubleshooting do Pipeline:** ![Debug](./docs/assets/wazuh-modulesd-debug-troubleshooting.png)
* **Ingestão de Logs AWS:** ![Ingestão OK](./docs/assets/filebeat-ingestion-success-aws-logs.png)
* **Tuning de Alertas:** ![Tuning](./docs/assets/wazuh-alert-tuning-success.png)
* **Resposta Assistida por IA:** ![Resposta IA](./docs/assets/wazuh-ai-incident-response-telegram-alert.png)

</details>

---

## 📁 7. Honeypot, Rede e Manutenção

### Estratégia Aplicada
Configuração de uma DMZ para o honeypot **Cowrie**, validação da conectividade da rede e automações de manutenção para evitar problemas de armazenamento.

### Evidência Técnica
<details>
<summary>📂 Clique para ver Honeypot e Operações</summary>

* **Conectividade da DMZ:** ![Netplan](./docs/assets/netplan-success-honeypot_dmz.png)
* **Deploy do Cowrie:** ![Honeypot](./docs/assets/infra-hardening-docker_honeypot_complete.png)
* **Ataque SSH Interceptado:** ![SSH](./docs/assets/ssh-intercepted-cowrie_dmz.png)
* **Persistência do SSH:** ![Socket SSH](./docs/assets/systemctl-active-ssh_socket_port_22222.png)
* **Backup Distribuído:** ![Backup](./docs/assets/tar-cp-success-distributed_wazuh_backup.png)
* **Troubleshooting de NAT:** ![NAT](./docs/assets/pfsense-troubleshooting-nat_timeout.png)

</details>

---

## 📁 8. Alta Disponibilidade com HAProxy

### Contexto do Problema
Implementar uma camada de balanceamento de carga para melhorar a disponibilidade dos serviços.

### Troubleshooting e Resolução
O SELinux bloqueava a comunicação necessária para o funcionamento do HAProxy.

* **Investigação:** Diagnóstico das portas e análise das restrições do SELinux.
* **Resolução:** Ajuste das políticas utilizando `semanage` e validação do serviço.

### Evidência Técnica
<details>
<summary>📂 Clique para ver o Troubleshooting e Validação</summary>

* **Erro Inicial:** ![Erro HAProxy](./docs/assets/haproxy-troubleshoot-error.png)
* **Diagnóstico de Portas:** ![Diagnóstico](./docs/assets/wazuh-port-diagnosis-ss.png)
* **Correção do SELinux:** ![SELinux](./docs/assets/semanage-selinux-fix.png)
* **HAProxy Operacional:** ![HAProxy](./docs/assets/haproxy-active-status.png)

</details>

---

## 📂 Tecnologias e Conceitos Aplicados

`Wazuh` · `Suricata` · `SIEM` · `XDR` · `HIDS` · `NIDS` · `SCA` · `FIM` · `Active Response` · `Threat Intelligence` · `Filebeat` · `HAProxy` · `SELinux` · `Linux` · `AWS Logs`

---

## 📌 Principais Aprendizados

Este laboratório foi construído com foco em **investigação, análise de causa raiz e resolução de problemas**.

Os incidentes documentados envolveram incompatibilidade de versões, falhas de permissões, erros de configuração XML, problemas de ingestão de logs, tuning de alertas, bloqueios do SELinux e troubleshooting de rede.

O resultado foi um ambiente que integra **monitoramento, detecção, investigação e resposta automatizada**, com foco prático em operações de SOC, SecOps e Blue Team.
