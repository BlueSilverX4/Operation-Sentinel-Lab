# 🛡️ Operation Sentinel-Lab

**A Defensive Security Monitoring, Detection Engineering, and Automated Response Homelab**

Operation Sentinel-Lab is a hands-on cybersecurity lab focused on **detection engineering, threat hunting, centralized telemetry, and Security Orchestration, Automation, and Response (SOAR)**.

The project integrates host-based security monitoring, network protocol analysis, centralized log aggregation, and automated firewall response into a unified defensive monitoring workflow.

---

## 🏛️ Architecture & Technology Stack

| Component | Technology | Purpose |
|---|---|---|
| **Host Intrusion Detection / SIEM** | Wazuh | Security event monitoring, custom detection rules, alert generation, and active response. |
| **Network Intrusion Detection** | Zeek | Network protocol telemetry and analysis of suspicious network activity. |
| **Telemetry Collection** | Grafana Alloy | Collection and forwarding of security logs to the centralized logging pipeline. |
| **Log Aggregation** | Grafana Loki | Centralized log storage and LogQL-based querying. |
| **Visualization** | Grafana | Dashboards for security alerts, telemetry trends, and network activity. |
| **Automated Response (SOAR)** | Wazuh Active Response + `iptables` | Configured firewall countermeasures for supported detection scenarios. |

### 🔄 Telemetry & Response Workflow

```text
       HOST EVENTS                 NETWORK TRAFFIC
            │                            │
            ▼                            ▼
       ┌─────────┐                  ┌─────────┐
       │  Wazuh  │                  │  Zeek   │
       │  HIDS   │                  │  NIDS   │
       └────┬────┘                  └────┬────┘
            │                            │
            └─────────────┬──────────────┘
                          │
                          ▼
                  ┌───────────────┐
                  │ Grafana Alloy │
                  │  Collection   │
                  └───────┬───────┘
                          │
                          ▼
                  ┌───────────────┐
                  │  Grafana Loki│
                  │ Log Storage  │
                  └───────┬───────┘
                          │
                          ▼
                  ┌───────────────┐
                  │    Grafana   │
                  │  Dashboards  │
                  └───────────────┘

       Wazuh Alert ──► Active Response ──► iptables
                         Firewall Action
```

*The diagram represents the intended logical workflow. Actual log paths, integrations, and response behavior depend on the deployed configuration.*

---

## 📋 NIST Cybersecurity Framework 2.0 Alignment

The repository is organized around the five core functions of the **NIST Cybersecurity Framework (CSF) 2.0**.

| CSF Function | Repository Area | Project Objective |
|---|---|---|
| **Identify** | `01-baseline/` | Establish host baselines and maintain system inventory information. |
| **Protect** | `configs/`, `detection-rules/` | Maintain custom detection configurations and network protocol filters. |
| **Detect** | `screenshots/03-initial-alerts/`, `dashboard/` | Demonstrate alert generation for SSH brute-force activity and process anomalies. |
| **Respond** | `screenshots/02-attack-simulation/` | Document SOAR execution and configured firewall countermeasures. |
| **Recover** | `logs/`, `dashboard/sentinel-telemetry.json` | Preserve exported telemetry and dashboard configuration for investigation and reproducibility. |

This structure provides a practical way to organize lab activities by defensive objective. It is a project-level mapping, not a claim of full NIST CSF compliance.

---

## 📂 Repository Structure

```text
Operation-Sentinel-Lab/
├── 01-baseline/             # Host baselines and inventory
├── attack-simulations/      # Scripts and test vectors for threat simulation
├── configs/                 # Zeek anomaly scripts and HTTP signature filters
├── dashboard/               # Exported Grafana dashboard model
├── detection-rules/         # Custom Wazuh decoders and rules
├── logs/                    # Forensic exports, CSV metrics, and raw log payloads
├── screenshots/             # Visual evidence of lab execution
├── scripts/                 # Lab utility scripts
└── tuning-docs/             # Detection tuning notes and false-positive tracking
```

*The directory tree reflects the documented project layout. Confirm that each listed directory exists in the repository before publishing.*

---

## 📸 Lab Evidence & Visualizations

Screenshots provide visual evidence of the lab's detection, response, and monitoring workflows.

### 1. Attack Simulation & Automated Response

**Evidence:** `screenshots/02-attack-simulation/the_soar_execution.png`

Demonstrates the SSH brute-force simulation and the associated Wazuh alert and configured `iptables` response.

