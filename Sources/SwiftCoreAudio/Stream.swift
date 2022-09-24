//
//  Stream.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio




public class Stream: AudioObject {

    public var isActive = false
    
    public var direction: AudioDirection = .unknown
    
    public var terminalType: TerminalType = .unknown

    public var startingChannel = 0
    
    public var latency = 0

    public var virtualFormat = AudioStreamBasicDescription()
    
    public var virtualFormats = [AudioStreamBasicDescription]()
    
    public var physicalFormat = AudioStreamBasicDescription()
    
    public var physicalFormats = [AudioStreamBasicDescription]()
    
    override func getProperties() {
        super.getProperties()
        
        if let data = try? getData(property: AudioStreamProperty.IsActive) as? UInt32 {
            isActive = data != 0
        }
        
        if let data = try? getData(property: AudioStreamProperty.Direction) as? UInt32 {
            direction = AudioDirection(value: data)
        }
        
        if let data = try? getData(property: AudioStreamProperty.TerminalType) as? UInt32 {
            terminalType = TerminalType(value: data)
        }
        
        if let data = try? getData(property: AudioStreamProperty.StartingChannel) as? UInt32 {
            startingChannel = Int(data)
        }
        
        if let data = try? getData(property: AudioStreamProperty.Latency) as? UInt32 {
            latency = Int(data)
        }
        
        if let data = try? getData(property: AudioStreamProperty.VirtualFormat) as? AudioStreamBasicDescription {
            virtualFormat = data
        }
//
//        if let data = try? getData(property: AudioStreamProperty.AvailableVirtualFormats) as? [AudioStreamBasicDescription] {
//            //virtualFormats = data
//        }
//
        if let data = try? getData(property: AudioStreamProperty.PhysicalFormat) as? AudioStreamBasicDescription {
            physicalFormat = data
        }

//        if let data = try? getData(property: AudioStreamProperty.AvailablePhysicalFormats) as? [AudioStreamBasicDescription] {
//            //physicalFormats = data
//        }
    }
    
}
public enum AudioStreamProperty: CaseIterable, AudioProperty {
    case IsActive
    case Direction
    case TerminalType
    case StartingChannel
    case Latency
    case VirtualFormat
    case AvailableVirtualFormats
    case PhysicalFormat
    case AvailablePhysicalFormats
    
    public var value: UInt32 {
        switch self {
        case .IsActive:
            return kAudioStreamPropertyIsActive
        case .Direction:
            return kAudioStreamPropertyDirection
        case .TerminalType:
            return kAudioStreamPropertyTerminalType
        case .StartingChannel:
            return kAudioStreamPropertyStartingChannel
        case .Latency:
            return kAudioStreamPropertyLatency
        case .VirtualFormat:
            return kAudioStreamPropertyVirtualFormat
        case .AvailableVirtualFormats:
            return kAudioStreamPropertyAvailableVirtualFormats
        case .PhysicalFormat:
            return kAudioStreamPropertyPhysicalFormat
        case .AvailablePhysicalFormats:
            return kAudioStreamPropertyAvailablePhysicalFormats
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .IsActive:
            return .UInt32
        case .Direction:
            return .UInt32
        case .TerminalType:
            return .UInt32
        case .StartingChannel:
            return .UInt32
        case .Latency:
            return .UInt32
        case .VirtualFormat:
            return .AudioStreamBasicDescription
        case .AvailableVirtualFormats:
            return .AudioStreamBasicDescriptionArray
        case .PhysicalFormat:
            return .AudioStreamBasicDescription
        case .AvailablePhysicalFormats:
            return .AudioStreamBasicDescriptionArray
        }
    }
}
