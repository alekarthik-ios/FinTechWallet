# FinTechWallet

# FinTech Wallet App

A production-grade modular iOS fintech application built with Swift 6, SwiftUI, and Clean Architecture. Demonstrates enterprise-level patterns used at companies like PayPal, Stripe, and Robinhood — including secure token management, protocol-driven dependency injection, and zero feature-to-feature coupling.

---

## Screenshots

| Login | Wallet Dashboard | Send Money |
|:---:|:---:|:---:|


<img width="1206" height="2622" alt="1" src="https://github.com/user-attachments/assets/dd880a36-a1e9-4535-907a-71ddcb5056c3" />


<img width="1206" height="2622" alt="2" src="https://github.com/user-attachments/assets/8d174a2f-e346-43ac-9953-16c1a11682c2" />


<img width="1206" height="2622" alt="3" src="https://github.com/user-attachments/assets/976d809e-1e42-4a02-a58f-c463a830a4bc" />

---

## Architecture

### Module Dependency Graph

```
┌─────────────────────────────────────────────────────────┐
│                     walletApp                           │
│              (AppCoordinator + Entry Point)              │
│                                                         │
│     ┌──────────┐  ┌──────────────┐  ┌───────────────┐  │
│     │ Feature  │  │   Feature    │  │    Feature     │  │
│     │  Login   │  │   Wallet     │  │   SendMoney    │  │
│     └────┬─────┘  └──────┬───────┘  └───────┬────────┘  │
│          │               │                  │           │
│          │    ┌──────────┴──────────┐       │           │
│          │    │   NO CROSS-FEATURE  │       │           │
│          │    │      IMPORTS        │       │           │
│          │    └─────────────────────┘       │           │
│          │               │                  │           │
│     ┌────▼───────────────▼──────────────────▼────────┐  │
│     │              Core Layer                        │  │
│     │                                                │  │
│     │  ┌────────────────┐  ┌───────────────────┐     │  │
│     │  │ CoreNetworking │  │    CoreStorage     │     │  │
│     │  │  NetworkClient │  │  KeychainService   │     │  │
│     │  │    Endpoint    │  │  (Secure Tokens)   │     │  │
│     │  └────────────────┘  └───────────────────┘     │  │
│     │                                                │  │
│     │  ┌────────────────────────────────────────┐    │  │
│     │  │           SharedModels                  │    │  │
│     │  │    AuthToken · Wallet · Transaction     │    │  │
│     │  └────────────────────────────────────────┘    │  │
│     └────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Layer Architecture (per feature)

```
View → ViewModel → UseCase → Repository → NetworkClient → API
 │         │          │           │
 │    @MainActor   Business    Protocol
 │    @Published    Rules      Injection
 │                   │
 │              Keychain Auth
 │              (CoreStorage)
 │
 Dumb UI — renders + forwards taps only
