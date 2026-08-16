# SOC & Defensive Security Infrastructure 🛡️

Repositório dedicado à implementação de um ambiente **Blue Team**, integrando monitoramento, detecção de ameaças, Threat Intelligence e resposta automatizada a incidentes.

O objetivo é centralizar eventos, identificar atividades suspeitas e reduzir o tempo entre **detecção, investigação e resposta**.

---

## Objetivo | Segurança

Garantir **visibilidade contínua, detecção antecipada e resposta automatizada** contra ameaças.

## Stack Tecnológica

* **SIEM/XDR:** Wazuh Manager, Indexer e Dashboard.
* **IDS/HIDS:** Suricata e Wazuh Agent.
* **Threat Intelligence:** VirusTotal e AbuseIPDB.
* **Resposta:** Active Response e Firewall.
* **Cloud Logging:** AWS Logs e Filebeat.
* **Deception:** Cowrie Honeypot.
* **Alta Disponibilidade:** HAProxy.
* **Sistemas:** Rocky Linux 9, Ubuntu 24.04 LTS e Kali Linux.

---

## 📁 1. Implantação Essencial & Conectividade Segura

### Contexto do Problema

A primeira etapa consistiu em estabelecer uma comunicação confiável entre o **Wazuh Manager** e os hosts monitorados. Durante o processo, o Agent permanecia desconectado no Dashboard mesmo com a conectividade de rede disponível, comprometendo a coleta de telemetria e a visibilidade do ambiente.

### Troubleshooting & Resolução

* **Investigação:** Análise dos logs internos do Agent e do processo de autenticação.
* **Causa Raiz:** O Wazuh Agent utilizava a versão `4.14`, enquanto o Manager operava na versão `4.10`, causando incompatibilidade durante a comunicação.
* **Resolução:** Padronização das versões, ajustes de permissões no `ossec.conf` e validação da autenticação via `authd`.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver o Deploy e Troubleshooting</summary>

  * **Estrutura do Host:** ![Setup](./docs/assets/01-agent-inventory-host.png)
  * **Erro de Version Mismatch:** ![Erro Handshake](./docs/assets/03-troubleshooting-version-mismatch.png)
  * **Comunicação Restabelecida:** ![Conexão OK](./docs/assets/02-ubuntu-agent-deployment.png)
  * **Transferência Segura via SCP:** ![SCP Transfer](./docs/assets/scp-transfer-success-ubuntu-agent.png)

</details>

---

## 📁 2. Governança, Avaliação de Vulnerabilidades & Hardening

### Contexto do Problema

Uma infraestrutura defensiva não deve apenas reagir a ataques já iniciados. Era necessário identificar configurações inseguras, serviços desnecessários e falhas de compliance antes que essas condições fossem exploradas.

### Resolução

Implementação do **Security Configuration Assessment (SCA)** do Wazuh para avaliar a postura de segurança dos hosts com base em políticas e benchmarks.

Durante o processo de validação, erros de permissão relacionados à leitura de logs foram investigados e corrigidos para garantir a integridade da coleta e da análise de segurança.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver a Auditoria e o Hardening</summary>

  * **Falhas de Compliance Detectadas:** ![SCA Diagnóstico](./docs/assets/02-hardening-audit-sca.png)
  * **Troubleshooting de Permissões:** ![Correção de Permissão](./docs/assets/bash-permission-denied-remediation-log.png)
  * **Hardening Aplicado:** ![Hardening OK](./docs/assets/sudo-bash-hardening-success-ubuntu-compliance.png)

</details>

---

## 📁 3. Detecção de Intrusão em Tempo Real (NIDS & HIDS)

### Contexto do Problema

A visibilidade limitada a uma única camada de infraestrutura reduz a capacidade de detectar ataques complexos. O laboratório exigia monitoramento simultâneo de **rede, autenticação e integridade de arquivos**.

### Estratégia de Defesa

Implementação de uma arquitetura de detecção em múltiplas camadas:

