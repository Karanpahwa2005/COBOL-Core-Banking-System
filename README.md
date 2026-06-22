# 🏦 COBOL Mini Core Banking Ledger System

A high-performance, minimalist, file-based core banking application built from scratch in native **COBOL**. This project bypasses modern high-level abstractions to explore how enterprise financial architectures natively handle deterministic memory layout allocations and binary transaction logging.

---

## 🚀 System Overview

While modern fintech applications rely on massive framework layers, roughly 70% of the world's live banking systems and 43% of active financial institutions still process core transaction data using COBOL. 

This repository implements a lightweight **Banking Ledger Engine** designed to handle critical account transactions natively within a terminal environment, preserving state across sessions via low-level flat-file databases.

### Key Capabilities
* **Pristine Account Provisioning:** Creates records using explicit byte allocation grids.
* **Real-Time Data Persistence:** Writes account states directly to disk using sequential data blocks.
* **Dynamic Transaction Processing:** Executes mathematical operations for deposits and cash withdrawals.
* **Deterministic Ledger Validation:** Enforces strict execution guardrails, including real-time Insufficient Balance checks.

---

## 🛠️ Technical Deep Dive & Architectural Patterns

### 1. Deterministic Grid Layouts (`DATA DIVISION`)
COBOL requires absolute byte-level declarations for all program variables. There are no implicit types or dynamic garbage collection processes.
* Data is stored using precise character strings (`PIC X`) and numeric floating-point grids (`PIC 9(7)V99`), where the `V` character represents a hardware-implicit decimal point to guarantee zero rounding errors.

### 2. Mainframe Binary Storage Flow
Instead of connecting to an external relational SQL database or an ORM layer, the system leverages COBOL's optimized storage formats:
* **The Master-File Pattern:** To avoid carriage return/newline character bugs across modern operating systems, the application utilizes `ORGANIZATION IS SEQUENTIAL`.
* **State Mutation Strategy:** To perform a balance update, the system executes an enterprise ledger rewrite loop: it streams records from the original file, modifies data elements in volatile memory upon matching the target Account ID, pipes the stream into a temporary dataset file, and executes a atomic terminal file swap to overwrite the master registry (`accounts.dat`).

---

## 💻 Getting Started Natively (Windows 11)

This project has been compiled and validated using the open-source **GnuCOBOL 3.2 (MinGW)** environment.

### Prerequisites
To run the environment without complex environment variable path configurations, ensure you have the GnuCOBOL environment package installed on your local drive.

### Fast Launch Execution
The repository includes a pre-configured launcher script (**`run.bat`**) that automatically maps compiler variables, aligns the drive directory, and boots the transaction interface in a single action.

1. Clone or download this repository to your local drive (`D:\CobolBanking`).
2. Double-click **`run.bat`** to activate the core interface immediately.

Alternatively, compile manually from your COBOL-enabled terminal prompt:
```cmd
cobc -x -o banking.exe banking.cob
banking.exe  
