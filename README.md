# SOC & Defensive Security Infrastructure (Wazuh SIEM) 🛡️

Repositório dedicado à implementação de monitoramento defensivo, visibilidade centralizada e resposta automatizada a incidentes. Este laboratório documenta a construção de um ecossistema focado em detecção avançada, hardening contínuo e operações Blue Team.

## Business Value & Resiliência
O objetivo principal é garantir uma infraestrutura auditável em tempo real, reduzindo o tempo de resposta a incidentes (MTTR) através de automações de bloqueio e notificações instantâneas de ameaças críticas.

## Arquitetura de Observabilidade

```text
[Kali Linux]
     │
     ▼
[DVWA / Ubuntu]
     │
┌────┴─────┐
▼          ▼
Suricata   Wazuh Agent
     │
     ▼
Wazuh Manager
     │
┌────┼────────────┬─────────────┐
▼    ▼            ▼             ▼
VT   AbuseIPDB    CloudTrail    LLM
│    │            │             │
└────┴────────────┴─────────────┘
             │
             ▼
          Telegram
```

# Stack Tecnológica & Matriz de Arquitetura SOC

- SIEM/XDR: Wazuh (Manager, Indexer, Dashboard)
- IDS/IPS: Suricata (NIDS), Wazuh Agent (HIDS)
- Sistemas Operacionais: Rocky Linux 9 (Manager), Ubuntu 24.04 LTS (Agent/Host Real) e Kali Linux
- Integrações (SOAR): VirusTotal API, AbuseIPDB API e Telegram Bot API

## Matriz de Capacidades Defensivas

| Camada | Tecnologia | Estratégia de Defesa | Função |
| :--- | :--- | :--- | :--- |
| Centralização de Logs | Wazuh Indexer | Retenção e Indexação | Centralizar e analisar mensagens de logs do ambiente |
| Gestão de Vulnerabilidades | Wazuh SCA | Políticas CIS Benchmarks | Identificar falhas de configuração e checar compliance |
| Detecção de Intrusão | Suricata + Regras Wazuh | Análise de Rede e Host | Detectar tráfego malicioso e anomalias no sistema |
| Inteligência de Ameaças | VirusTotal + AbuseIPDB | Reputação de IPs e Arquivos | Enriquecer alertas com informações externas sobre IPs e hashes |
| Resposta Automática | Módulo Firewall-Drop | Bloqueio Automatizado | Barrar na hora IPs atacantes em tentativas de força bruta |
| Notificação de Incidentes com Telegram Bot e Alertas em Tempo Real | Avisar a equipe de segurança assim que um evento crítico acontece |

---

# 📁 1. Core Deployment & Connectivity

## Contexto
Fase inicial focada em estabelecer e garantir a comunicação segura entre o servidor central (Wazuh Manager) e os sistemas monitorados.

## Troubleshooting — Incompatibilidade de Versões (Version Mismatch)

- Incidente: O agente instalado aparecia como desconectado no painel, mesmo com as portas de rede liberadas.
- Causa raiz: Os logs internos revelaram que o Agent estava rodando em uma versão mais recente (v4.14) do que o Manager (v4.10).
- Resolução: Padronização das versões para garantir total compatibilidade, ajustes de permissões no arquivo de configuração ossec.conf e validação do processo de autenticação via authd.

<details>
  <summary>📂 Evidências de Conectividade e Deploy</summary>

- Estrutura do Servidor: ![Setup](./docs/assets/01-agent-inventory-host.png)
- Erro no Log de Autenticação: ![Erro Handshake](./docs/assets/03-troubleshooting-version-mismatch.png)
- Comunicação Restabelecida com Sucesso: ![Conexão OK](./docs/assets/02-ubuntu-agent-deployment.png)
- Transferência Segura de Arquivos de Configuração: ![SCP Transfer](./docs/assets/scp-transfer-success-ubuntu-agent.png)

</details>

---

# 📁 2. Governance & Vulnerability Assessment (SCA)

## Contexto
Fase dedicada a encontrar serviços desnecessários, senhas fracas ou configurações inseguras que poderiam facilitar a entrada de um invasor.

## Estratégia aplicada
Uso do módulo SCA (Security Configuration Assessment) do Wazuh para rodar testes automáticos no sistema baseados no padrão CIS Benchmark. Durante a validação dos scripts de checagem, erros de permissão de leitura nos logs locais foram tratados para garantir que as coletas de auditoria funcionassem sem travar.

<details>
  <summary>📂 Evidências de Auditoria e Ajustes de Segurança</summary>

- Alertas de Falha de Compliance encontrados pelo SCA: ![SCA Diagnóstico](./docs/assets/02-hardening-audit-sca.png)
- Tratamento de Erro de Permissão de Leitura nos Logs: ![Correção de Permissão](./docs/assets/bash-permission-denied-remediation-log.png)
- Sistema Corrigido e Hardening Aplicado com Sucesso: ![Hardening OK](./docs/assets/sudo-bash-hardening-success-ubuntu-compliance.png)

</details>

---

# 📁 3. Network & Host IDS (Real-Time Detection)

## Estratégia de Defesa em Dupla Camada

### Monitoramento de Rede (NIDS)
Configuração do Suricata focado em analisar o tráfego de rede da placa em tempo real em busca de pacotes suspeitos.

### Monitoramento do Sistema (HIDS)
Monitoramento local com foco em:
- Integridade de Arquivos (FIM) para detectar mudanças em arquivos importantes do sistema.
- Análise de Logs de Autenticação (SSH/PAM) para pegar acessos negados.

<details>
  <summary>📂 Evidências de Detecção em Tempo Real</summary>

- Alertas gerados pelo tráfego de rede (Suricata): ![NIDS Rede](./docs/assets/03-nids-detection-network.png)
- Tentativas de Brute Force pegas no Host (Wazuh Dashboard): ![HIDS Autenticação](./docs/assets/04-hids-detection-auth.png)

</details>

---

# 📁 4. SOC Automation: Active Response & Threat Intelligence

## Contexto
Ataques automatizados acontecem rápido demais para depender de ação humana manual. Esta etapa foca em programar o sistema para reagir sozinho em segundos.

## Troubleshooting — Problemas com Sintaxe XML e Integração de APIs

### O Problema
O serviço do Wazuh Manager parou de iniciar após a configuração das integrações com as ferramentas de inteligência externas.

### Diagnóstico das Causas Raiz
1. Caracteres invisíveis (Non-breaking spaces) acabaram entrando no arquivo ossec.conf na hora da edição, o que impedia o sistema de ler o arquivo corretamente.
2. Uso de tags que não eram mais suportadas pela API de integração do Wazuh.

### Solução Aplicada
- Limpeza rápida dos caracteres fantasmas no arquivo usando comandos de substituição com o `sed`.
- Correção do bloco `<integration>` removendo os parâmetros inválidos.
- Uso do comando de teste `wazuh-analysisd -t` para checar se o arquivo estava perfeito antes de reiniciar o serviço.

<details>
  <summary>📂 Evidências de Automação e Resolução do Erro</summary>

- Fluxo de Alerta Completo (Ataque > VirusTotal/AbuseIPDB > Telegram): ![Alerta SOAR](./docs/assets/wazuh-integration-virustotal-telegram-alert.png)
- Arquivo de Configuração Aberto no Vim para Ajustes: ![ossec.conf no Vim](./docs/assets/ossec-conf-xml-syntax-conflict.png)
- Comando de Validação de Sintaxe Apontando o Erro: ![Análise do XML](./docs/assets/wazuh-xml-parsing-error-investigation.png)
- Identificação da Tag Inválida nos Logs: ![Parâmetro Inválido](./docs/assets/wazuh-invalid-parameter-detection.png)
- Status do Serviço Travado Antes da Correção: ![Serviço Falhou](./docs/assets/wazuh-manager-error-failed-status.png)
- Ação do Active Response bloqueando IP no Firewall: ![Bloqueio Ativo](./docs/assets/wazuh-active-response-firewall-drop.png)

</details>

---

# 📁 5. Adversary Simulation & Web Attack Detection

## Contexto
Testar a eficiência das regras criadas simulando técnicas reais de ataque em um ambiente controlado.

## Testes Realizados no Laboratório

### Ataques Web e Regras Customizadas
Simulação de injeção de código (SQL Injection) contra a aplicação DVWA para checar se as regras do Wazuh correlacionavam o tráfego do Apache corretamente.

