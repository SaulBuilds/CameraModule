import AVFoundation

#if canImport(UIKit)
import UIKit  // Import UIKit for iOS
#endif

@available(macOS 10.15, *)
public class CameraManager: NSObject, AVCapturePhotoCaptureDelegate {
    private var captureSession: AVCaptureSession?
    
    // No `@available` here; use optional properties for version-specific usage
    private var photoOutput: AVCapturePhotoOutput?
    
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // UIImage and capturedImage are only for platforms with UIKit (iOS)
    #if canImport(UIKit)
    private var capturedImage: UIImage?
    #endif

    // WebSocketTask is available in iOS 13+ and macOS 10.15+
    private var webSocketTask: URLSessionWebSocketTask?

    // MARK: - Camera Permissions
    public func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        if #available(macOS 10.14, *) {
            let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthStatus {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    completion(granted)
                }
            @unknown default:
                completion(false)
            }
        } else {
            // Handle older macOS versions
            completion(false)
        }
    }

    // MARK: - Camera Setup
    #if canImport(UIKit)
    public func configureSession(for view: UIView) {
        captureSession = AVCaptureSession()
        
        if #available(macOS 10.15, *) {
            photoOutput = AVCapturePhotoOutput()
        }

        guard let captureSession = captureSession,
              let photoOutput = photoOutput else {
            return
        }

        captureSession.beginConfiguration()

        // Add camera input
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera),
              captureSession.canAddInput(input) else {
            return
        }
        captureSession.addInput(input)

        // Add photo output
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.addOutput(photoOutput)

        captureSession.commitConfiguration()

        // Add preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.bounds
        view.layer.addSublayer(previewLayer!)

        captureSession.startRunning()
    }
    #endif

    // MARK: - Taking Pictures
    public func takePicture() {
        if #available(macOS 10.15, *) {
            let settings = AVCapturePhotoSettings()
            photoOutput?.capturePhoto(with: settings, delegate: self)
        }
    }

    // MARK: - AVCapturePhotoCaptureDelegate
    #if canImport(UIKit)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            return
        }
        capturedImage = image
        
        // Save to photo library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    #endif

    // MARK: - Display Image
    #if canImport(UIKit)
    public func displayCapturedImage(on imageView: UIImageView) {
        imageView.image = capturedImage
    }
    #endif

    // MARK: - WebSocket Communication
    public func setupWebSocketConnection() {
        if #available(macOS 10.15, *) {
            let url = URL(string: "ws://your-websocket-url.com")!
            let urlSession = URLSession(configuration: .default)
            webSocketTask = urlSession.webSocketTask(with: url)
            webSocketTask?.resume()

            // Start receiving messages from WebSocket (optional)
            receiveMessage()
        }
    }

    public func sendImageOverWebSocket() {
        if #available(macOS 10.15, *) {
            #if canImport(UIKit)
            guard let image = capturedImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }

            let message = URLSessionWebSocketTask.Message.data(imageData)
            webSocketTask?.send(message) { error in
                if let error = error {
                    print("WebSocket sending error: \(error)")
                } else {
                    print("Image sent successfully via WebSocket.")
                }
            }
            #endif
        }
    }

    // Receiving WebSocket messages (optional)
    private func receiveMessage() {
        if #available(macOS 10.15, *) {
            webSocketTask?.receive { [weak self] result in
                switch result {
                case .success(let message):
                    switch message {
                    case .data(let data):
                        print("Received data: \(data.count) bytes")
                    case .string(let text):
                        print("Received string: \(text)")
                    @unknown default:
                        break
                    }
                case .failure(let error):
                    print("WebSocket receiving error: \(error)")
                }
                
                // Continue receiving messages
                self?.receiveMessage()
            }
        }
    }

    public func closeWebSocket() {
        if #available(macOS 10.15, *) {
            webSocketTask?.cancel(with: .goingAway, reason: nil)
        }
    }
}
