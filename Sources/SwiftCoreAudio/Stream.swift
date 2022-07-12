//
//  Stream.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio




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
