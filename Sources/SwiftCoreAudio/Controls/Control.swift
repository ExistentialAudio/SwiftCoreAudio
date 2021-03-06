//
//  AudioControl.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public enum Scope {
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

public class Control: AudioObject {
    
    public var scope: Scope?
    
    public var channel: Int?
}


enum AudioControlProperty: CaseIterable, AudioProperty {
    case Scope
    case Element
    
    public var value: UInt32 {
        switch self {
        case .Scope:
            return kAudioControlPropertyScope
        case .Element:
            return kAudioControlPropertyElement
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .Scope:
            return .UInt32
        case .Element:
            return .UInt32
        }
    }
}
