//
//  File.swift
//  
//
//  Created by Devin Roth on 2022-07-12.
//

import Foundation
import CoreAudio

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
