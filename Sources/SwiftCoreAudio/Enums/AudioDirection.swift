//
//  File.swift
//  
//
//  Created by Devin Roth on 2022-07-12.
//

import Foundation
import CoreAudio

enum AudioDirection: Int {
    case input = 1
    case output = 0
    case unknown = -1
    
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

enum AudioScope {
    case global
    case input
    case output
    case playthrough
    case wildcard
    
    init(value: UInt32) {
        switch value {
        case kAudioObjectPropertyScopeInput:
            self = .input
        case kAudioObjectPropertyScopeOutput:
            self = .output
        case kAudioObjectPropertyScopePlayThrough:
            self = .playthrough
        case kAudioObjectPropertyScopeWildcard:
            self = .wildcard
        default:
            self = .global
        }
    }
    
    var value: UInt32 {
        get {
            switch self {
            case .global:
                return kAudioObjectPropertyScopeGlobal
            case .input:
                return kAudioObjectPropertyScopeInput
            case .output:
                return kAudioObjectPropertyScopeOutput
            case .playthrough:
                return kAudioObjectPropertyScopePlayThrough
            case .wildcard:
                return kAudioObjectPropertyScopeWildcard
            }
        }
    }
}
