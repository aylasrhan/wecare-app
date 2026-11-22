# WeCare – Healthcare Mobile Application (Flutter Frontend)

**WeCare** is a cross-platform healthcare mobile application built with **Flutter** and **Dart**, designed to streamline medical appointment booking, patient diagnosis tracking, and real-time audio/video consultations. The app follows **Clean Architecture** and **SOLID** principles and communicates seamlessly with a dedicated PHP/Laravel RESTful backend.

> **Backend Repository:** The RESTful API and database architecture powering this app can be found at [**HealthNexus (Laravel Backend)**](https://github.com/aylasrhan/HealthNexus).

---

## Key Features

- **Role-Based Authentication & Profiles:** Secure onboarding, registration, and profile management tailored for both patients and doctors.
- **Appointment Scheduling:** End-to-end appointment booking, clinical visit management, and status tracking.
- **Real-Time Audio & Video Consultations:** Integrated **ZEGOCLOUD SDK** for low-latency in-app audio/video calls with native incoming call notifications.
- **Medical Diagnosis & Records:** Structured access to clinical visit history, prescriptions, vital signs, and diagnostic reports.
- **Adaptive & Localized UI:** Responsive layouts for phones and tablets (`flutter_screenutil`) supporting seamless **Arabic (RTL)** and **English (LTR)** localization.

---

## Tech Stack & Architecture

- **Framework:** Flutter, Dart
- **Architecture & State Management:** Clean Architecture, SOLID Principles, BLOC / Cubit
- **Networking & Storage:** RESTful API Integration, Local Data Caching
- **Real-Time Communication:** ZEGOCLOUD SDK
- **UI & Utilities:** `flutter_screenutil`, Responsive RTL/LTR Layouts

---

## Screenshots

| Home & Specialists | Appointment Booking | Medical Diagnosis & Records |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/6ed66a50-b11c-4254-b9cf-e5b4fd61b1af" width="240"/> | <img src="https://github.com/user-attachments/assets/1c303a08-c1f4-4c42-9493-6cf934888686" width="240"/> | <img src="https://github.com/user-attachments/assets/bf20f8cf-a760-45a9-ae66-8a0b59bd06bb" width="240"/> |

---

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/aylasrhan/wecare-app.git](https://github.com/aylasrhan/wecare-app.git)
