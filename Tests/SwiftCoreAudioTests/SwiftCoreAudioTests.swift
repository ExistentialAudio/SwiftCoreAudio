import XCTest
@testable import SwiftCoreAudio

final class SwiftCoreAudioTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let audioDevice = try AudioSystem.getAudioDevice(from: "BuiltInSpeakerDevice")
        try print(audioDevice.hogModeProcessID as Any)
        try audioDevice.toggleHodMode()
        try print(audioDevice.hogModeProcessID as Any)
        try audioDevice.toggleHodMode()
        try print(audioDevice.hogModeProcessID as Any)
    }
}
