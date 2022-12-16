import XCTest
@testable import SwiftCoreAudio
import CoreAudio


final class SwiftCoreAudioTests: XCTestCase {
    
    func testAudioObject() throws {
        
        /// TO DO: Build a test audio objects to test all these items.
        let audioObject = AudioSystem.getAudioDevice(from: "BlackHole2ch_UID")! as AudioObject
        
        print("")
        print("AudioObject Test")
        print("----------------")
        
        print("AudioObjectID: \(audioObject.audioObjectID)")
        print("Name: \(String(describing: audioObject.name))")
        print("identifyIsEnabled: \(String(describing: audioObject.identifyIsEnabled))")
        print("manufacturer: \(String(describing: audioObject.manufacturer))")
        print("elementName: \(String(describing: audioObject.elementName))")
        print("elementNumberName: \(String(describing: audioObject.elementNumberName))")
        print("serialNumber: \(String(describing: audioObject.serialNumber))")
        print("firmwareVersion: \(String(describing: audioObject.firmwareVersion))")
        print("modelName: \(String(describing: audioObject.modelName))")
        print("bassAudioClass: \(String(describing: audioObject.bassAudioClass))")
        print("audioClass: \(String(describing: audioObject.audioClass))")
        print("owner: \(String(describing: audioObject.ownerAudioObjectID))")
    
        print("Owned Objects: \(String(describing: audioObject.ownedObjects.count))")
        audioObject.ownedObjects.forEach({ print($0.audioObjectID)})
        print("")
    }
    
