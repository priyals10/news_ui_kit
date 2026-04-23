# Kabar News - Project Figures and Tables
### Supplementary Figures and Tables for the B.Tech internship report.

---

## 1. Figures

### Figure 1.1: Kabar Logo Design
The logo represents the modern, minimalist, and digital nature of the platform.

![Kabar Logo Design](C:\Users\shah_\.gemini\antigravity\brain\730e1e2b-f999-4bcb-aeae-04b85fefedd2\kabar_logo_design_1775579282447.png)

---

### Figure 3.1: Use Case Diagram
Describes user interactions with the Kabar system modules.

```mermaid
useCaseDiagram
    actor User
    User --> (SignUp / Login)
    User --> (Select Personalized Topics)
    User --> (Update Profile Details)
    User --> (Publish News Articles)
    User --> (Bookmark News for Offline)
```

---

### Figure 3.2: Class Diagram
Structural relationship between entities, repositories, and state management units.

```mermaid
classDiagram
    class UserEntity {
        +String uid
        +String name
        +String email
    }
    class UserNews {
        +String title
        +String content
        +String imageUrl
        +DateTime createdAt
    }
    class NewsRepository {
        <<interface>>
        +getNews()
        +saveNews()
    }
    class AuthBloc {
        +submitCredentials()
        +signOut()
    }

    UserEntity "1" *-- "0..*" UserNews : authors
    AuthBloc ..> NewsRepository : coordinates
    NewsRepository <|.. NewsRepositoryImpl
    NewsRepositoryImpl --> RemoteDataSource
    NewsRepositoryImpl --> LocalDataSource
```

---

### Figure 3.3: Sequence Diagram (Login Flow)
Step-by-step interaction between UI, BLoC, UseCases, and Firebase Backend.

```mermaid
sequenceDiagram
    participant V as View (UI)
    participant B as AuthBloc
    participant U as SignInUseCase
    participant R as AuthRepository
    participant F as Firebase Backend

    V->>B: Submit Credentials (Email/Pass)
    B->>B: Emit AuthLoading state
    B->>U: call(params)
    U->>R: signIn(email, password)
    R->>F: requestAuth()
    F-->>R: success(UserCredential)
    R-->>U: return UserEntity
    U-->>B: return UserEntity
    B->>B: Emit Authenticated state
    B-->>V: Update UI (Navigate Home)
```

---

### Figure 3.4: Activity Diagram (Offline Synchronization)
Logic flow for fetching news and managing the local Isar cache.

```mermaid
stateDiagram-v2
    [*] --> CheckConnection
    CheckConnection --> FetchRemote : Online
    FetchRemote --> CacheInIsar
    CacheInIsar --> DisplayToUser
    
    CheckConnection --> FetchLocal : Offline
    FetchLocal --> DisplayToUser
    
    state FetchRemote {
        [*] --> ApiRequest
        ApiRequest --> DataReceived
    }
    
    state FetchLocal {
        [*] --> IsarQuery
        IsarQuery --> LocalDataFound
    }
```

---

### Figure 3.5: Clean Architecture Layer Diagram
The project strictly follows the **Clean Architecture** patterns as shown below.

---

### Figure 6.1: Home Screen with Trending News
High-fidelity mockup of the "Kabar" home screen showing the topic-based categories and trending headlines carousel.

![Home Screen Mockup](C:\Users\shah_\.gemini\antigravity\brain\730e1e2b-f999-4bcb-aeae-04b85fefedd2\home_screen_trending_news_1775579304026.png)

---

## 2. Tables

### Table 2.1: Hardware and Software Specifications
Summary of technical requirements for the Kabar application's development and deployment.

| Specification | Hardware Requirements | Software Requirements |
| :--- | :--- | :--- |
| **Minimum** | 2GB RAM, i5 Quad-Core | Android 5.0+, iOS 12.0+ |
| **Recommended** | 16GB RAM, i7 Processor | Flutter 3.7.2, Dart 3.x |
| **Infrastructure** | Android/iOS Device, Emulators | Firebase Auth, Isar, Cloudinary |
| **Memory Capacity** | 100MB free storage | Windows 10/11, macOS, Linux |

---

### Table 5.1: Summary of Test Results
Detailed matrix of primary feature testing and performance validation.

| Test ID | Feature Under Test | Test Scenario | Expected Outcome | Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-01** | **Auth Flow** | Valid email/password log-in | Access granted to home screen | **PASS** |
| **TC-02** | **Offline Mode** | Disable internet and view news | Display cached news from Isar | **PASS** |
| **TC-03** | **Bookmarking** | Click bookmark icon on article | Article persists in local store | **PASS** |
| **TC-04** | **Data Sync** | Create news while offline | Article syncs when online detected | **PASS** |
| **TC-05** | **Profile Update** | Upload profile image | Cloudinary URL saved in user doc | **PASS** |
| **TC-06** | **Search** | Query "Tech" in search bar | Display matching news results | **PASS** |

---

### Additional Notes for Submission
- **Figures:** All images should be printed in color.
- **Tables:** Should follow portrait orientation as per University guidelines.
- **Diagrams:** The Mermaid architecture diagram should be clearly legible.
