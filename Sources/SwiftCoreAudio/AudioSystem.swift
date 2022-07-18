//
//  AudioSystem.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio



public class AudioSystem: AudioObject {
    
    public static let shared = AudioSystem(audioObjectID: AudioObjectID(kAudioObjectSystemObject))
     
    @Published public var audioDevices = [AudioDevice]()

    @Published public var audioPlugIns = [AudioPlugIn]()

    @Published public var transportManagers = [TransportManager]()

    @Published public var audioBoxes = [AudioBox]()

    @Published public var clockDevices = [ClockDevice]()

    @Published public var defaultInputDevice: AudioDevice?

    @Published public var defaultOutputDevice: AudioDevice?

    @Published public var defaultSystemOutputDevice: AudioDevice?
    
    @Published public var mixStereoToMono: Bool?
    
    @Published public var processIsMain: Bool?
    
    @Published public var isInitingOrExiting: Bool?

    @Published public var processIsAudible: Bool?
    
    @Published public var sleepingIsAllowed: Bool?
    
    @Published public var unloadingIsAllowed: Bool?
    
    @Published public var hogModeIsAllowed: Bool?
    
    @Published var userSessionIsActiveOrHeadless: Bool?

    public enum PowerHint: Int {
        case none = 0
        case favorSavingPower
    }

    @Published public var powerHint: PowerHint?
    
    private override init(audioObjectID: AudioObjectID) {
        super.init(audioObjectID: audioObjectID)
    }

    static public func getAudioDevice(from uniqueID: String) -> AudioDevice? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            print("Invalid Audio Device UID: \(uniqueID)")
            return nil
        }
        
        return AudioDevice(audioObjectID: audioDeviceID)
    }

    static public func getAudioPlugIn(from uniqueID: String) throws -> AudioPlugIn? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return AudioPlugIn(audioObjectID: audioDeviceID)
    }

    static public func getTransportManager(from uniqueID: String) throws -> TransportManager? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return TransportManager(audioObjectID: audioDeviceID)
    }

    static public func getAudioBox(from uniqueID: String) throws -> AudioBox? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return AudioBox(audioObjectID: audioDeviceID)
    }

    static public func getClockDevice(from uniqueID: String) throws -> ClockDevice? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return ClockDevice(audioObjectID: audioDeviceID)
    }

    public func userIDChanged() {}
//
//    // Only for notifications.
////    kAudioHardwarePropertyServiceRestarted                      = 'srst',
//
//    static func unload() {
//        AudioHardwareUnload()
//    }
//
//    #warning("To Do")
//    static func createAggregateDevice() {
//
//    }
//
//    static func destroyAggregateDevice() {
//
//    }

}
