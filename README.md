<p align="center">
  <img src="assets/logos/cis_logo2.png" alt="CrustaScan Logo" width="130" />
</p>

# CrustaScan - Crustaceans Identifier System (Local App)

> A locally-runnable version of the CrustaScan Flutter application, migrated from Firebase to PostgreSQL for offline/self-hosted use.

This is the local frontend repository for the **CIS (Crustaceans Identifier System)**, a thesis project under the Computer Science program.

> **Note:** This is the local version of the app. The original cloud-based version (Firebase + AWS) is no longer active. This repository was created so students can run the full system locally using Docker.

---

## About the Project

CrustaScan identifies crustacean species by capturing or uploading an image. This local version connects to a self-hosted Flask API running in Docker instead of AWS, and uses PostgreSQL instead of Firebase for data persistence.

### Supported Species

| Common Name        | Local Name | Scientific Name      |
| ------------------ | ---------- | -------------------- |
| Blue Swimming Crab | Alimasag   | _Portunus pelagicus_ |
| Mud Crab           | Alimango   | _Scylla serrata_     |
| River Crab         | Talangka   | _Varuna litterata_   |
| Giant Tiger Prawn  | Sugpo      | _Penaeus monodon_    |
| Whiteleg Shrimp    | Suati      | _Penaeus vannamei_   |

---

## Features

- **Image Capture & Upload** - Identify species via camera or gallery
- **Species Identification** - Real-time prediction with confidence score
- **Species Details** - View scientific name, family, population status, and sample image
- **History** - Save and review past identification results
- **Favorites** - Bookmark identified species for quick access
- **User Authentication** - Register and login (PostgreSQL-backed)
- **Guest Mode** - Use the app without creating an account

---

## Tech Stack

| Layer      | Technology                          |
| ---------- | ----------------------------------- |
| Framework  | Flutter                             |
| Language   | Dart                                |
| Database   | PostgreSQL (migrated from Firebase) |
| API        | Local Flask API via Docker          |
| Build Tool | Flutter CLI                         |

---

## Screenshots

### Onboarding Page

Introduces the app's core features to first-time users before they get started.

<p float="left">
  <img src="assets/screenshots/onboarding/1.png" width="200" />
  <img src="assets/screenshots/onboarding/2.png" width="200" />
  <img src="assets/screenshots/onboarding/3.png" width="200" />
  <img src="assets/screenshots/onboarding/4.png" width="200" />
  <img src="assets/screenshots/onboarding/5.png" width="200" />
</p>

### Login Page

Allows users to sign in with their account or continue as a guest.

<p float="left">
  <img src="assets/screenshots/login/1.png" width="200" />
  <img src="assets/screenshots/login/2.png" width="200" />
  <img src="assets/screenshots/login/3.png" width="200" />
</p>

### Home Page

The main dashboard where users can navigate to identify a species, view past results, view favorites, or customize profile.

<p float="left">
  <img src="assets/screenshots/home/1.png" width="200" />
  <img src="assets/screenshots/home/2.png" width="200" />
  <img src="assets/screenshots/home/3.png" width="200" />
  <img src="assets/screenshots/home/4.png" width="200" />
  <img src="assets/screenshots/home/5.png" width="200" />
  <img src="assets/screenshots/home/6.png" width="200" />
</p>

### Prediction

Displays the identified crustacean species along with its details and save modal.

<p float="left">
  <img src="assets/screenshots/prediction/1.png" width="200" />
  <img src="assets/screenshots/prediction/2.png" width="200" />
  <img src="assets/screenshots/prediction/3.png" width="200" />
  <img src="assets/screenshots/prediction/4.png" width="200" />
  <img src="assets/screenshots/prediction/5.png" width="200" />
  <img src="assets/screenshots/prediction/6.png" width="200" />
  <img src="assets/screenshots/prediction/7.png" width="200" />
  <img src="assets/screenshots/prediction/8.png" width="200" />
</p>

---

## Prerequisites

Before running the app, make sure you have the following installed:

**Git**

```bash
git --version
# Install: https://git-scm.com/download/win
```

**Flutter SDK**

```bash
flutter --version
# Install: https://docs.flutter.dev/get-started/install
flutter doctor
```

**Android Studio or VS Code**

- [Android Studio](https://developer.android.com/studio)
- [VS Code](https://code.visualstudio.com/)
- Android SDK + Emulator (optional)

**System Requirements**
| Requirement | Minimum |
|---|---|
| OS | Windows 10/11 |
| RAM | 16 GB |
| Storage | 10 GB free |
| Network | Internet (for dependencies) |

---

## Getting Started

### Step 1: Clone the repository

```bash
git clone https://github.com/gh-kimcharles/CIS-crustascan-app_local.git
cd CIS-crustascan-app_local
```

### Step 2: Install dependencies

```bash
# Clean previous builds (recommended)
flutter clean

# Install dependencies
flutter pub get
```

### Step 3: Verify Flutter setup

```bash
flutter doctor
flutter devices
```

If no devices are detected:

- **Physical device** - Enable USB Debugging → Connect via USB → Allow USB debugging on device
- **Emulator** - Open Android Studio → AVD Manager → Start Emulator

### Step 4: Build APK

**Option A - Emulator**

```bash
flutter build apk --release --dart-define=API_URL=http://10.0.2.2:5000
```

**Option B - Physical Android Device**

First, get your local IP address:

```bash
# Windows
ipconfig
# Look for "IPv4 Address" under your active network adapter
# Example: 192.168.1.100
```

Then build with your IP:

```bash
flutter build apk --release --dart-define=API_URL=http://192.168.1.100:5000
```

### Step 5: Install the APK

The APK will be located at:

```
build/app/outputs/flutter-apk/app-release.apk
```

- **Emulator** - Drag and drop `app-release.apk` onto the emulator window
- **Physical device** - Copy the APK to your device and install it

---

## Important Note on the APK

A pre-built APK is available via the link below, but it uses the default API config and **cannot connect to your local Flask API**.

[Download Pre-built APK](https://drive.google.com/file/d/1KC7fQuVDFVSr3BYsZdMeplnmgxbPzrD1/view?usp=drive_link)

It is **recommended to build your own APK** (Step 4 above) to connect to your local Docker-hosted Flask API with database and model access.

---

## Related Repository

- **Local Backend API:** [CIS-crustascan-api_local](https://github.com/gh-kimcharles/CIS-crustascan-api_local) - Flask API + PostgreSQL + Docker

> Make sure the API is running before launching the app. See the API repository for Docker setup instructions.

---

## Video Demonstration

[Watch Demo](https://drive.google.com/file/d/1ejugzzH8qdswk8ppI4_RXW85UTToT9hC/view?usp=sharing)

---

## Authors

Local version of the CrustaScan (Mobile App) by Kim Charles M. De Guzman, migrated from Firebase to PostgreSQL and containerized with Docker for self-hosted use.

---

## License

This project was developed for academic purposes as part of a Computer Science thesis at Holy Angel University.
