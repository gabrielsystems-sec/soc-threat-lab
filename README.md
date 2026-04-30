# SOC & Defensive Security Infrastructure (Wazuh SIEM) 🛡️

Repositório dedicado à implementação de monitoramento defensivo e resposta a incidentes. Este laboratório documenta a transição para um ecossistema focado em **Visibilidade, Hardening e Automação Blue Team**.

## 🎯 Business Value
Garantir infraestrutura auditável, detecção automática de vulnerabilidades e resposta rápida a incidentes através de visibilidade centralizada.

---

## 📁 1. Infrastructure Deployment & Connectivity
Foco no setup inicial e na resolução de conflitos de comunicação entre o Manager e o Agente.

### Troubleshooting (Post-Mortem: Version Mismatch)
* **Incidente**: Agente Ubuntu reportava status desconectado.
* **Causa Raiz**: Investigação de logs identificou incompatibilidade de versão (Manager v4.10 vs Agent v4.14).
* **Resolução**: Padronização das versões e validação do handshake via `authd`.

<details>
  <summary>📂 Visualizar Evidências de Conectividade</summary>

  * **Setup do Servidor**: ![Setup](./docs/assets/01-wazuh-server-setup-success.png)
  * **Deploy do Agente**: ![Deploy](./docs/assets/02-ubuntu-agent-deployment.png)
  * **Log de Erro (Incompatibilidade)**: ![Log Erro](./docs/assets/03-troubleshooting-version-mismatch.png)
  * **Status de Conexão OK**: ![Status OK](./docs/assets/04-connectivity-proof.png)
</details>

---

## 📁 2. Vulnerability Management & Governance (SCA)
Monitoramento contínuo da superfície de ataque e conformidade com políticas de segurança.

### Contexto do Problema
Utilização do **SCA (Security Configuration Assessment)** para identificar configurações inseguras, como IP Forwarding ativo, que violam as políticas de hardening.

<details>
  <summary>📂 Visualizar Auditoria de Vulnerabilidades</summary>

  * **Inventário de Ativos (Ryzen 7)**: ![Inventory](./docs/assets/05-inventory-and-vuln.png)
  * **Detecção de Falha SCA**: ![SCA Detection](./docs/assets/wazuh-sca-detecting-vulnerability.png)
</details>

---

## 📁 3. Automated Hardening & Remediation
Ação prática para corrigir vulnerabilidades através de automação via Bash.

### Troubleshooting (Bash Automation)
* **Incidente**: Script de hardening falhou por falta de privilégios e erro de permissão.
* **Resolução**: Ajuste de permissões `sudo` e deploy remoto via `SCP`.

<details>
  <summary>📂 Visualizar Ciclo de Remediação</summary>

  * **Log de Erro de Permissão**: ![Perm Error](./docs/assets/bash-permission-denied-remediation-log.png)
  * **Transferência via SCP**: ![SCP Success](./docs/assets/scp-transfer-success-ubuntu-agent.png)
  * **Execução com Sucesso (Sudo)**: ![Sudo Success](./docs/assets/sudo-bash-hardening-success-ubuntu-compliance.png)
  * **[GOLDEN EVIDENCE] Compliance 100%**: ![100% Success](./docs/assets/wazuh-sca-hardening-success.png)
</details>

---

## 🚀 Roadmap de Implementação
- [x] **Seção 1-3**: Setup e Customização do Wazuh.
- [x] **Seção 7**: Vulnerability Detection (SCA).
- [x] **Seção 9**: Automação de Resposta a Incidentes (Hardening).
- [ ] **Seção 10-15**: Threat Hunting e Cloud Monitoring.

---
> [!IMPORTANT]
> **Lição Aprendida**: A segurança não termina na instalação. A confiabilidade do SOC depende da análise profunda da causa raiz e da garantia de conformidade via automação.