    func testAudioSystem() throws {
        
        let audioSystem = AudioSystem.shared
        
        print("")
        print("AudioSystem Test")
        print("----------------")
        
        // Audio Devices
        XCTAssertNil(AudioSystem.getAudioDevice(from: "Fake_UID"))
        XCTAssertNotNil(AudioSystem.getAudioDevice(from: "BlackHole2ch_UID"))

        XCTAssertNotNil(audioSystem.defaultInputDevice)
        XCTAssertNotNil(audioSystem.defaultOutputDevice)
        XCTAssertNotNil(audioSystem.defaultSystemOutputDevice)

        print("")
        print("Audio Devices:")
        audioSystem.audioDevices.forEach({ print($0.deviceUID! )}) // Fix this

        // PlugIn
        XCTAssertNil(AudioSystem.getAudioPlugIn(from: "audio.existential.Fake"))
        XCTAssertNotNil(AudioSystem.getAudioPlugIn(from: "existential.audio.BlackHole2ch")) // This seems to be a BlackHole bug
        
        print("")
        print("PlugIns:")
        audioSystem.audioPlugIns.forEach { print($0.bundleID) }

        // Box
        XCTAssertNil(AudioSystem.getAudioBox(from: "Fake_UID"))
        XCTAssertNotNil(AudioSystem.getAudioBox(from: "BlackHole2ch_UID"))
        
        print("")
        print("Boxes:")
        audioSystem.audioBoxes.forEach { print($0.uniqueID) }
        
        // TransportManager
        XCTAssertNil(AudioSystem.getTransportManager(from: "Fake_UID"))
        /// TO DO: Build a test TransportManagerto test all these items.
        // XCTAssertNotNil(AudioSystem.getTransportManager(from: "BlackHole2ch_UID"))
        
        print("")
        print("Transport Managers:")
        audioSystem.transportManagers.forEach { print($0.name!) }

        
        // ClockDevice
        XCTAssertNil(AudioSystem.getClockDevice(from: "Fake_UID"))
        /// TO DO: Build a test ClockDevice test all these items.
        // XCTAssertNotNil(AudioSystem.getClockDevice(from: "BlackHole2ch_UID")) // No Clock Devices to Test
        
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
        audioSystem.mixStereoToMono = true
        XCTAssertTrue(audioSystem.mixStereoToMono)
        audioSystem.mixStereoToMono = false
        XCTAssertFalse(audioSystem.mixStereoToMono)
        
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
    
    func testAudioPlugIn() throws {

        guard let audioPlugIn = AudioSystem.getAudioPlugIn(from: "com.stevenslateaudio.VSXSystemwideDriver") else {
            return
        }
        
        print("")
        print("AudioPlugIn Test")
        print("----------------")
        
        print("BundleID: \(audioPlugIn.bundleID)")
        print("AudioDevices: \(audioPlugIn.audioDevices.count)")
        audioPlugIn.audioDevices.forEach({ print($0.deviceUID)})
        print("AudioBoxes: \(audioPlugIn.audioBoxes.count)")
        audioPlugIn.audioBoxes.forEach({ print($0.uniqueID)})
        print("AudioClockDevices: \(audioPlugIn.clockDevices.count)")
        audioPlugIn.clockDevices.forEach({ print($0.uniqueID)})
        
    }
    
    func testAudioBox() throws {
        
        guard let audioBox = AudioSystem.getAudioBox(from: "Pro Tools Audio Bridge 2-A_UID") else {
            return
        }
        
        print("")
        print("AudioBox Test")
        print("----------------")
        
        print("UniqueID: \(audioBox.uniqueID)")
        print("transportType: \(audioBox.transportType)")
        print("hasAudio: \(audioBox.hasAudio)")
        print("hasVideo: \(audioBox.hasVideo)")
        print("hasMIDI: \(audioBox.hasMIDI)")
        print("isProtected: \(audioBox.isProtected)")
        
        // isAquired
        audioBox.isAquired = false
        XCTAssertFalse(audioBox.isAquired)
        audioBox.isAquired = true
        XCTAssertTrue(audioBox.isAquired)
    
        
        print("AudioDevices: \(audioBox.audioDevices.count)")
        audioBox.audioDevices.forEach({ print($0.audioObjectID)})
        print("AudioClockDevices: \(audioBox.clockDevices.count)")
        audioBox.clockDevices.forEach({ print($0.audioObjectID)})
    }
    
    func testAudioDevice() throws {

        guard let audioDevice = AudioSystem.getAudioDevice(from: "Pro Tools Audio Bridge 2-A_UID") else {
            return
        }
        
        print("")
        print("AudioDevice Test")
        print("----------------")
        
        print("configurationApplicationBundleID: \(String(describing: audioDevice.configurationApplicationBundleID))")
        print("deviceUID: \(String(describing: audioDevice.deviceUID))")
        print("modelUID: \(String(describing: audioDevice.modelUID))")
        print("transportType: \(String(describing: audioDevice.transportType))")
        print("clockDomain: \(String(describing: audioDevice.clockDomain))")
        print("isRunning: \(String(describing: audioDevice.isRunning))")
        print("canBeDefaultInputDevice: \(String(describing: audioDevice.canBeDefaultInputDevice))")
        print("canBeDefaultOutputDevice: \(String(describing: audioDevice.canBeDefaultOutputDevice))")
        print("canBeSystemOutputDevice: \(String(describing: audioDevice.canBeSystemOutputDevice))")
        print("latency: \(String(describing: audioDevice.latency))")

//
//        relatedAudioDevices = (try? getData(property: AudioDeviceProperty.RelatedDevices) as? [AudioDeviceID])?.map { AudioDevice(audioObjectID: $0) }
//
        print("streams: ")
        audioDevice.streams.forEach({print($0.audioObjectID)})
        
        print("controls: ")
        audioDevice.controls.forEach({print($0.audioObjectID)})
        
        print("safetyOffset: \(String(describing: audioDevice.safetyOffset))")
        print("nominalSampleRate: \(String(describing: audioDevice.nominalSampleRate))")
        print("availableNominalSampleRates: \(String(describing: audioDevice.availableNominalSampleRates))")
        print("isHidden: \(String(describing: audioDevice.isHidden))")
        print("preferredChannelsForStereo: \(String(describing: audioDevice.preferredChannelsForStereo))")
        print("PreferredChannelLayout: \(String(describing: audioDevice.preferredChannelLayout))")
        
        // Needs completion.

    }
    
    func testAudioStream() throws {
        
        guard let audioDevice = AudioSystem.getAudioDevice(from: "BlackHole2ch_UID") else {
            return
        }
        
        guard let stream = audioDevice.streams.first else {
            return
        }
        
        print("")
        print("AudioStream Test")
        print("----------------")
        
    
        print("isActive: \(stream.isActive)")
        print("direction: \(stream.direction)")
        print("terminalType: \(stream.terminalType)")
        print("startingChannel: \(stream.startingChannel)")
        print("latency: \(stream.latency)")
        print("virtualFormat: \(stream.virtualFormat)")
//        print("virtualFormats: \(stream.virtualFormats)")
        print("physicalFormat: \(stream.physicalFormat)")
//        print("phyicalFormats: \(stream.physicalFormats)")
        
    }
}
