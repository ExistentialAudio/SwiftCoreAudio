import XCTest
@testable import SwiftCoreAudio
import CoreAudio


final class SwiftCoreAudioTests: XCTestCase {
    
    func testAudio() throws {
        
        guard let audioDevice = AudioDevice(uniqueID: "NullAudioDevice_UID") else {
            return
        }
        
        XCTAssertEqual(audioDevice.has(property: AudioObjectProperty.Name), true)
        try XCTAssertEqual(audioDevice.getData(property: AudioObjectProperty.Name) as? String, "Null Audio Device")
    }
    
}
