# SOC & Defensive Security Infrastructure (Wazuh SIEM) 🛡️

Repositório dedicado à implementação de monitoramento defensivo, visibilidade centralizada e resposta automatizada a incidentes. Este laboratório **detalha** a construção de um ecossistema focado em detecção avançada, hardening contínuo e operações Blue Team.

O objetivo principal é garantir uma infraestrutura auditável em tempo real, **reduzindo significativamente** o tempo de resposta a incidentes (MTTR) através de automações de bloqueio e notificações instantâneas de ameaças críticas.

---

## 🏗️ Stack Tecnológica & Matriz de Arquitetura SOC

- **SIEM/XDR:** Wazuh (Manager, Indexer, Dashboard)
- **IDS/IPS:** Suricata (NIDS), Wazuh Agent (HIDS)
- **Sistemas Operacionais:** Rocky Linux 9 (Manager), Ubuntu 24.04 LTS (Agent/Host Real) e Kali Linux

### Matriz de Capacidades Defensivas

| Camada | Tecnologia | Estratégia | Função |
| :--- | :--- | :--- | :--- |
| **Centralização** | Wazuh Indexer | Retenção e Indexação | Centralizar e analisar logs |
| **Vulnerabilidades** | Wazuh SCA | Políticas CIS Benchmarks | Identificar falhas e compliance |
| **Detecção** | Suricata + Regras | Análise de Rede e Host | Detectar tráfego e anomalias |
| **Inteligência** | VirusTotal + AbuseIPDB | Reputação | Enriquecer alertas (IPs/hashes) |
| **Resposta** | Firewall-Drop | Bloqueio Automatizado | Bloquear IPs (Força Bruta) |
| **Notificação** | Telegram Bot | Alertas em Tempo Real | Notificar a equipe imediatamente |

---

## 📁 1. Implantação Essencial & Conectividade Segura

**Contexto:** Fase inicial para resolver o desafio de estabelecer e garantir a comunicação segura entre o servidor central (Wazuh Manager) e os sistemas monitorados, essencial para a coleta de telemetria crítica e a visibilidade operacional.

### Troubleshooting: Incompatibilidade de Versões (Version Mismatch)
**Incidente:** O agente instalado aparecia como desconectado no painel, mesmo com as portas de rede liberadas, comprometendo a visibilidade do host.

- **Causa raiz:** Os logs internos revelaram que o Agent estava rodando em uma versão mais recente (v4.14) do que o Manager (v4.10).
- **Resolução:** Padronização das versões, ajustes de permissões no `ossec.conf` e validação do processo de autenticação via `authd`, restabelecendo a comunicação e a coleta de dados.

<details>
<summary>📂 Clique para explorar as evidências visuais de Conectividade e Deploy</summary>

- Estrutura do Servidor: ![Setup](./docs/assets/01-agent-inventory-host.png)
- Erro no Log de Autenticação: ![Erro Handshake](./docs/assets/03-troubleshooting-version-mismatch.png)
- Comunicação Restabelecida: ![Conexão OK](./docs/assets/02-ubuntu-agent-deployment.png)
- Transferência Segura: ![SCP Transfer](./docs/assets/scp-transfer-success-ubuntu-agent.png)
</details>

---

## 📁 2. Governança, Avaliação de Vulnerabilidades (SCA) & Hardening

**Contexto:** Fase dedicada a encontrar serviços desnecessários, senhas fracas ou configurações inseguras que poderiam facilitar a entrada de um invasor, mitigando proativamente riscos de segurança.

**Estratégia aplicada:** Uso do módulo SCA (Security Configuration Assessment) do Wazuh para rodar testes automáticos no sistema baseados no padrão CIS Benchmark. Durante a validação dos scripts de checagem, erros de permissão de leitura nos logs locais foram tratados, assegurando a integridade e a completude da avaliação.

<details>
<summary>📂 Ver Evidências: Auditoria e Ajustes de Segurança</summary>

- Alertas de Falha de Compliance (SCA): ![SCA Diagnóstico](./docs/assets/02-hardening-audit-sca.png)
- Tratamento de Erro de Permissão: ![Correção de Permissão](./docs/assets/bash-permission-denied-remediation-log.png)
- Hardening Aplicado: ![Hardening OK](./docs/assets/sudo-bash-hardening-success-ubuntu-compliance.png)
</details>

---

## 📁 3. Detecção de Intrusão em Tempo Real (NIDS & HIDS)

**Estratégia de Defesa em Dupla Camada:**
- **NIDS (Rede):** Configuração do Suricata focado em analisar o tráfego de rede em tempo real.
- **HIDS (Sistema):** Foco em Integridade de Arquivos (FIM) e análise de Logs de Autenticação (SSH/PAM) para identificar acessos negados.

<details>
<summary>📂 Explore as Evidências de Detecção em Tempo Real</summary>

- NIDS (Suricata): ![NIDS Rede](./docs/assets/03-nids-detection-network.png)
- HIDS (Brute Force): ![HIDS Autenticação](./docs/assets/04-hids-detection-auth.png)
</details>

---

## 📁 4. Automação SOC: Resposta Ativa & Inteligência de Ameaças

