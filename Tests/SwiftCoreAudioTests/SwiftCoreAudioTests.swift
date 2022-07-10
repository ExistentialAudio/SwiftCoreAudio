import XCTest
@testable import SwiftCoreAudio

final class SwiftCoreAudioTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        XCTAssertNoThrow(try AudioObject(audioObjectID: 122).name, "Throws")
        XCTAssertEqual(try AudioObject(audioObjectID: 122).name, "U28E590", "")
        
        print(try AudioSystem.defaultInputDevice.name)
        print(try AudioSystem.defaultOutputDevice.name)
        
        
        for device in try AudioSystem.devices {
            print(try device.name)
        }
    }
}
