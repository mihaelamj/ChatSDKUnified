# ChatSDKUnified

A lightweight, modular **Swift** SDK skeleton for building **real-time**, chat-style features with clean seams between **API** and **transport** layers. Designed for fast iteration during **beta phases** and safe backend swaps without touching your UI.

> Licensed under **Apache-2.0** and distributed as a single **Swift Package** for easy integration into existing apps.

---

## ✨ Goals

- **Unified package**: one Swift Package that encapsulates models, transport, and use-cases.  
- **Real-time friendly**: clear event pipeline for socket-delivered updates.  
- **API-swappable**: adapter layer keeps UI independent of backend wiring.  
- **Beta-ready**: feature flags, verbose logging hooks, and predictable error paths.

---

## 🧱 Architecture


```
App/UI
  │
  ▼
+----------------------+
|    ChatSDKUnified    |
|----------------------|
|  Public Facade       |  ← Simple entry points (connect, sendMessage, etc.)
|----------------------|
|  Use Cases           |  ← Message send/fetch, typing/presence, history sync
|----------------------|
|  Domain Models       |  ← Message, User, Thread, Event, Error
|----------------------|
|  Protocols           |  ← Protocols: MessageRepo, PresenceRepo, SessionRepo
|----------------------|
|  Transport           |  ← SocketClient + HTTPClient (protocol-based)
|    • Socket          |     - connect/reconnect, heartbeat, backoff
|    • REST            |     - requests, auth, retry, decoding
+----------------------+
        │
        ▼
   Backend APIs
```

### Layers at a glance

- **Public Facade**  
  Small surface that the app uses (e.g., `connect()`, `disconnect()`, `messages.send(...)`, `messages.fetchHistory(...)`, `events` stream).
  
- **Use Cases**  
  Task-oriented services orchestrating repositories and transport (send message, sync history, toggle typing, mark read, etc.).
  
- **Domain Models**  
  Pure Swift types—no networking or UI concerns. Stable contracts used across the SDK.
  
- **Protocols**  
  Abstractions that hide persistence and transport. Enable easy swapping/mocking in tests and quick backend transitions.
  
- **Transport**  
  Two independent protocol-driven clients:
  - `SocketClient` for real-time events (connectivity management, pings, exponential backoff, event decoding).
  - `HTTPClient` for RESTful operations (auth injection, retries, error mapping).

### Core protocols (example)

```swift
public protocol SocketClient {
    var events: AnyPublisher<SocketEvent, Never> { get }
    func connect()
    func disconnect()
    func send(_ payload: SocketOutbound)
}

public protocol HTTPClient {
    func send<T: Decodable>(_ request: APIRequest) -> AnyPublisher<T, APIError>
}

public protocol MessagesRepository {
    func send(_ draft: MessageDraft) -> AnyPublisher<MessageAck, DomainError>
    func history(threadID: String, page: Page) -> AnyPublisher<[Message], DomainError>
}

public protocol PresenceRepository {
    func setTyping(threadID: String, isTyping: Bool) -> AnyPublisher<Void, DomainError>
}
```

### Data flow

**Inbound (real-time):**  
`SocketClient` → decode `SocketEvent` → map to `ChatEvent` → reduce into state (repositories/use cases) → publish to `events` → UI updates.

**Outbound (commands):**  
UI intent → Use Case → Repository → Transport (`HTTPClient` or `SocketClient`) → server ack/response → state update → `events`.

### Connection lifecycle

- **Connect** with auth and negotiated capabilities.
- **Heartbeat/Ping** to maintain liveness; missed heartbeats trigger **jittered backoff**.
- **Auto‑reconnect** with capped exponential backoff and resume subscriptions.
- **Graceful close** with reason propagation to the `events` stream.

### Threading model

- Decode and IO on background queues; coalesce and deliver **UI-facing events on main**.
- Backpressure-friendly publishers for bursty streams (typing indicators, bulk history).

### Error handling

