# 🧑‍💻 Face Detector Cropper

A simple Flutter app that uses **on-device AI (Google ML Kit)** to detect **each person’s face** in a captured image, automatically crop them, and save the cropped faces to your phone storage — neatly organized by timestamped folders.

Built with:
- **Google ML Kit** (`google_mlkit_face_detection`)
- **Camera** (`camera`)
- **Provider** state management
- Clean **MVVM** architecture

---

## ✨ Features

- 📸 Real-time camera capture
- 🤖 AI-powered on-device **face detection**
- ✂️ Automatically **crop each detected face**
- ✅ Clean **Provider + MVVM** implementation
- 📂 Save cropped faces to **local storage**
- 🗂️ Each capture creates its own folder — all faces from one photo grouped together


---

## ⚙️ How it works

1️⃣ **Open the camera & capture an image**

2️⃣ AI detects **all faces** in the photo

3️⃣ Each face is cropped automatically

4️⃣ All cropped faces are saved in `/Pictures/FaceCrops/capture_<timestamp>/`

5️⃣ Instantly open the folder to see all cropped faces

---

## 🚀 Installation

Add dependencies in your `pubspec.yaml`:

```yaml
dependencies:
  camera: ^<latest_version>
  google_mlkit_face_detection: ^<latest_version>
  image: ^<latest_version>
  open_file: ^<latest_version>
  permission_handler: ^<latest_version>
  provider: ^<latest_version>

```
---


### Run this command to install dependencies

```bash

flutter pub get

```

### Add Android Permissions

Add these lines to your AndroidManifest.xml:

```dart

<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

```

### Run

```bash

flutter run

```
---

## 🚀 Folder Structure

```plaintext

lib/
 ├── main.dart
 ├── models/
 │   └── face_crop_result.dart
 ├── viewmodels/
 │   └── face_detection_viewmodel.dart
 ├── views/
 │   ├── home_screen.dart
 │   ├── face_detection_screen.dart
 ├── utils/
 │   ├── permissions_utils.dart
 │   ├── storage_utils.dart
 │   ├── image_utils.dart
 │   ├── snackbar_utils.dart

```
--- 
