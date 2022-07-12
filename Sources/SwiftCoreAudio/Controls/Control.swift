//
//  AudioControl.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

enum Scope {
    case input
    case output
    case playThrough
    case unknown

    init(value: UInt32) {
        switch value {
        case kAudioDevicePropertyScopeInput:
            self = .input
        case kAudioDevicePropertyScopeOutput:
            self = .output
        case kAudioDevicePropertyScopePlayThrough:
            self = .playThrough
        default:
            self = .unknown
        }
    }
}

class Control: AudioObject {
    
    public var scope: Scope {
        get throws {
            try Scope(value: getUInt32(for: kAudioControlPropertyScope))
        }
    }
    
    public var element: Int {
        get throws {
            Int(try getUInt32(for: kAudioControlPropertyElement))
        }
    }
}
