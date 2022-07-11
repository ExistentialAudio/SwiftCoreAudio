//
//  AudioSystem.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class AudioSystem: AudioObject {
    
    public static let audioSystem = AudioSystem(audioObjectID: AudioObjectID(kAudioObjectSystemObject))
    
    static public var audioDevices: [AudioDevice] {
        get throws {
            let audioDeviceIDs = try audioSystem.getInts(for: kAudioHardwarePropertyDevices)
            var audioDevices = [AudioDevice]()
            for audioDeviceID in audioDeviceIDs {
                audioDevices.append(AudioDevice(audioObjectID: audioDeviceID))
            }
            
            return audioDevices
        }
    }
    
    static public var audioPlugIns: [AudioPlugIn] {
        get throws {
            let audioPlugInIDs = try audioSystem.getInts(for: kAudioHardwarePropertyPlugInList)
            var audioPlugIns = [AudioPlugIn]()
            for audioPlugInID in audioPlugInIDs {
                audioPlugIns.append(AudioPlugIn(audioObjectID: audioPlugInID))
            }
            
            return audioPlugIns
        }
    }
    
    static public var transportManagers: [TransportManager] {
        get throws {
            let audioObjectIDs = try audioSystem.getInts(for: kAudioHardwarePropertyTransportManagerList)
            var transportManagers = [TransportManager]()
            for audioObjectID in audioObjectIDs {
                transportManagers.append(TransportManager(audioObjectID: audioObjectID))
            }
            
            return transportManagers
        }
    }
    
    static public var audioBoxes: [AudioBox] {
        get throws {
            let audioObjectIDs = try audioSystem.getInts(for: kAudioHardwarePropertyBoxList)
            var audioBoxes = [AudioBox]()
            for audioObjectID in audioObjectIDs {
                audioBoxes.append(AudioBox(audioObjectID: audioObjectID))
            }
            
            return audioBoxes
        }
    }
    
    static public var clockDevices: [ClockDevice] {
        get throws {
            let audioObjectIDs = try audioSystem.getInts(for: kAudioHardwarePropertyClockDeviceList)
            var clockDevices = [ClockDevice]()
            for audioObjectID in audioObjectIDs {
                clockDevices.append(ClockDevice(audioObjectID: audioObjectID))
            }
            
            return clockDevices
        }
    }
    
    static public var defaultInputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultInputDevice))
        }
    }
    
    static public var defaultOutputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultOutputDevice))
        }
    }
    
    static public var defaultSystemOutputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultSystemOutputDevice))
        }
    }
    
    static public func getAudioDevice(from uniqueID: String) throws -> AudioDevice {
        return AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateUIDToDevice, qualifier: uniqueID))
    }
    
    static public func getAudioPlugIn(from uniqueID: String) throws -> AudioPlugIn {
        return AudioPlugIn(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateBundleIDToPlugIn, qualifier: uniqueID))
    }
    
    static public func getTransportManager(from uniqueID: String) throws -> TransportManager {
        return TransportManager(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateBundleIDToTransportManager, qualifier: uniqueID))
    }
    
    static public func getAudioBox(from uniqueID: String) throws -> AudioBox {
        return AudioBox(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateUIDToBox, qualifier: uniqueID))
    }
    
    static public func getClockDevice(from uniqueID: String) throws -> ClockDevice {
        return ClockDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateUIDToClockDevice, qualifier: uniqueID))
    }
    
    #warning("Come up with better names.")
    static public var mixStereoToMono: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyMixStereoToMono) != 0
        }
    }
    
    static public func setMixStereoToMono(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyMixStereoToMono, to: isEnabled ? 1 : 0)
    }
    
    static public var processIsMain: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyProcessIsMain) != 0
        }
    }
    
    static public var isInitingOrExiting: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyIsInitingOrExiting) != 0
        }
    }
    
    static public func userIDChanged() throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyUserIDChanged, to: 0)
    }
    
    static public var processIsAudible: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyProcessIsAudible) != 0
        }
    }
    
    static public func setProcessIsAudible(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyProcessIsAudible, to: isEnabled ? 1 : 0)
    }
    
    static public var sleepingIsAllowed: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertySleepingIsAllowed) != 0
        }
    }
    
    static public func setSleepingIsAllowed(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertySleepingIsAllowed, to: isEnabled ? 1 : 0)
    }
    
    static public var unloadingIsAllowed: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyUnloadingIsAllowed) != 0
        }
    }
    
    static public func setUnloadingIsAllowed(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyUnloadingIsAllowed, to: isEnabled ? 1 : 0)
    }
    
    static public var hogModeIsAllowed: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyHogModeIsAllowed) != 0
        }
    }
    
    static public func setHogModeIsAllowed(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyHogModeIsAllowed, to: isEnabled ? 1 : 0)
    }
    
    static public var userSessionIsActiveOrHeadless: Bool {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyUserSessionIsActiveOrHeadless) != 0
        }
    }
    
    static public func setUserSessionIsActiveOrHeadless(to isEnabled: Bool) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyUserSessionIsActiveOrHeadless, to: isEnabled ? 1 : 0)
    }
    
    public enum PowerHint: Int {
        case none = 0
        case favorSavingPower
    }
    
    static public var powerHint: PowerHint {
        get throws {
            return try audioSystem.getInt(for: kAudioHardwarePropertyPowerHint) == 0 ? .none : .favorSavingPower
        }
    }
    
    static public func setPowerHint(to powerHint: PowerHint) throws {
        try audioSystem.setInt(for: kAudioHardwarePropertyPowerHint, to: UInt32(powerHint.rawValue))
    }

    // Only for notifications.
//    kAudioHardwarePropertyServiceRestarted                      = 'srst',

    static func unload() {
        AudioHardwareUnload()
    }
    
    #warning("To Do")
    static func createAggregateDevice() {

    }
    
    static func destroyAggregateDevice() {
        
    }

}
