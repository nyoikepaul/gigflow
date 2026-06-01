# GigFlow Core — Premium Freelance Management Dashboard

Production-grade engineering repository and automated operations pipeline designed for enterprise freelance workflow telemetry, high-performance runtime isolation, and distributed financial data compliance layers.

---

## 🏗️ System Architecture Topography

                   [ Public Internet Port: 80 ]
                                │
                                ▼
                 ┌─────────────────────────────┐
                 │     gigflow_edge_proxy      │
                 │  (Nginx Hardened Isolation) │
                 └──────────────┬──────────────┘
                                │
                   (Isolated Bridge Network)
                                ▼
                 ┌─────────────────────────────┐
                 │       gigflow_runtime       │
                 │  (Multi-Stage Node Engine)  │
                 └──────────────┬──────────────┘
                                │
                                ▼
                 ┌─────────────────────────────┐
                 │    Target PostgreSQL DB     │
                 │  (Schema Migration Guard)   │
                 └─────────────────────────────┘


The system deployment architecture utilizes a hard-isolated dual-container bridge network infrastructure. Public-facing operations are entirely intercepted by a security-hardened **Nginx Reverse Proxy Layer** enforcing explicit clickjacking, sniffing, and cross-site scripting mitigation boundaries before routing transient traffic downstream to the application core.

---

## ⚡ Unified Infrastructure Control Plane

The repository integrates a frictionless automation plane via the centralized `Makefile`. Instead of managing fragmented operational shells or complex docker tags, all lifecycle parameters are driven through single-word primitives:

| Command | Action Pattern Defined | Engine Vector |
| :--- | :--- | :--- |
| `make audit` | Runs local SAST vulnerability and compliance scanning | `23-audit-security.sh` |
| `make logs-analyze` | Parses active telemetry slices for exception profiling | `24-log-analyzer.sh` |
| `make archive-logs` | Compresses active runtime logs into cold storage targets | `25-log-archiver.sh` |
| `make db-migrate` | Probes network socket health and executes schema updates | `26-db-migrate.sh` |
| `make db-seed` | Safely injects structural mock datasets for testing | `27-db-seed.sh` |
| `make proxy-test` | Verifies edge proxy availability and security headers | `28-proxy-check.sh` |
| `make test-all` | Triggers sequential Master Pipeline Integration Suite | `29-validate-pipeline.sh` |

---

## 🧪 Orchestration & Master Validation

To execute the full operational validation pipeline locally, invoke the global integration runner:

```bash
make test-all

This sequence triggers a sequential health gate:

    Static Security (SAST) Auditing: Flags exposed credential patterns, key leaks, and strict POSIX file system execution anomalies.

    Telemetry Log Evaluation: Evaluates live streams, builds metrics profiles, and catches high-severity processing errors (e.g., M-Pesa STK timeout blocks).

    Connectivity Sanity Verification: Verifies local network sockets cleanly without crashing out generic shell boundaries.

⚙️ Deployment Compliance Specifications

    Runtime Matrix: Node.js >=18.0.0 engine targets running inside an automated multi-stage compilation footprint.

    Security Boundaries: Active global Content Security Policies (CSP), X-Frame-Options: DENY, and strict X-Content-Type-Options: nosniff header configurations enforced at the edge.

    Release Manifest: Tracking states, compliance maps, and schema structures are anchored natively within the .release-manifest.json ledger.
