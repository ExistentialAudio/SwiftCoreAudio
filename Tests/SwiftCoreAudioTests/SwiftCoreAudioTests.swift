import XCTest
@testable import SwiftCoreAudio
import CoreAudio


final class SwiftCoreAudioTests: XCTestCase {
    
    func testAudioDevice() throws {
        
        //let audioDevice = AudioDevice(uniqueID: "BuiltInSpeakerDevice")
        
        //XCTAssertNotNil(audioDevice)

    }
    
    func testAudioSystem() throws {
        let audioSystem = AudioSystem.shared
        
        // Audio Devices
        XCTAssertNil(AudioSystem.getAudioDevice(from: "Fake_UID"))
        XCTAssertNotNil(AudioSystem.getAudioDevice(from: "BlackHole2ch_UID"))

        XCTAssertNotNil(audioSystem.defaultInputDevice)
        XCTAssertNotNil(audioSystem.defaultOutputDevice)
        XCTAssertNotNil(audioSystem.defaultSystemOutputDevice)

        print("")
        print("Audio Devices:")
        audioSystem.audioDevices.forEach({ print($0.name! )}) // Fix this

        // PlugIn
        XCTAssertNil(AudioSystem.getAudioPlugIn(from: "audio.existential.Fake"))
        XCTAssertNotNil(AudioSystem.getAudioPlugIn(from: "BlackHole2ch.driver")) // This seems to be a BlackHole bug
        
        print("")
        print("PlugIns:")
        audioSystem.audioPlugIns.forEach { print($0.name!) }

        // Box
        XCTAssertNil(AudioSystem.getAudioBox(from: "Fake_UID"))
        XCTAssertNotNil(AudioSystem.getAudioBox(from: "BlackHole2ch_UID"))
        
        print("")
        print("Boxes:")
        audioSystem.audioBoxes.forEach { print($0.name!) }
        
        // TransportManager
        XCTAssertNil(AudioSystem.getTransportManager(from: "Fake_UID"))
//        XCTAssertNotNil(AudioSystem.getTransportManager(from: "BlackHole2ch_UID")) // No Transport Managers to Test
        
        print("")
        print("Transport Managers:")
        audioSystem.transportManagers.forEach { print($0.name!) }

        
        // ClockDevice
        XCTAssertNil(AudioSystem.getClockDevice(from: "Fake_UID"))
//        XCTAssertNotNil(AudioSystem.getClockDevice(from: "BlackHole2ch_UID")) // No Clock Devices to Test
        
        print("")
        print("Clock Devices:")
        audioSystem.clockDevices.forEach { print($0.name!) }
        
        _ = audioSystem.userSessionIsActiveOrHeadless
        _ = audioSystem.processIsMain
        _ = audioSystem.isInitingOrExiting
        
        // Unloading Is Allowed
        audioSystem.unloadingIsAllowed = false
        XCTAssertFalse(audioSystem.unloadingIsAllowed)
        audioSystem.unloadingIsAllowed = true
        XCTAssertTrue(audioSystem.unloadingIsAllowed)
        
        // Mix Stereo To Mono
        audioSystem.mixStereoToMono = false
        XCTAssertFalse(audioSystem.mixStereoToMono)
        audioSystem.mixStereoToMono = true
        XCTAssertTrue(audioSystem.mixStereoToMono)
        
        // Process Is Audible
        audioSystem.processIsAudible = false
        XCTAssertFalse(audioSystem.processIsAudible)
        audioSystem.processIsAudible = true
        XCTAssertTrue(audioSystem.processIsAudible)
        
        // Hog Mode
        audioSystem.hogModeIsAllowed = false
        XCTAssertFalse(audioSystem.hogModeIsAllowed)
        audioSystem.hogModeIsAllowed = true
        XCTAssertTrue(audioSystem.hogModeIsAllowed)
        
        // Power Saver
        audioSystem.powerSaverIsEnabled = false
        XCTAssertFalse(audioSystem.powerSaverIsEnabled)
        audioSystem.powerSaverIsEnabled = true
        XCTAssertTrue(audioSystem.powerSaverIsEnabled)
        
        audioSystem.userIDChanged()
        
        print("")
    }
    
}
