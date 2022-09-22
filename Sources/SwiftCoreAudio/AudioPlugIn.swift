//
//  AudioPlugIn.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioPlugIn: AudioObject {
    
    @Published public private(set) var bundleID = ""
    
    @Published public private(set) var audioDevices = [AudioDevice]()
    
    @Published public private(set) var audioBoxes = [AudioBox]()
    
    @Published public private(set) var clockDevices = [ClockDevice]()
    
    public init?(bundleID: String) {
        guard let plugIn = try? AudioSystem.getAudioPlugIn(from: bundleID) else {
            return nil
        }
        super.init(audioObjectID: plugIn.audioObjectID)
    }
    
    override init(audioObjectID: AudioObjectID) {
        super.init(audioObjectID: audioObjectID)
    }
    
    override func getProperties() {
        super.getProperties()
        
//        if let bundleID = try? getData(property: AudioPlugInProperty.BundleID) as? String {
//            self.bundleID = bundleID
//        }
//        
//        
//        if let audioObjectID = try? getData(property: AudioSystemProperty.Devices) as? [AudioDeviceID] {
//            self.audioDevices = audioObjectID.map({
//                AudioDevice(audioObjectID: $0)
//            })
//        }
//        
//        if let audioObjectID = try? getData(property: AudioSystemProperty.BoxList) as? [AudioDeviceID] {
//            self.audioBoxes = audioObjectID.map({
//                AudioBox(audioObjectID: $0)
//            })
//        }
//        
//        if let audioObjectID = try? getData(property: AudioSystemProperty.ClockDeviceList) as? [AudioDeviceID] {
//            self.clockDevices = audioObjectID.map({
//                ClockDevice(audioObjectID: $0)
//            })
//        }
    }
    
}
public enum AudioPlugInProperty: CaseIterable, AudioProperty {
    case BundleID
    case DeviceList
    case TranslateUIDToDevice
    case BoxList
    case TranslateUIDToBox
    case ClockDeviceList
    case TranslateUIDToClockDevice
    
    

    
    public var value: UInt32 {
        switch self {
        case .BundleID:
            return kAudioPlugInPropertyBundleID
        case .DeviceList:
            return kAudioPlugInPropertyDeviceList
        case .TranslateUIDToDevice:
            return kAudioPlugInPropertyTranslateUIDToDevice
        case .BoxList:
            return kAudioPlugInPropertyBoxList
        case .TranslateUIDToBox:
            return kAudioPlugInPropertyTranslateUIDToBox
        case .ClockDeviceList:
            return kAudioPlugInPropertyClockDeviceList
        case .TranslateUIDToClockDevice:
            return kAudioPlugInPropertyTranslateUIDToClockDevice
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .BundleID:
            return .CFString
        case .DeviceList:
            return .UInt32Array
        case .TranslateUIDToDevice:
            return .UInt32
        case .BoxList:
            return .UInt32Array
        case .TranslateUIDToBox:
            return .UInt32
        case .ClockDeviceList:
            return .UInt32Array
        case .TranslateUIDToClockDevice:
            return .UInt32
        }
    }
}
