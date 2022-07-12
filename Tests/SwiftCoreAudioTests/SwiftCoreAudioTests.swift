import XCTest
@testable import SwiftCoreAudio

final class SwiftCoreAudioTests: XCTestCase {
    func testAudioDevice() throws {

        // Run tests on default device.
        let audioDevice = try AudioSystem.defaultOutputDevice
        
        // Changing sample rates
        try audioDevice.setNominalSampleRate(sampleRate: 48000)
        sleep(1) // give a second to change
        try XCTAssertEqual(audioDevice.nominalSampleRate, 48000)
        
        try audioDevice.setNominalSampleRate(sampleRate: 44100)
        sleep(1) // give a second to change
        try XCTAssertEqual(audioDevice.nominalSampleRate, 44100)
        
        // Changing Volume
        try audioDevice.setVolume(for: .output, channel: 0, to: 1.0)
        try XCTAssertEqual(audioDevice.getVolume(for: .output, channel: 0), 1.0)
        try audioDevice.setVolume(for: .output, channel: 0, to: 0.0)
        try XCTAssertEqual(audioDevice.getVolume(for: .output, channel: 0), 0.0)
    }
}
