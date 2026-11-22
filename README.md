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
| ![Home](home_page.jpeg) | ![Booking](app2.jpeg) | ![Records](app3.jpeg) |

---

## Getting Started

1. **Clone the repository:**
   ```bash
git clone https://github.com/aylasrhan/wecare-app.git
