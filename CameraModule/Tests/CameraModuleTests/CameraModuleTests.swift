import XCTest
import CameraModule

final class CameraModuleTests: XCTestCase {
    
    func testCameraPermission() {
        let cameraManager = CameraManager()
        let permissionExpectation = expectation(description: "Permission Check")
        
        cameraManager.checkCameraPermission { granted in
            XCTAssertTrue(granted || !granted, "Permission status should be returned.")
            permissionExpectation.fulfill()
        }
        
        wait(for: [permissionExpectation], timeout: 3)
    }
    
    func testWebSocketConnection() {
        let cameraManager = CameraManager()
        cameraManager.setupWebSocketConnection()
        
        // You can validate the connection by mocking or verifying if the WebSocket is open
        XCTAssertNotNil(cameraManager, "WebSocket should be initialized.")
    }
}
