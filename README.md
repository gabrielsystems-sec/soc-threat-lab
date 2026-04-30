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

## 🚀 Roadmap Estratégico

### Fase 01: Core & Audit Foundation
*Base do SIEM e conformidade inicial.*
- [x] **Seção 1 a 3**: Setup, Preparação de Ambiente e Instalação Wazuh.
- [x] **Seção 07**: Vulnerability Detection (SCA).
- [ ] **Seção 08**: Uso de IDS no Wazuh.

### Fase 02: Active Response & Alerts
*Automação de defesa e notificações.*
- [ ] **Seção 09**: Automação de resposta a incidentes.
- [ ] **Seção 10**: Configuração de Alertas e Notificações.

### Fase 03: Threat Intelligence & Hunting
*Análise profunda e busca ativa por ameaças.*
- [ ] **Seção 05**: Detecção de Malware.
- [ ] **Seção 06**: Threat Hunting.
- [ ] **Seção 13**: Uso de Inteligência Artificial (IA) aplicada ao SOC.

### Fase 04: Ops, Cloud & Deception
*Escalabilidade e táticas de engodo.*
- [ ] **Seção 11**: Monitoramento de ferramentas.
- [ ] **Seção 12**: Monitoramento de Cloud.
- [ ] **Seção 15**: Uso de Honeypots com Wazuh e pfSense.

### Fase 05: Governance & Admin
*Manutenção e administração do sistema.*
- [ ] **Seção 14**: Administração do Sistema.

---
> [!IMPORTANT]
> **Lição Aprendida**: A segurança não termina na instalação. A confiabilidade do SOC depende da análise profunda da causa raiz e da garantia de conformidade via automação.
