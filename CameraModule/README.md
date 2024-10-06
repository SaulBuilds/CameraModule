# CameraModule

CameraModule is a standalone Swift package that provides functionality for capturing photos using the device's camera, saving the captured photos to the user's photo library, and sending the image data via a WebSocket connection.

## Features
- Request camera permissions.
- Capture photos using the camera.
- Save photos to the user's photo library.
- Display the captured image.
- Send image data via WebSocket.

## Installation

To add CameraModule as a dependency to your project:

1. In Xcode, go to `File > Add Packages`.
2. Add the URL of your CameraModule repository.

## Usage

### Import CameraModule

```swift
import CameraModule

let cameraManager = CameraManager()

// Check for camera permission and configure session
cameraManager.checkCameraPermission { granted in
    if granted {cameraManager.configureSession(for: yourView)
    }
}

// Take a picture
cameraManager.takePicture()

// Display the captured image
cameraManager.displayCapturedImage(on: yourImageView)

// Send image via WebSocket
cameraManager.setupWebSocketConnection()
cameraManager.sendImageOverWebSocket()
```

### How to Import the Package into Another Project

1. Open your main project in Xcode.
2. Go to **File > Add Packages**.
3. Enter the URL or location of your `CameraModule` package and add it to your project.

Once it's added, you can import and use it like any other Swift package:

