//
//  AudioBox.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioBox: AudioObject {

    public var uniqueID: String?
    
    public var transportType: TransportType?
    
    public var hasAudio: Bool?
    
    public var hasVideo: Bool?
    
    public var hasHDMI: Bool?
    
    public var isProtected: Bool?
    
    public var isAquired: Bool?
 
    public var audioDevices: [AudioDevice]?
    
    public var clockDevices: [ClockDevice]?
}
