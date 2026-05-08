# InstagramClone – iOS Social Media App

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange" alt="Swift 6">
  <img src="https://img.shields.io/badge/iOS-17.0+-blue" alt="iOS 17+">
  <img src="https://img.shields.io/badge/Xcode-16.0+-blueviolet" alt="Xcode 16+">
  <img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Services-success" alt="MVVM">
  <img src="https://img.shields.io/badge/Backend-Firebase%20(Auth%2C%20Firestore%2C%20Storage)-yellow" alt="Firebase">
  <img src="https://img.shields.io/badge/Tests-Unit%20%7C%20Mocks-brightgreen" alt="Tests">
</p>

A **full‑featured Instagram clone** built entirely with SwiftUI and Firebase.  
It’s not just a UI copy — it implements authentication, multiple‑image posts, stories, search, follow/unfollow, profiles, and a comprehensive unit test suite.  
The app uses **MVVM architecture** with a **protocol‑oriented service layer**, making every component testable and scalable.

---

## 📱 Features

| Feature | Description |
|---------|-------------|
| 🔐 **Authentication** | Email / password sign‑up and log‑in via Firebase Auth, with session persistence |
| 🏠 **Feed** | Scrollable feed of posts from followed users, with like & comment placeholders |
| 📸 **Post Creation** | Upload multiple images/videos (via Firebase Storage) and write a caption |
| 📖 **Stories** | View stories from followers in a horizontal row; tap to watch with auto‑progress |
| 🔍 **Search** | Search users by username and navigate to their profile |
| 👥 **Follow/Unfollow** | Manage followers and following lists in real‑time |
| 👤 **Profile** | View user profile with post grid, follower counts, and follow button |
| ✏️ **Edit Profile** | Update bio, username, and profile picture |
| 🌓 **Dark/Light Theme** | Singleton theme manager with a dedicated Settings screen (in‑app theme toggle) |
| 🧪 **Unit Tests** | Mock services, protocol‑oriented design, async/await tested across all view models |

---

## 🧱 Architecture
```
┌───────────────────────────────┐
│ SwiftUI Views │
│ Login, Feed, Profile, etc. │
└──────────────┬────────────────┘
│ observes / sends actions
┌──────────────▼────────────────┐
│ ViewModel │
│ AuthVM, FeedVM, ProfileVM… │
└──────────────┬────────────────┘
│ uses (via protocols)
┌──────────────▼────────────────┐
│ Service Layer │
│ AuthService, UserService, │
│ PostService, StoryService │
└──────────────┬────────────────┘
│
┌──────────────▼────────────────┐
│ Firebase │
│ Auth / Firestore / Storage │
└───────────────────────────────┘

```

- **Views** are passive; they observe view models and send user actions.
- **ViewModels** hold `@Published` state, implement business logic, and call services.
- **Services** are abstracted behind **protocols** so they can be mocked for testing.
- **Dependency Injection** is used throughout – view models receive their services via initializer injection (with default real implementations).

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| UI | SwiftUI |
| Architecture | MVVM + Services (protocol‑oriented) |
| Backend | Firebase Auth, Firestore, Firebase Storage |
| Navigation | `NavigationStack` with custom coordination |
| State Management | Combine (`@Published`, `ObservableObject`) |
| Testing | XCTest, mocks, async/await |
| Minimum Target | iOS 17.0 |
| Language | Swift 6 |

---

## 📂 Project Structure
```
InstagramCloneApp/
├── App/
│ ├── InstagramCloneApp.swift # @main, FirebaseApp.configure()
│ └── RootView.swift # Auth check → Login or MainTabView
├── Model/
│ ├── User.swift # Codable user model
│ ├── Post.swift # Codable post model (likes array)
│ └── Story.swift # Codable story model (isSeenBy array)
├── Service/
│ ├── AuthService.swift # Firebase Auth wrapper
│ ├── UserService.swift # Firestore user CRUD
│ ├── PostService.swift # Post upload + fetch
│ ├── StoryService.swift # Story upload + fetch
│ └── ServiceProtocols.swift # All service protocols (for DI & testing)
├── ViewModel/
│ ├── AuthViewModel.swift
│ ├── FeedViewModel.swift
│ ├── ProfileViewModel.swift
│ ├── SearchViewModel.swift
│ └── StoryViewModel.swift
├── View/
│ ├── Auth/ LoginView, SignUpView
│ ├── Main/ MainTabView, FeedView, SearchView, PostCreationView, NotificationsView, ProfileView, EditProfileView
│ └── Components/ PostCell, StoryRowView, StoryCell, StoryViewer, ImagePicker, StatCell, ShimmerView
├── Core/ ThemeManager.swift (Singleton), Animation+Extensions.swift
├── Resources/ GoogleService-Info.plist, Assets.xcassets
```
##📬 Contact
---
Chetan Purohit
iOS Developer
chetan81289@outlook.com
---