```

---

## Key Design Decisions

### 1. Feature Isolation via Core Bridging
Features communicate through the Core layer, never through each other. Login writes the auth token to Keychain; Wallet reads it from Keychain. Zero `import FeatureLogin` inside `FeatureWallet`.

### 2. Protocol-Driven Dependency Injection
Every layer holds the protocol of the next layer, not the concrete class. This enables mock injection for testing and makes swapping implementations (e.g., real vs. demo networking) a one-line change in the Coordinator.

### 3. Coordinator Owns Navigation
Features expose navigation events via closures (`onLoginSuccess`, `onSendMoneyTapped`). The AppCoordinator sets these closures and manages screen transitions via a published `AppState` enum. Features remain navigation-unaware.

### 4. Composition Over Mutation
The Wallet screen needs both balance and transactions. Rather than bloating the `Wallet` model, a view-specific `WalletDashboard` composes `Wallet` + `[Transaction]` inside the feature module — keeping SharedModels pure.

### 5. UseCase Owns Business Logic
Validation (amount > 0, non-empty recipient), authentication checks (Keychain token read), and idempotency key generation all live in the UseCase layer — not in ViewModels or Repositories. Any new UI (Watch, Widget) gets the same rules for free.

---

## Tech Stack

| Category | Technologies |
|---|---|
| **Language** | Swift 6 (strict concurrency) |
| **UI** | SwiftUI, SF Symbols |
| **Architecture** | MVVM-C, Clean Architecture, Coordinator Pattern |
| **Concurrency** | async/await, @MainActor, Sendable |
| **Security** | Keychain Services, biometric auth patterns, PCI-DSS awareness |
| **Modularization** | Swift Package Manager (6 packages) |
| **Networking** | Protocol-based NetworkClient, Codable, generic request<T> |
| **Testing** | XCTest, protocol-based mocking, AAA pattern |
| **Data** | JSONEncoder/Decoder, Keychain persistence |

---

## Module Structure

```
walletApp/
├── walletApp/                    # App target
│   ├── walletAppApp.swift        # Entry point + state-driven routing
│   ├── AppCoordinator.swift      # Wires all dependencies + navigation
│   └── DemoNetworkClient.swift   # Mock server (4 endpoints)
│
├── CoreNetworking/               # SPM Package
│   ├── Endpoint.swift            # API endpoint enum
│   ├── NetworkClient.swift       # URLSession-based client
│   └── NetworkClientProtocol.swift
│
├── CoreStorage/                  # SPM Package
│   └── KeychainService.swift     # Secure token read/write/delete
│
├── SharedModels/                 # SPM Package
│   ├── AuthToken.swift           # Codable + Sendable
│   ├── Wallet.swift              # Balance model
│   └── Transaction.swift         # Transaction with status enum
│
├── FeatureLogin/                 # SPM Package
│   ├── LoginRepository.swift
│   ├── LoginUseCase.swift        # Auth + Keychain save
│   ├── LoginViewModel.swift      # @MainActor + @Published
│   ├── LoginView.swift           # Gradient UI
│   └── Tests/
│       ├── MockNetworkClient.swift
│       └── LoginUseCaseTests.swift  # 2 test cases
│
├── FeatureWallet/                # SPM Package
│   ├── WalletDashboard.swift     # Composition model
│   ├── WalletRepository.swift    # Balance + transactions fetch
│   ├── WalletUseCase.swift       # Auth check + data orchestration
│   ├── WalletViewModel.swift     # Formats balance, publishes state
│   ├── WalletView.swift          # Dashboard + transaction list
│   └── Tests/
│       ├── MockKeychainService.swift
│       ├── MockWalletRepository.swift
│       └── WalletUseCaseTests.swift  # 3 test cases
│
└── FeatureSendMoney/             # SPM Package
    ├── SendMoneyRepository.swift
    ├── SendMoneyUseCase.swift    # Validation + auth + send
    ├── SendMoneyViewModel.swift  # String→Double + error handling
    ├── SendMoneyView.swift       # Input form + success/error states
    └── Tests/
        ├── MockKeychainService.swift
        ├── MockSendMoneyRepository.swift
        └── SendMoneyUseCaseTests.swift  # 4 test cases
```

---

## Test Coverage

**9 unit tests** across 3 test suites covering UseCase business logic:

| Test Suite | Tests | Validates |
|---|---|---|
| `LoginUseCaseTests` | 2 | Login success, network failure |
| `WalletUseCaseTests` | 3 | Dashboard fetch, no auth token, repo failure |
| `SendMoneyUseCaseTests` | 4 | Valid send, no auth, invalid amount, empty recipient |

All tests use **protocol-based mock injection** — no network calls, no Keychain access, fully deterministic.

---

## How To Run

1. Clone the repository
   ```bash
   git clone https://github.com/alekarthik-ios/FinTechWallet.git
   ```
2. Open `walletApp.xcodeproj` in **Xcode 16+**
3. Select an iOS 15+ simulator
4. **Cmd+R** to build and run
5. **Cmd+U** to run all tests

> The app uses `DemoNetworkClient` — no backend server required. All data is mocked locally.

---

## What This Project Demonstrates

- **Enterprise modularization** — 6 SPM packages with enforced dependency boundaries
- **Secure data handling** — Keychain-based token persistence across feature boundaries
- **Testable architecture** — Protocol injection enables isolated unit testing with zero side effects
- **Swift 6 concurrency** — Sendable conformance, @MainActor isolation, async/await throughout
- **Production patterns** — Feature flags, idempotency keys, input validation, error propagation
- **Clean separation of concerns** — Views render, ViewModels coordinate, UseCases enforce rules, Repositories fetch data

---

## Author

**Karthik Ale** — iOS Engineer  
[LinkedIn]https://www.linkedin.com/in/karthik518/ · [Email](mailto:alekarthik51@gmail.com)