1. **NIDS:** O Suricata monitora o tráfego de rede em busca de padrões e comportamentos suspeitos.
2. **HIDS:** O Wazuh Agent monitora eventos locais, integridade de arquivos e logs de autenticação.
3. **FIM:** Alterações em arquivos monitorados são registradas para investigação posterior.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver a Detecção em Tempo Real</summary>

  * **Detecção de Tráfego de Rede:** ![NIDS Rede](./docs/assets/03-nids-detection-network.png)
  * **Detecção de Brute Force:** ![HIDS Autenticação](./docs/assets/04-hids-detection-auth.png)

</details>

---

## 📁 4. [GOLDEN EVIDENCE] SOC Automation: Active Response & Threat Intelligence

### O Incidente

Durante a implementação das integrações de Threat Intelligence e notificações automatizadas, o serviço do Wazuh Manager deixou de iniciar após alterações no arquivo `ossec.conf`.

### Troubleshooting (Causa Raiz)

* **Investigação:** Validação da configuração e análise dos logs do serviço.
* **Causa Raiz:** Caracteres invisíveis e tags obsoletas estavam comprometendo a estrutura XML.
* **Resolução:** Limpeza da configuração via `sed`, correção do bloco `<integration>` e validação utilizando `wazuh-analysisd -t`.

Após a recuperação do serviço, o pipeline passou a integrar eventos com **VirusTotal**, enriquecer indicadores e encaminhar alertas críticos para o **Telegram**.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver a Automação SOC</summary>

  * **Fluxo Completo de Alerta:** ![Alerta](./docs/assets/wazuh-integration-virustotal-telegram-alert.png)
  * **Investigação do ossec.conf:** ![Configuração](./docs/assets/ossec-conf-xml-syntax-conflict.png)
  * **Erro de Parsing XML:** ![Análise XML](./docs/assets/wazuh-xml-parsing-error-investigation.png)
  * **Detecção de Parâmetro Inválido:** ![Tag Inválida](./docs/assets/wazuh-invalid-parameter-detection.png)

</details>

---

## 📁 5. Simulação de Ameaças & Validação de Detecção

### Contexto do Problema

Uma arquitetura defensiva precisa ser validada através de cenários controlados. O objetivo foi testar a capacidade do ambiente de identificar comportamentos ofensivos, correlacionar eventos e executar mecanismos automáticos de resposta.

### Testes Realizados

* **Ataque Web:** Simulação de SQL Injection contra DVWA.
* **Brute Force:** Tentativas controladas utilizando Hydra.
* **Automação:** Execução de tarefas programadas via Crontab.
* **Active Response:** Validação do bloqueio automático do IP identificado pelo mecanismo defensivo.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver as Simulações e Correlações</summary>

  * **Correlação de Ataque Web:** ![Ataque Web](./docs/assets/wazuh-threat_intel-web_attack_correlation.png)
  * **Alerta de Hydra no Telegram:** ![Notificação](./docs/assets/hydra-attack-wazuh-alert-telegram.png)
  * **Automação via Crontab:** ![Cron](./docs/assets/crontab-active-scheduled_tasks_automation.png)

</details>

---

## 📁 6. Ingestão de Logs AWS & Resposta Assistida por IA

### Contexto do Problema

Ambientes híbridos exigem visibilidade além da infraestrutura local. Era necessário integrar eventos provenientes da AWS ao pipeline centralizado do SOC e reduzir o volume de alertas que não exigiam ação operacional.

### Troubleshooting & Resolução

