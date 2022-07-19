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
    
    @Published public var mixStereoToMono = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.MixStereoToMono, data: mixStereoToMono)
            } catch {
                mixStereoToMono = oldValue
            }
        }
    }
    
    @Published public var processIsMain = false
    
    @Published public var isInitingOrExiting = false

    @Published public var processIsAudible = false
    
    @Published public var sleepingIsAllowed = false
    
    @Published public var unloadingIsAllowed = false
    
    @Published public var hogModeIsAllowed = false
    
    @Published public var userSessionIsActiveOrHeadless = false

    public enum PowerHint: Int {
        case none = 0
        case favorSavingPower
    }

    @Published public var powerHint = PowerHint.none
    
    private override init(audioObjectID: AudioObjectID) {
        super.init(audioObjectID: audioObjectID)
    }
    
    override func getProperties() {
        super.getProperties()
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.Devices) as? [AudioDeviceID] {
            self.audioDevices = audioObjectID.map({
                AudioDevice(audioObjectID: $0)
            })
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.PlugInList) as? [AudioDeviceID] {
            self.audioPlugIns = audioObjectID.map({
                AudioPlugIn(audioObjectID: $0)
            })
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.TransportManagerList) as? [AudioDeviceID] {
            self.transportManagers = audioObjectID.map({
                TransportManager(audioObjectID: $0)
            })
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.BoxList) as? [AudioDeviceID] {
            self.audioBoxes = audioObjectID.map({
                AudioBox(audioObjectID: $0)
            })
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.ClockDeviceList) as? [AudioDeviceID] {
            self.clockDevices = audioObjectID.map({
                ClockDevice(audioObjectID: $0)
            })
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultInputDevice) as? AudioDeviceID {
            self.defaultInputDevice = AudioDevice(audioObjectID: audioObjectID)
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultOutputDevice) as? AudioDeviceID {
            self.defaultOutputDevice = AudioDevice(audioObjectID: audioObjectID)
        }
        
        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultSystemOutputDevice) as? AudioDeviceID {
            self.defaultSystemOutputDevice = AudioDevice(audioObjectID: audioObjectID)
        }
        
        if let value = try? getData(property: AudioSystemProperty.MixStereoToMono) as? UInt32 {
            mixStereoToMono = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.ProcessIsMain) as? UInt32 {
            processIsMain = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.IsInitingOrExiting) as? UInt32 {
            isInitingOrExiting = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.ProcessIsAudible) as? UInt32 {
            processIsAudible = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.UnloadingIsAllowed) as? UInt32 {
            unloadingIsAllowed = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.HogModeIsAllowed) as? UInt32 {
            hogModeIsAllowed = value != 0
        }
        
        if let value = try? getData(property: AudioSystemProperty.UserSessionIsActiveOrHeadless) as? UInt32 {
            userSessionIsActiveOrHeadless = value != 0
        }
        
        if let powerHintRawValue = try? getData(property: AudioSystemProperty.PowerHint) as? UInt32 {
            if let powerHint = PowerHint(rawValue: Int(powerHintRawValue)) {
                self.powerHint = powerHint
            }
        }
        
    }

    static func getAudioDevice(from uniqueID: String) -> AudioDevice? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            print("Invalid Audio Device UID: \(uniqueID)")
            return nil
        }
        
        return AudioDevice(audioObjectID: audioDeviceID)
    }

    static func getAudioPlugIn(from uniqueID: String) throws -> AudioPlugIn? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return AudioPlugIn(audioObjectID: audioDeviceID)
    }

    static func getTransportManager(from uniqueID: String) throws -> TransportManager? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return TransportManager(audioObjectID: audioDeviceID)
    }

    static func getAudioBox(from uniqueID: String) throws -> AudioBox? {
        guard let audioDeviceID = try? AudioSystem.shared.getData(property: AudioSystemProperty.TranslateUIDToDevice, qualifier: uniqueID) as? UInt32 else {
            return nil
        }
        
        guard audioDeviceID != 0 else {
            return nil
        }
        
        return AudioBox(audioObjectID: audioDeviceID)
    }

    static func getClockDevice(from uniqueID: String) throws -> ClockDevice? {
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
