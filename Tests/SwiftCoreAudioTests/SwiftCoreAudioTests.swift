import XCTest
@testable import SwiftCoreAudio
import CoreAudio


final class SwiftCoreAudioTests: XCTestCase {
    
    func testAudio() throws {
        
        let audioDevice = AudioDevice(uniqueID: "NullAudioDevice_UID")

        XCTAssertNotNil(audioDevice)
        
        XCTAssertEqual(audioDevice?.has(property: AudioObjectProperty.Name), true)
        try XCTAssertEqual(audioDevice?.getData(property: AudioObjectProperty.Name) as? String, "Null Audio Device")
        
        
        XCTAssertNotNil(AudioSystem.shared.name)
        
    }
    
}
