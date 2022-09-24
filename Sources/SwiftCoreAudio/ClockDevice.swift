//
//  ClockDevice.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class ClockDevice: AudioObject {
    
    @Published public private(set) var uniqueID = "Unknown"
    
    //    kAudioTransportManagerClassID   = 'trpm'
//    kAudioBoxClassID    = 'abox'
//    kAudioDeviceClassID = 'adev'
//    kAudioClockDeviceClassID    = 'aclk'
    
//    kAudioClockDevicePropertyDeviceUID                   = 'cuid',
//    kAudioClockDevicePropertyTransportType               = 'tran',
//    kAudioClockDevicePropertyClockDomain                 = 'clkd',
//    kAudioClockDevicePropertyDeviceIsAlive               = 'livn',
//    kAudioClockDevicePropertyDeviceIsRunning             = 'goin',
//    kAudioClockDevicePropertyLatency                     = 'ltnc',
//    kAudioClockDevicePropertyControlList                 = 'ctrl',
//    kAudioClockDevicePropertyNominalSampleRate           = 'nsrt',
//    kAudioClockDevicePropertyAvailableNominalSampleRates = 'nsr#'
    
//    public init?(uniqueID: String) {
//        
//        guard let clockDevice = try? AudioSystem.getClockDevice(from: uniqueID) else {
//            return nil
//        }
//        
//        super.init(audioObjectID: clockDevice.audioObjectID)
//
//    }
    
//    override init(audioObjectID: AudioObjectID) {
//        super.init(audioObjectID: audioObjectID)
//    }
    
}

public enum AudioClockDeviceProperty: CaseIterable, AudioProperty {
    case DeviceUID
    case TransportType
    case ClockDomain
    case DeviceIsAlive
    case DeviceIsRunning
    case Latency
    case ControlList
    case NominalSampleRate
    case AvailableNominalSampleRates
    
    public var value: UInt32 {
        switch self {
        case .DeviceUID:
            return kAudioClockDevicePropertyDeviceUID
        case .TransportType:
            return kAudioClockDevicePropertyTransportType
        case .ClockDomain:
            return kAudioDevicePropertyClockDomain
        case .DeviceIsAlive:
            return kAudioClockDevicePropertyDeviceIsAlive
        case .DeviceIsRunning:
            return kAudioClockDevicePropertyDeviceIsRunning
        case .Latency:
            return kAudioClockDevicePropertyLatency
        case .ControlList:
            return kAudioClockDevicePropertyControlList
        case .NominalSampleRate:
            return kAudioClockDevicePropertyNominalSampleRate
        case .AvailableNominalSampleRates:
            return kAudioClockDevicePropertyAvailableNominalSampleRates
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .DeviceUID:
            return .UInt32
        case .TransportType:
            return .UInt32
        case .ClockDomain:
            return .UInt32
        case .DeviceIsAlive:
            return .UInt32
        case .DeviceIsRunning:
            return .UInt32
        case .Latency:
            return .UInt32
        case .ControlList:
            return .UInt32Array
        case .NominalSampleRate:
            return .Double
        case .AvailableNominalSampleRates:
            return .DoubleArray
        }
    }
}
