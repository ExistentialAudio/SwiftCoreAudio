//
//  AudioPlugIn.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioPlugIn: AudioObject {
    
    public var bundleID: String?
    
    public var audioDevices: [AudioDevice]?
    
    public var audioBoxes: [AudioBox]?
    
    public var clockDevices: [ClockDevice]?
    
    // These are redundant. 
    //kAudioPlugInPropertyTranslateUIDToDevice
    //kAudioPlugInPropertyTranslateUIDToBox
    //kAudioPlugInPropertyTranslateUIDToClockDevice
//    kAudioPlugInCreateAggregateDevice   = 'cagg',
//    kAudioPlugInDestroyAggregateDevice  = 'dagg'
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