**What this demonstrates:**
- Security event detection and alert generation.
- Investigation of repeated SSH authentication failures.
- Active Response execution, where confirmed by the captured output.
- Evidence-based documentation of a defensive countermeasure.

### 2. Unified Security Telemetry Dashboard

**Evidence:** `screenshots/05-grafana/sentinel_telemetry_dashboard.png`

Demonstrates the Grafana dashboard used to visualize security alerts, anomaly trends, and network telemetry collected through the logging pipeline.

**What this demonstrates:**
- Centralized security-event visibility.
- Log exploration and telemetry analysis.
- Visualization of host and network monitoring data.

---

## 🚀 Quick Start & Reproduction

### 1. Clone the Repository

```bash
git clone https://github.com/BlueSilverX4/Operation-Sentinel-Lab.git
cd Operation-Sentinel-Lab
```

### 2. Import the Grafana Dashboard

1. Open your Grafana instance.
2. Navigate to dashboard import.
3. Import `dashboard/sentinel-telemetry.json`.
4. Select or configure the appropriate Loki data source.
5. Verify that the dashboard queries match the labels and log formats emitted by your lab.

**Note:** Importing the dashboard does not deploy Wazuh, Zeek, Alloy, or Loki. Those services must already be configured and running.

### 3. Deploy the Wazuh Detection Rules

The repository's custom rules are documented under `detection-rules/`.

First, locate the actual rule file:

```bash
find detection-rules -type f -name 'local_rules.xml'
```

Back up the existing Wazuh rules before making changes:

```bash
sudo cp /var/ossec/etc/rules/local_rules.xml \
  /var/ossec/etc/rules/local_rules.xml.bak
```

Review the repository's rule file and merge its custom rules into the Wazuh manager's local rules configuration. Avoid blindly overwriting existing rules.

Validate the configuration before restarting Wazuh:

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
```

If validation succeeds, follow the appropriate Wazuh procedure to apply the updated configuration and verify that the manager starts successfully.

> **Important:** The exact source path and deployment steps depend on the files present in the cloned repository and the installed Wazuh version.

---

## 🔍 Detection Engineering & Tuning

Detection engineering requires more than generating alerts. Rules must be tested, evaluated, and tuned to reduce false positives while preserving useful detection coverage.

The lab's tuning documentation is intended to track:

- Detection rule changes and their rationale.
- Attack simulation inputs and expected results.
- Observed alerts and relevant event fields.
- False-positive investigation and tuning decisions.
- Active Response execution and verification.
- Changes to network telemetry and dashboard queries.

### Example Validation Checklist

- [ ] Confirm Wazuh receives the expected authentication events.
- [ ] Verify that the relevant detection rule generates an alert.
- [ ] Confirm Zeek is producing the expected network telemetry.
- [ ] Verify that Alloy forwards the intended logs to Loki.
- [ ] Confirm Grafana queries return the expected records.
- [ ] Verify that Active Response runs only under the intended conditions.
- [ ] Confirm firewall changes are limited to the expected target.
- [ ] Document false positives and any tuning performed.

---

## 🔐 Safe Testing & Operational Boundaries

Operation Sentinel-Lab is intended for authorized defensive security testing in a controlled environment.

- Run attack simulations only against systems you own or are explicitly authorized to test.
- Validate custom rules before deploying them to a production Wazuh manager.
- Test automated firewall actions carefully; incorrect rules can interrupt connectivity or block legitimate traffic.
- Record response actions and maintain a documented rollback procedure.
- Protect logs and screenshots that may contain IP addresses, usernames, hostnames, or other sensitive information.

---

## 🎯 Project Objectives

Operation Sentinel-Lab demonstrates practical work in:

- **Detection Engineering:** Creating and validating security detection logic.
- **Threat Hunting:** Investigating host and network telemetry for suspicious behavior.
- **SIEM Operations:** Reviewing alerts and interpreting security events.
- **Telemetry Engineering:** Collecting, aggregating, and querying logs.
- **SOAR:** Testing automated firewall countermeasures.
- **Security Visualization:** Presenting security information through Grafana dashboards.
- **Framework Alignment:** Organizing defensive activities around NIST CSF 2.0.

The objective is to build a reproducible defensive monitoring environment that demonstrates how security events move from detection and analysis to response and documented evidence.

---

**Author:** Brandon Lawrence Gregg  
**GitHub:** [BlueSilverX4](https://github.com/BlueSilverX4)
# Operation-Sentinel-Lab
