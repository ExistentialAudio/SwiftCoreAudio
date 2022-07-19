//
//  File.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class TransportManager: AudioObject {
    
//    kAudioTransportManagerClassID   = 'trpm'
    
//    kAudioTransportManagerPropertyEndPointList              = 'end#',
//    kAudioTransportManagerPropertyTranslateUIDToEndPoint    = 'uide',
//    kAudioTransportManagerPropertyTransportType             = 'tran'
    
//    kAudioTransportManagerCreateEndPointDevice  = 'cdev',
//    kAudioTransportManagerDestroyEndPointDevice = 'ddev'
}
public enum AudioTransportManagerProperty: CaseIterable {
    case EndPointList
    case TranslateUIDToEndPoint
    case TransportType
    
    public var value: UInt32 {
        switch self {
        case .EndPointList:
            return kAudioTransportManagerPropertyEndPointList
        case .TranslateUIDToEndPoint:
            return kAudioTransportManagerPropertyTranslateUIDToEndPoint
        case .TransportType:
            return kAudioTransportManagerPropertyTransportType
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .EndPointList:
            return .UInt32Array
        case .TranslateUIDToEndPoint:
            return .UInt32
        case .TransportType:
            return .UInt32
        }
    }
}
