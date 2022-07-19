//
//  Stream.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio




public class Stream: AudioObject {

    public var isActive: Bool?
    
    public var direction: AudioDirection?
    
    public var terminalType: TerminalType?

    public var startingChannel: Int?
    
    public var latency: Int?

    public var virtualFormat: AudioStreamBasicDescription?
    
    public var virtualFormats: [AudioStreamBasicDescription]?
    
    public var physicalFormat: AudioStreamBasicDescription?
    
    public var phyicalFormats: [AudioStreamBasicDescription]?
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
