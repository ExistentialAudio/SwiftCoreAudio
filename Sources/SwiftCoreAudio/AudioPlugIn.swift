//
//  AudioPlugIn.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioPlugIn: AudioObject {
    
    public var bundleID: String?
    
    public var audioDevices: [AudioDevice]?
    
    public var audioBoxes: [AudioBox]?
    
    public var clockDevices: [ClockDevice]?
    
    // These are redundant. 
    //kAudioPlugInPropertyTranslateUIDToDevice
    //kAudioPlugInPropertyTranslateUIDToBox
    //kAudioPlugInPropertyTranslateUIDToClockDevice
//    kAudioPlugInCreateAggregateDevice   = 'cagg',
//    kAudioPlugInDestroyAggregateDevice  = 'dagg'
}
