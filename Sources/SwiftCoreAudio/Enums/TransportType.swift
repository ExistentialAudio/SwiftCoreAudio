//
//  File.swift
//  
//
//  Created by Devin Roth on 2022-07-11.
//

import Foundation
import CoreAudio

public enum TransportType {
    case unknown
    case builtIn
    case aggregate
    case virtual
    case PCI
    case USB
    case fireWire
    case bluetooth
    case bluetoothLE
    case HDMI
    case displayPort
    case airPlay
    case AVB
    case thunderbolt
    
    init(value: UInt32) {
        switch value {
        case kAudioDeviceTransportTypeBuiltIn:
            self = .builtIn
        case kAudioDeviceTransportTypeAggregate:
            self = .aggregate
        case kAudioDeviceTransportTypeVirtual:
            self = .virtual
        case kAudioDeviceTransportTypePCI:
            self = .PCI
        case kAudioDeviceTransportTypeUSB:
            self = .USB
        case kAudioDeviceTransportTypeFireWire:
            self = .fireWire
        case kAudioDeviceTransportTypeBluetooth:
            self = .bluetooth
        case kAudioDeviceTransportTypeBluetoothLE:
            self = .bluetoothLE
        case kAudioDeviceTransportTypeHDMI:
            self = .HDMI
        case kAudioDeviceTransportTypeDisplayPort:
            self = .displayPort
        case kAudioDeviceTransportTypeAirPlay:
            self = .airPlay
        case kAudioDeviceTransportTypeAVB:
            self = .AVB
        case kAudioDeviceTransportTypeThunderbolt:
            self = .thunderbolt
        default:
            self = .unknown
        }
    }
    
}
