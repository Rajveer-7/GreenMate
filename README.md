# Capstone-Project
 
## 📌 Project Overview
GreenMate is an AI-powered mobile app that helps plant owners with personalized care guidance.

---

## **🚀 1️⃣ Setting Up Flutter & Android Studio**
### 🔹 **Download & Install Flutter**
#### LINK: https://docs.flutter.dev/get-started/install
#### - Please follow the installation documentation for a successful installation of flutter


## 🚀 2️⃣ Install Android Studio & SDK Tools

### 🔹 Step 1: Download & Install Android Studio

### 🔹 Step 2: Install Android SDK
#### 1) Open Android Studio.
#### 2) Click on More Actions → SDK Manager.
#### 3) Go to SDK Tools and install:
#### ✅ Android SDK Command-line Tools (latest)
#### ✅ Android SDK Platform-Tools
#### ✅ Android Emulator

 ## 3️⃣ Verify Flutter Setup
#### Run: powershell -  "flutter doctor"
#### ✅ If all checks pass, you're good!
#### ❌ If Android licenses are missing, run:
#### powershell  - "flutter doctor --android-licenses" 
#### Ensure you have completed all steps while installing flutter from their documentation.
#### Press Y to accept licenses.

## 4️⃣ Install VS Code Extensions (Optional)
#### Flutter Extension (Ctrl + Shift + X → Search Flutter).
#### Dart Extension (Ctrl + Shift + X → Search Dart).

⚙️ NDK Compatibility (Important for All Group Members)
📌 This project requires Android NDK version 27.0.12077973

To install:

Open Android Studio > SDK Manager > SDK Tools

Enable NDK (Side by side) and select 27.0.12077973

In your android/build.gradle.kts, make sure this line is included: