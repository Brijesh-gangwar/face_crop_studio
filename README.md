# 🧑‍💻 Face Detector Cropper

A powerful Flutter app that uses **on-device AI (Google ML Kit)** to detect **each person's face** in a captured image, automatically crop them, and save the cropped faces to your phone storage — neatly organized by timestamped folders.

Built with:
- **Google ML Kit** (`google_mlkit_face_detection`)
- **Camera** (`camera`) with front & back camera support
- **Provider** state management
- Clean **MVVM** architecture

---

## ✨ Features

- 📸 Real-time camera capture with live preview
- 🤖 AI-powered on-device **face detection**
- ✂️ Automatically **crop each detected face**
- 🔄 **Switch between front & back camera** seamlessly
- ✅ Clean **Provider + MVVM** implementation
- 📂 Save cropped faces to **local storage** (Pictures/FaceCrops)
- 🗂️ Each capture creates its own folder — all faces from one photo grouped together
- 📁 **Browse all saved face folders** with image count
- 🖼️ **View individual cropped faces** in gallery mode
- 🗑️ Auto-delete empty folders after capture
- 📋 File picker integration for selecting images from gallery
- 🔔 User-friendly feedback with snackbar notifications


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

### lib/ Directory

```plaintext
lib/
 ├── main.dart                          # App entry point with Provider setup
 ├── models/
 │   └── face_crop_result.dart          # Face detection result model
 ├── view_models/
 │   └── face_detection_viewmodel.dart  # Core business logic & state management
 ├── views/
 │   ├── home_screen.dart               # Home page with navigation options
 │   ├── face_detection_screen.dart     # Live camera with face detection
 │   ├── face_images_screen.dart        # Gallery view for individual faces
 │   ├── faces_folder_screen.dart       # Browse all saved folders
 │   └── widgets/
 │       └── ImageShowWidget.dart       # Reusable image display widget
 └── utils/
     ├── permissions_utils.dart         # Camera & storage permissions
     ├── storage_utils.dart             # File & folder operations
     ├── image_utils.dart               # Image processing utilities
     └── snackbar_util.dart             # User notifications
```

### Project Root Structure

```plaintext
face_detection_crop/
 ├── lib/                               # Main Flutter app code
 ├── android/                           # Android native code & configuration
 ├── assets/                            # App icons & assets
 ├── build/                             # Build outputs (generated)
 ├── pubspec.yaml                       # Project dependencies & configuration
 ├── README.md                          # Project documentation
 ├── analysis_options.yaml              # Dart analysis rules
 ├── devtools_options.yaml              # DevTools configuration
 ├── face_detection_crop.iml            # IntelliJ project file
 └── gradle files                       # Gradle configuration files
```

---
