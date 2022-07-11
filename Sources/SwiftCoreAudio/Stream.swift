//
//  Stream.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

enum AudioDirection {
    case input
    case output
    case unknown
    
    init(value: UInt32) {
        switch value {
        case 0:
            self = .output
        case 1:
            self = .input
        default:
            self = .unknown
        }
    }
}

enum TerminalType {
    case unknown
    case line
    case digitalAudioInterface
    case speaker
    case headphones
    case LFESpeaker
    case receiverSpeaker
    case microphone
    case headsetMicrophone
    case receiverMicrophone
    case TTY
    case HDMI
    case displayPort
    
    init(value: UInt32) {
        switch value {
        case kAudioStreamTerminalTypeLine:
            self = .line
        case kAudioStreamTerminalTypeDigitalAudioInterface:
            self = .digitalAudioInterface
        case kAudioStreamTerminalTypeSpeaker:
            self = .speaker
        case kAudioStreamTerminalTypeHeadphones:
            self = .headphones
        case kAudioStreamTerminalTypeLFESpeaker:
            self = .LFESpeaker
        case kAudioStreamTerminalTypeReceiverSpeaker:
            self = .receiverSpeaker
        case kAudioStreamTerminalTypeMicrophone:
            self = .microphone
        case kAudioStreamTerminalTypeHeadsetMicrophone:
            self = .headsetMicrophone
        case kAudioStreamTerminalTypeReceiverMicrophone:
            self = .receiverMicrophone
        case kAudioStreamTerminalTypeTTY:
            self = .TTY
        case kAudioStreamTerminalTypeHDMI:
            self = .HDMI
        case kAudioStreamTerminalTypeDisplayPort:
            self = .displayPort
        default:
            self = .unknown
        }
    }
}

class Stream: AudioObject {

    public var isActive: Bool {
        get throws {
            try getUInt32(for: kAudioStreamPropertyIsActive) == 0 ? false : true
        }
    }
    
    public var direction: AudioDirection {
        get throws {
            AudioDirection(value: try getUInt32(for: kAudioStreamPropertyDirection))
        }
    }
    
    public var terminalType: TerminalType {
        get throws {
            TerminalType(value: try getUInt32(for: kAudioStreamPropertyDirection))
        }
    }

    public var startingChannel: Int {
        get throws {
            Int(try getUInt32(for: kAudioStreamPropertyStartingChannel))
        }
    }
    
    public var latency: Int {
        get throws {
            Int(try getUInt32(for: kAudioStreamPropertyLatency))
        }
    }

    public var virtualFormat: AudioStreamBasicDescription {
        get throws {
            try getAudioStreamBasicDescription(for: kAudioStreamPropertyVirtualFormat)
        }
    }
    
    public var virtualFormats: [AudioStreamBasicDescription] {
        get throws {
            try getAudioStreamBasicDescriptions(for: kAudioStreamPropertyAvailableVirtualFormats)
        }
    }
    
    public var physicalFormat: AudioStreamBasicDescription {
        get throws {
            try getAudioStreamBasicDescription(for: kAudioStreamPropertyPhysicalFormat)
        }
    }
    
    public var phyicalFormats: [AudioStreamBasicDescription] {
        get throws {
            try getAudioStreamBasicDescriptions(for: kAudioStreamPropertyAvailablePhysicalFormats)
        }
    }
}
