//
//  AudioBox.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioBox: AudioObject {

    @Published public private(set) var uniqueID = "Unknown"
    
    @Published public private(set) var transportType = TransportType.unknown
    
    @Published public private(set) var hasAudio = false
    
    @Published public private(set) var hasVideo = false
    
    @Published public private(set) var hasMIDI = false
    
    @Published public private(set) var isProtected = false
    
    @Published public var isAquired = false  {
        didSet {
            do {
                try setData(property: AudioBoxProperty.Acquired, data: isAquired)
            } catch {
                isAquired = oldValue
            }
        }
    }
 
    @Published public private(set) var audioDevices = [AudioDevice]()
    
    @Published public private(set) var clockDevices = [ClockDevice]()
    
    public init?(uniqueID: String) {
        guard let audioBox = try? AudioSystem.getAudioBox(from: uniqueID) else {
            return nil
        }
        
        super.init(audioObjectID: audioBox.audioObjectID)
    }
    
    override init(audioObjectID: AudioObjectID) {
        super.init(audioObjectID: audioObjectID)
    }
    
    override func getProperties() {
        super.getProperties()
        
//        if let uniqueID = try? getData(property: AudioBoxProperty.BoxUID) as? String {
//            self.uniqueID = uniqueID
//        }
//        
//        if let value = try? getData(property: AudioBoxProperty.HasAudio) as? UInt32 {
//            hasAudio = value != 0
//        }
//        
//        if let value = try? getData(property: AudioBoxProperty.HasMIDI) as? UInt32 {
//            hasMIDI = value != 0
//        }
//        
//        if let value = try? getData(property: AudioBoxProperty.IsProtected) as? UInt32 {
//            isProtected = value != 0
//        }
//        
//        if let value = try? getData(property: AudioBoxProperty.Acquired) as? UInt32 {
//            isAquired = value != 0
//        }
//        
//        if let audioObjectID = try? getData(property: AudioBoxProperty.DeviceList) as? [AudioDeviceID] {
//            self.audioDevices = audioObjectID.map({
//                AudioDevice(audioObjectID: $0)
//            })
//        }
//        
//        if let audioObjectID = try? getData(property: AudioBoxProperty.ClockDeviceList) as? [AudioDeviceID] {
//            self.clockDevices = audioObjectID.map({
//                ClockDevice(audioObjectID: $0)
//            })
//        }
//        
//        if let value = try? getData(property: AudioBoxProperty.TransportType) as? UInt32 {
//            self.transportType = TransportType(value: value)
//        }
    }
    
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
            return kAudioBoxPropertyAcquisitionFailed // Notification only
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

protocol SomeProtocol {
    
}

struct SomeStruct {
    var someStructs = [SomeProtocol]()
}
