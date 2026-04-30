# SOC & Defensive Security Infrastructure (Wazuh SIEM) 🛡️

Repositório dedicado à implementação de uma camada de monitoramento defensivo e resposta a incidentes. Este laboratório documenta a transição de serviços de infraestrutura para um ecossistema focado em **Visibilidade, Hardening de Kernel e Automação Blue Team**.

## 🎯 Business Value & Segurança
O objetivo é garantir que a infraestrutura seja **auditável em tempo real**, que vulnerabilidades de configuração sejam detectadas automaticamente e que ataques de força bruta ou alterações indevidas em arquivos críticos (FIM) gerem **bloqueios imediatos (Active Response)**.

---

## Stack Tecnológica & Matriz de Monitoramento
* **SIEM/XDR:** Wazuh Platform (Indexer, Server, Dashboard).
* **Sistemas Operacionais:** Rocky Linux 9 (Manager) & Ubuntu 24.04 (Agent).
* **Hardware:** Ryzen 7.

### Matriz de Serviços SOC
| Camada | Tecnologia Principal | Estratégia de Segurança | Função no Ecossistema |
| :--- | :--- | :--- | :--- |
| **SIEM Central** | Wazuh Server | Single Node / SSL | Correlação de Eventos e Gestão de Alertas |
| **Hardening** | SCA | CIS Benchmarks | Auditoria Contínua de Configurações de SO |
| **Resposta Ativa** | Active Response | Shell Scripts | Bloqueio Automatizado de Ações Suspeitas |
| **Integridade** | FIM | Real-time monitoring | Detecção de Alterações em Arquivos Críticos |

---

## 📁 1. Infrastructure Deployment & Troubleshooting

### Contexto do Problema
O deployment exigia que o agente no host real (Ubuntu) conversasse com o manager no Rocky Linux. O cenário inicial apresentou falhas críticas de handshake.

### Troubleshooting (Post-Mortem: Version Mismatch)
* **Incidente:** O agente reportava status `Never Connected` nos logs.
* **Causa Raiz:** Investigação no `ossec.log` identificou incompatibilidade de versão (Manager v4.10 vs Agent v4.14).
* **Resolução:** Downgrade do agente, limpeza de chaves antigas e novo registro via `authd`.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Setup e Logs de Erro</summary>

  * **Success Deploy:** `01_wazuh_server_setup_success.png`
  * **Investigação SRE (ossec.log):** ![Log Erro](./docs/assets/wazuh-log-version_mismatch-detected.png)
  * **Serviço Ativo:** ![Manager Status](./docs/assets/wazuh-manager-status-active.png)
  * **Handshake OK:** ![Agent Register](./docs/assets/wazuh-agent-registration-authd.png)
</details>

---

## 📁 2. Vulnerability Management & Hardening (SCA)

### Contexto do Problema
Monitorar o estado de conformidade do SO e identificar vetores de ataque como IP Forwarding ativo ou permissões fracas em arquivos de sistema.

### Troubleshooting (Bash Automation & Privileges)
Durante a aplicação das correções via script, o processo falhava silenciosamente.
* **Causa Raiz:** O script de hardening não possuía permissão de execução e exigia privilégios de `sudo` para alterar parâmetros de rede.
* **Resolução:** Deploy via `SCP`, ajuste de `chmod +x` e execução administrativa.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver o Ciclo de Hardening e Resultado</summary>

  * **Falha Detectada (SCA):** ![SCA Fail](./docs/assets/wazuh-sca-initial-fail.png)
  * **Inventário de Ativos (Ryzen 7):** ![Inventory](./docs/assets/wazuh-agent-inventory-full.png)
  * **Execução do Script:** ![Hardening Run](./docs/assets/bash-script-hardening-execution.png)
  * **Validação de Saída:** ![Hardening Success](./docs/assets/hardening-script-success-output.png)
  * **[GOLDEN EVIDENCE] Compliance 100%:** ![SCA Success](./docs/assets/wazuh-sca-compliance-100-percent.png)
</details>

---

## 📁 3. Integrity Monitoring & Audit Logs (FIM)

### Contexto do Problema
Garantir a integridade de arquivos binários e de configuração, gerando alertas imediatos em caso de alteração não autorizada.

### Evidência Técnica
<details>
  <summary>📂 Clique para ver Integridade e Auditoria</summary>

  * **Real-time FIM Alert:** ![FIM Alert](./docs/assets/wazuh-fim-integrity-alert.png)
  * **User Activity Logs:** ![User Audit](./docs/assets/wazuh-user-audit-logs.png)
</details>

---

## 🚀 Roadmap de Implementação
- [x] **Seção 1-3:** Setup e Customização do Wazuh.
- [ ] **Seção 4-6:** Cluster, Malware e Threat Hunting.
- [x] **Seção 7:** Vulnerability Detection (SCA).
- [x] **Seção 9:** Automação de Resposta a Incidentes.
- [ ] **Seção 10-15:** Cloud Monitoring, IA e Honeypots.

---
> [!IMPORTANT]
> **Lição Aprendida SRE:** 
> A segurança não termina na instalação. A confiabilidade do SOC depende da análise profunda da causa raiz (logs) e da garantia de que o hardening seja mutável apenas via automação.
