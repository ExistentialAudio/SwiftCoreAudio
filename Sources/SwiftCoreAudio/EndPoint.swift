//
//  EndPoint.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class EndPoint: AudioDevice {
    

    
//    #define kAudioEndPointUIDKey    "uid"
//    #define kAudioEndPointNameKey   "name"
//    #define kAudioEndPointInputChannelsKey  "channels-in"
//    #define kAudioEndPointOutputChannelsKey "channels-out"

}

public enum AudioEndpointProperty: CaseIterable, AudioProperty {
    case Composition
    case EndPointList
    case IsPrivate
    
    public var value: UInt32 {
        switch self {
        case .Composition:
            return kAudioEndPointDevicePropertyComposition
        case .EndPointList:
            return kAudioEndPointDevicePropertyEndPointList
        case .IsPrivate:
            return kAudioEndPointDevicePropertyIsPrivate
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .Composition:
            return .CFString
        case .EndPointList:
            return .UInt32Array
        case .IsPrivate:
            return .UInt32
        }
    }
}