### Teste de Força Bruta com Hydra
Disparo de ataques rápidos de dicionário por SSH usando a ferramenta Hydra, validando se o alarme dispararia no bot do Telegram.

### Automação de Rotinas com Cron
Configuração de scripts agendados via crontab para automatizar checagens periódicas de integridade e espaço em disco, registrando alertas sempre que limites de segurança fossem atingidos.

## Validação Prática do Bloqueio Automático

Durante os testes de ataque disparados pelo Kali Linux usando requisições repetidas, a máquina de testes perdeu o acesso ao servidor. Olhando os logs do sistema, foi confirmado que a automação de Resposta Ativa identificou o comportamento nocivo e inseriu o IP na lista de bloqueio do firewall de forma automática.

<details>
  <summary>📂 Evidências dos Ataques e Correlação de Eventos</summary>

- Logs do Apache registrando os Payloads do ataque sendo detectados: ![Ataque Web](./docs/assets/wazuh-threat_intel-web_attack_correlation.png)
- Alertas Críticos chegando no Bot do Telegram no meio do ataque do Hydra: ![Notificação Telegram](./docs/assets/hydra-attack-wazuh-alert-telegram.png)
- Execução do Script de Auditoria Automatizado pelo Crontab: ![Ação do Cron](./docs/assets/crontab-active-scheduled_tasks_automation.png)

</details>

---

# Observações Técnicas & Cyber Threat Intelligence

## Sincronização de Tempo (Timestamps)
Durante alguns testes manuais inserindo logs diretamente com o comando `echo`, o motor do Wazuh acabou ignorando os eventos porque os horários do agente e do servidor central estavam desalinhados. Isso me mostrou na prática a importância de ter um servidor NTP bem configurado para manter a linha do tempo dos logs idêntica.

## Próximos Passos com Ferramentas de Inteligência
Em estruturas profissionais de maior porte, as integrações montadas nesse projeto seriam ligadas a plataformas maiores de Threat Intelligence, como o **MISP** ou **Yeti**, permitindo alimentar o SIEM com listas globais e atualizadas de ameaças automaticamente.

---

# 📁 6. AWS Log Ingestion & AI-Powered Incident Response

Integração do ecossistema AWS (CloudTrail) com o SIEM para centralização de logs e implementação de camada de triagem inteligente via LLM.

## Desafios de Engenharia
- **Pipeline:** Migração da ingestão nativa para Filebeat devido a limitações de binários.
- **Tuning:** Redução de *alert fatigue* via filtros de eventos de baixa severidade no `local_rules.xml`.

<details>
  <summary>📂 Evidências Técnicas (Troubleshooting & Sucesso)</summary>

- **Debug do Pipeline:** Investigação e validação do path dos módulos do Filebeat. ![Debug](./docs/assets/wazuh-modulesd-debug-troubleshooting.png)
- **Validação de Ingestão:** Logs do CloudTrail processados e indexados. ![Ingestão OK](./docs/assets/filebeat-ingestion-success-aws-logs.png)
- **Tuning de Alertas:** Eliminação de ruído operacional via regras customizadas (`local_rules.xml`). ![Tuning](./docs/assets/wazuh-alert-tuning-success.png)
- **Resposta Inteligente:** Alerta triado e notificado via Telegram. ![Resposta IA](./docs/assets/wazuh-ai-incident-response-telegram-alert.png)

</details>

# 📁 7. Network Hardening, Deception & Operational Maintenance

Expansão da segurança de rede com foco em estratégias de *deception* (honeypots) para identificação precoce de ameaças e automação de rotinas críticas de sustentação do SIEM.

## Desafios de Engenharia
- **Deception:** Configuração de ambiente DMZ isolado para captura de comportamento de atacantes (Cowrie).
- **Sustentação:** Implementação de rotinas de automação para evitar exaustão de armazenamento no Wazuh.

<details>
  <summary>📂 Evidências Técnicas (Hardening & Operações)</summary>