**Contexto:** Programar o sistema para reagir sozinho em segundos, minimizando o tempo de exposição a ameaças.

### Troubleshooting: Sintaxe XML e Integração de APIs

**O Problema:** Serviço do Wazuh Manager parou de iniciar após configurar integrações, comprometendo a detecção.
**Diagnóstico:** Caracteres invisíveis no `ossec.conf` e tags obsoletas.
**Solução:** Limpeza via `sed`, correção do bloco `<integration>` e validação com `wazuh-analysisd -t`.

<details>
<summary>📂 Ver Evidências: Automação e Resolução de Erros</summary>

- Fluxo de Alerta Completo: ![Alerta SOAR](./docs/assets/wazuh-integration-virustotal-telegram-alert.png)
- Ajustes no Vim: ![ossec.conf](./docs/assets/ossec-conf-xml-syntax-conflict.png)
- Validação XML: ![Análise do XML](./docs/assets/wazuh-xml-parsing-error-investigation.png)
- Tag Inválida: ![Parâmetro Inválido](./docs/assets/wazuh-invalid-parameter-detection.png)
</details>

---

## 📁 5. Simulação de Ameaças & Detecção de Ataques Web

**Contexto:** Testar a eficiência das regras simulando técnicas reais de ataque para validar a capacidade de resposta do SIEM.

**Testes Realizados:**
- Injeção SQL contra DVWA.
- Força Bruta via Hydra com alerta no Telegram.
- Automação de checagens via Crontab.

**Validação de Bloqueio:** A Resposta Ativa identificou o comportamento do Kali Linux e inseriu o IP no firewall automaticamente.

<details>
<summary>📂 Explore as Evidências dos Ataques e Correlação</summary>

- Ataque Web: ![Ataque Web](./docs/assets/wazuh-threat_intel-web_attack_correlation.png)
- Alerta Hydra (Telegram): ![Notificação Telegram](./docs/assets/hydra-attack-wazuh-alert-telegram.png)
- Automação Crontab: ![Ação do Cron](./docs/assets/crontab-active-scheduled_tasks_automation.png)
</details>

---

## 📁 6. Ingestão de Logs AWS & Resposta a Incidentes com IA

**Desafios de Engenharia:**
- **Pipeline:** Migração para Filebeat devido a limitações de binários.
- **Tuning:** Redução de *alert fatigue* via filtros no `local_rules.xml`.

<details>
<summary>📂 Ver Evidências Técnicas</summary>

- Debug Pipeline: ![Debug](./docs/assets/wazuh-modulesd-debug-troubleshooting.png)
- Validação Ingestão: ![Ingestão OK](./docs/assets/filebeat-ingestion-success-aws-logs.png)
- Tuning de Alertas: ![Tuning](./docs/assets/wazuh-alert-tuning-success.png)
- Resposta IA: ![Resposta IA](./docs/assets/wazuh-ai-incident-response-telegram-alert.png)
</details>

---

## 📁 7. Hardening de Rede, Decepção & Manutenção

**Estratégias:** Configuração de DMZ para honeypot (Cowrie) e automação de sustentação para evitar exaustão de armazenamento.

<details>
<summary>📂 Explore as Evidências Técnicas (Hardening & Operações)</summary>

- Conectividade DMZ (Netplan): ![Netplan DMZ](./docs/assets/netplan-success-honeypot_dmz.png)
- Deploy Cowrie: ![Honeypot OK](./docs/assets/infra-hardening-docker_honeypot_complete.png)
- Ataque Interceptado: ![SSH Interceptado](./docs/assets/ssh-intercepted-cowrie_dmz.png)
- Persistência SSH: ![Socket SSH](./docs/assets/systemctl-active-ssh_socket_port_22222.png)
- Backup Distribuído: ![Backup OK](./docs/assets/tar-cp-success-distributed_wazuh_backup.png)
- Troubleshooting NAT: ![NAT Timeout](./docs/assets/pfsense-troubleshooting-nat_timeout.png)
</details>

---

## 📁 8. Alta Disponibilidade & Balanceamento de Carga (HAProxy)

**Estratégia:** Implementação de HAProxy para garantir resiliência e distribuição de carga entre os nós.

**Troubleshooting:** Depuração de bloqueios causados pelo SELinux que impediam a comunicação do balanceador, corrigidos com políticas via `semanage`.

<details>
<summary>📂 Ver Evidências Técnicas (Troubleshooting & Sucesso)</summary>

- Erro Inicial: ![Erro HAProxy](./docs/assets/haproxy-troubleshoot-error.png)
- Diagnóstico de Portas: ![Diagnóstico](./docs/assets/wazuh-port-diagnosis-ss.png)
- Hardening SELinux: ![Correção SELinux](./docs/assets/semanage-selinux-fix.png)
- Status Operacional: ![HAProxy Ativo](./docs/assets/haproxy-active-status.png)
</details>

---

### Observações Finais
Ao longo do projeto, o foco foi desenvolver uma abordagem baseada em investigação, análise de causa raiz e resolução estruturada de problemas, aplicando conceitos essenciais de SecOps, Blue Team e Cloud Security.