- Unified `DomainError` mapped from `APIError`/transport failures.
- Typed categories (auth, network, rate limit, server, decode) with recovery hints.
- Retries with policy (idempotent operations only) and circuit-breaker hooks.

### Configuration & DI

- `ChatConfig` carries base URLs, auth token provider, feature flags, and retry/backoff limits.
- All services accept protocol-based dependencies, enabling **test doubles** and **transport swaps** without touching UI.


## 📦 Installation (Swift Package Manager)

1. In Xcode: **File → Add Packages…**  
2. Enter the repo URL and add the package target to your app.  
3. Import in code:

```swift
import ChatSDKUnified
```

---

## 🚀 Quick Start

```swift
import ChatSDKUnified

// 1) Configure
let config = ChatConfig(
    apiBaseURL: URL(string: "https://api.example.com")!,
    socketURL:  URL(string: "wss://ws.example.com/stream")!,
    authTokenProvider: { /* return bearer token */ }
)

// 2) Build SDK
let sdk = ChatSDK.build(config: config)

// 3) Observe events (thread-safe delivery to main if needed)
let cancellable = sdk.events.sink { event in
    switch event {
    case .connected: print("Socket connected")
    case .messageReceived(let message): print("New:", message.text)
    case .typing(let user, let isTyping): print("\(user.name) typing:", isTyping)
    case .disconnected(let reason): print("Disconnected:", reason)
    }
}

// 4) Connect socket & fetch history
sdk.connect()
sdk.messages.fetchHistory(threadID: "general") { result in
    // update UI
}

// 5) Send a message
sdk.messages.send(text: "Hello world", threadID: "general") { result in
    // handle ack / error
}
```

---

## 🔌 Transport Layer

**SocketClient** (protocol)  
- `connect() / disconnect()`  
- Auto-reconnect with jittered backoff  
- Heartbeat/ping, connection state, and reasoned errors  
- Event decoding → typed `ChatEvent` stream

**HTTPClient** (protocol)  
- Auth injection (token provider or delegate)  
- Request builder with retry policy  
- Uniform error type (`APIError`)

Swap implementations without changing feature code.

---

## 🧪 Testing

- **Contract tests** for each endpoint/event type  
- **Transport fakes** (FakeSocketClient, FakeHTTPClient) for deterministic tests  
- **Golden payloads** for JSON decoding stability

```swift
// Example test seam
let fakeSocket = FakeSocketClient(scriptedEvents: [.connected, .messageReceived(sampleMessage)])
let sdk = ChatSDK.build(config: .test, socketClient: fakeSocket)
```

---

## 🧰 Beta Integration Checklist

- [ ] Add **feature flags** for new API & socket features  
- [ ] Enable **verbose logs** in beta builds only  
- [ ] Configure **reconnect/backoff** bounds (network policy)  
- [ ] Wire **UI observers** to `sdk.events` (main-thread delivery)  
- [ ] Add **kill switch** to fall back to legacy API if needed

---

## 📚 Public Surface (example)

```swift
public protocol ChatSDKType {
    var events: AnyPublisher<ChatEvent, Never> { get }
    var messages: MessagesService { get }
    var presence: PresenceService { get }
    func connect()
    func disconnect()
}

public enum ChatEvent {
    case connected
    case disconnected(ChatDisconnectReason)
    case messageReceived(Message)
    case typing(user: User, isTyping: Bool)
}
```

---

## 🗺️ Roadmap (suggested)

- Offline queue & resend with backoff  
- Local cache (LRU for media, message store compaction)  
- Delta sync for threads  
- Tracing hooks (connect time, retries, dropped events)

---

## ⚖️ License

**Apache-2.0** — see [`LICENSE`](./LICENSE).

---

## 💬 Notes

This repository is a **structure and pattern showcase** for building real-time chat features in Swift. It’s intentionally modular so that teams can:  
- plug in their own transport libraries,  
- adapt to different backend payloads, and  
- move fast in beta without risky UI refactors.