* **Pipeline:** Limitações encontradas durante a ingestão exigiram a migração para uma arquitetura baseada em Filebeat.
* **Tuning:** Ajustes no `local_rules.xml` reduziram o volume de alertas repetitivos e o risco de *alert fatigue*.
* **Análise Assistida:** Integração de respostas assistidas por IA para apoiar a interpretação inicial de incidentes e acelerar o processo de triagem.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver a Ingestão e o Tuning</summary>

  * **Troubleshooting do Pipeline:** ![Debug](./docs/assets/wazuh-modulesd-debug-troubleshooting.png)
  * **Ingestão de Logs AWS:** ![Ingestão OK](./docs/assets/filebeat-ingestion-success-aws-logs.png)
  * **Tuning de Alertas:** ![Tuning](./docs/assets/wazuh-alert-tuning-success.png)
  * **Resposta Assistida por IA:** ![Resposta IA](./docs/assets/wazuh-ai-incident-response-telegram-alert.png)

</details>

---

## 📁 7. Deception Engineering, Hardening de Rede & Manutenção

### Contexto do Problema

Além da detecção tradicional, o ambiente precisava coletar inteligência sobre atividades ofensivas sem expor diretamente os serviços legítimos da infraestrutura.

### Estratégia Aplicada

Implementação de uma **DMZ controlada** para o Honeypot Cowrie, permitindo registrar e analisar tentativas de acesso SSH.

A arquitetura também incluiu persistência do serviço SSH, troubleshooting de NAT e automações de backup para reduzir riscos operacionais e problemas relacionados ao armazenamento.

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

## 📁 8. Alta Disponibilidade & Balanceamento de Carga (HAProxy)

### Contexto do Problema

A camada de monitoramento também precisa considerar a disponibilidade dos serviços responsáveis pela distribuição de tráfego. Foi implementado o **HAProxy** para adicionar resiliência e capacidade de balanceamento à infraestrutura.

### Troubleshooting (SELinux)

* **Incidente:** O HAProxy não conseguia estabelecer a comunicação necessária com os serviços de backend.
* **Investigação:** Diagnóstico de portas, conectividade e análise dos bloqueios do SELinux.
* **Causa Raiz:** Restrições de segurança impediam as conexões necessárias.
* **Resolução:** Ajuste das políticas utilizando `semanage` e validação final do serviço.

### Evidência Técnica

<details>
  <summary>📂 Clique para ver o Troubleshooting e a Validação</summary>

  * **Erro Inicial:** ![Erro HAProxy](./docs/assets/haproxy-troubleshoot-error.png)
  * **Diagnóstico de Portas:** ![Diagnóstico](./docs/assets/wazuh-port-diagnosis-ss.png)
  * **Correção do SELinux:** ![SELinux](./docs/assets/semanage-selinux-fix.png)
  * **HAProxy Operacional:** ![HAProxy](./docs/assets/haproxy-active-status.png)

</details>

---

## 📁 Diferenciais de Engenharia: Investigação & Resposta

### Diferenciais Técnicos

* **Threat Detection:** Correlação de eventos de rede e host.
* **Root Cause Analysis:** Investigação de incompatibilidades, permissões, XML e pipelines.
* **Threat Intelligence:** Enriquecimento de indicadores com fontes externas.
* **Automated Response:** Contenção automática de comportamentos identificados.
* **Cloud Visibility:** Integração de eventos externos ao SOC.
* **Deception:** Coleta de telemetria através de Honeypot.
* **High Availability:** Resiliência através de HAProxy.
* **SELinux Mastery:** Investigação e resolução de bloqueios mantendo o sistema protegido.

---

> [!IMPORTANT]
> **SOC Insight: Alertas sem contexto não são inteligência**
>
> Um SOC eficiente não depende apenas da geração de alertas. O valor operacional está na capacidade de correlacionar eventos, reduzir falsos positivos, melhorar os indicadores e executar respostas proporcionais ao risco identificado.

> [!TIP]
> **Lição de Engenharia: Troubleshooting antes da Automação**
>
> Durante a implementação, problemas de compatibilidade de versões, permissões, sintaxe XML, pipelines de ingestão e políticas do SELinux precisaram ser resolvidos antes da automação definitiva. A investigação estruturada da causa raiz foi essencial para transformar componentes isolados em uma infraestrutura defensiva integrada.
