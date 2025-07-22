
# 🛡️ Wispurr — Next-Gen Secure Chat App

> Wispurr is a privacy-first chat application built in Flutter, featuring **facial-recognition-based message access**, end-to-end encryption, and a stealth UI for seamless secure communication.


## 📁 Project Structure

This project follows the **Clean Architecture** pattern with separation of concerns for scalability, testability, and maintainability.

```

lib/
├── app/                  # UI layer (screens, widgets, state)
│   ├── cubits/           # BLoC/Cubit state management
│   ├── screens/          # UI screens (e.g. ChatList, Login, Register)
│   └── widgets/          # Shared UI components (buttons, inputs, etc)
│
├── data/                 # Data layer (actual implementations)
│   ├── datasources/      # Remote/Local APIs, facial auth services
│   ├── models/           # DTOs mapped from JSON/API
│   └── repos/            # Repository implementations
│
├── domain/               # Business logic layer (abstract)
│   ├── entities/         # Core business models (e.g. User, Message)
│   ├── repos/            # Abstract repository contracts
│   └── usecases/         # App-specific business logic
│
├── utils/                # Helpers, constants, formatters
│
└── main.dart             # Entry point of the application

````

---

## 🚀 Features

- 🔐 **FaceID-Based Message Access**
- 🧠 **Encrypted Chat Storage**
- 🧊 **Modern Glitch UI**
- ⚡ **BLoC State Management**
- 📱 Built with **Flutter 3.x**

---

## 🛠️ Getting Started

1. Clone the repository  
   ```
   git clone https://github.com/yourusername/wyspru.git
   cd wyspru
   ```

2. Install dependencies

   ```
   flutter pub get
   ```

3. Run the app

   ```bash
   flutter run
   ```

---

## 🧠 Tech Stack

* **Flutter 3.x**
* **Dart Clean Architecture**
* **BLoC / Cubit**
* **Face Authentication API (TBD)**
* **Hive / Firebase / Custom Backend**

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 💬 Let's Connect

Have feedback or wanna contribute?
Drop in a PR or shoot a message at \[[work.kuntalgain@gmail.com](mailto:work.kuntalgain@gmail.com)].

---