- **Configuração de Rede (DMZ):** Validação de conectividade isolada via Netplan. ![Netplan DMZ](./docs/assets/netplan-success-honeypot_dmz.png)
- **Hardening de Honeypot:** Deploy automatizado e seguro do Cowrie via Docker. ![Honeypot OK](./docs/assets/infra-hardening-docker_honeypot_complete.png)
- **Monitoramento de Ataque:** Tentativa de acesso SSH interceptada na DMZ. ![SSH Interceptado](./docs/assets/ssh-intercepted-cowrie_dmz.png)
- **Persistência de Acesso:** Configuração de socket systemd para expor SSH na porta 22222. ![Socket SSH](./docs/assets/systemctl-active-ssh_socket_port_22222.png)
- **Gestão de Logs:** Automação via cron para limpeza de telemetria e rotatividade. ![Clean Logs](./docs/assets/cron-telemetry-wazuh_log_cleanup.png)
- **Continuidade de Negócio:** Backup distribuído de configurações críticas do Wazuh. ![Backup OK](./docs/assets/tar-cp-success-distributed_wazuh_backup.png)
- **Troubleshooting de Rede:** Ajuste de timeouts de NAT no PfSense para estabilidade da DMZ. ![NAT Timeout](./docs/assets/pfsense-troubleshooting-nat_timeout.png)

</details>

# 📁 8. High Availability & Load Balancing (HAProxy)

Implementação de um balanceador de carga para garantir a resiliência e a alta disponibilidade do ecossistema Wazuh, permitindo a distribuição eficiente de tráfego entre os nós do cluster.

## Desafios de Engenharia
- **Resiliência:** Configuração do HAProxy para assegurar que a interface do SIEM permaneça online mesmo sob falhas de backend.
- **Troubleshooting de Acesso:** Depuração de bloqueios de rede causados por políticas restritivas do SELinux que impediam a comunicação entre o balanceador e os serviços internos.

<details>
  <summary>📂 Evidências Técnicas (Troubleshooting & Sucesso)</summary>

- **Troubleshooting Inicial:** Identificação de falha na inicialização do serviço por conflitos de configuração. ![Erro HAProxy](./docs/assets/haproxy-troubleshoot-error.png)
- **Diagnóstico de Portas:** Verificação de status de sockets (ss) para validar portas 1514/1515 após ajustes. ![Diagnóstico ss](./docs/assets/wazuh-port-diagnosis-ss.png)
- **Hardening SELinux:** Aplicação de políticas (`semanage`) para permissão de tráfego crítico. ![Correção SELinux](./docs/assets/semanage-selinux-fix.png)
- **Operação Estável:** Serviço HAProxy validado e em pleno funcionamento. ![HAProxy Ativo](./docs/assets/haproxy-active-status.png)

</details>

# Competências Desenvolvidas

- SIEM Engineering (Wazuh)
- Threat Detection & Correlation
- Threat Intelligence Integration (VirusTotal & AbuseIPDB)
- Active Response & Security Automation
- Linux Hardening & System Administration
- Log Analysis & Centralized Logging
- Security Configuration Assessment (SCA)
- Network Security Monitoring (Suricata NIDS)
- Host-Based Intrusion Detection (HIDS)
- Incident Response Fundamentals
- Cloud Log Ingestion (AWS CloudTrail)
- Alert Tuning & Noise Reduction
- Honeypot Deployment & Deception Techniques
- High Availability & Load Balancing (HAProxy)
- Infrastructure Troubleshooting & Root Cause Analysis
- Firewall Management & Network Segmentation
- SELinux Policy Management
- Backup, Recovery & Operational Maintenance

# Conclusão

Este laboratório consolidou a construção de uma infraestrutura defensiva completa, integrando monitoramento centralizado, detecção de ameaças, automação de resposta e observabilidade operacional em um ambiente Linux.

Ao longo do projeto foram enfrentados desafios reais de engenharia, incluindo incompatibilidade de versões, falhas de configuração XML, problemas de conectividade, ajustes de SELinux, tuning de alertas, integração de serviços AWS e troubleshooting de componentes críticos da infraestrutura.

Além da implementação das tecnologias, o principal aprendizado foi desenvolver uma abordagem baseada em investigação, análise de causa raiz e resolução estruturada de problemas, aplicando conceitos utilizados em ambientes profissionais de SecOps, Blue Team e Cloud Security.

O resultado final é um ecossistema capaz de coletar, correlacionar e responder a eventos de segurança em tempo real, servindo como base para futuras evoluções em arquiteturas de detecção, automação e defesa em ambientes corporativos.

---
