//
//  AudioBox.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioBox: AudioObject {

    public var uniqueID: String?
    
    public var transportType: TransportType?
    
    public var hasAudio: Bool?
    
    public var hasVideo: Bool?
    
    public var hasHDMI: Bool?
    
    public var isProtected: Bool?
    
    public var isAquired: Bool?
 
    public var audioDevices: [AudioDevice]?
    
    public var clockDevices: [ClockDevice]?
}
public enum AudioBoxProperty: CaseIterable, AudioProperty {
    case BoxUID
    case TransportType
    case HasAudio
    case HasVideo
    case HasMIDI
    case IsProtected
    case Acquired // Settable
    case AcquisitionFailed
    case DeviceList
    case ClockDeviceList
    
    public var value: UInt32 {
        switch self {
        case .BoxUID:
            return kAudioBoxPropertyBoxUID
        case .TransportType:
            return kAudioBoxPropertyTransportType
        case .HasAudio:
            return kAudioBoxPropertyHasAudio
        case .HasVideo:
            return kAudioBoxPropertyHasVideo
        case .HasMIDI:
            return kAudioBoxPropertyHasMIDI
        case .IsProtected:
            return kAudioBoxPropertyIsProtected
        case .Acquired:
            return kAudioBoxPropertyAcquired
        case .AcquisitionFailed:
            return kAudioBoxPropertyAcquisitionFailed
        case .DeviceList:
            return kAudioBoxPropertyDeviceList
        case .ClockDeviceList:
            return kAudioBoxPropertyClockDeviceList
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .BoxUID:
            return .CFString
        case .TransportType:
            return .UInt32
        case .HasAudio:
            return .UInt32
        case .HasVideo:
            return .UInt32
        case .HasMIDI:
            return .UInt32
        case .IsProtected:
            return .UInt32
        case .Acquired:
            return .UInt32
        case .AcquisitionFailed:
            return .UInt32
        case .DeviceList:
            return .UInt32Array
        case .ClockDeviceList:
            return .UInt32Array
        }
    }
}
