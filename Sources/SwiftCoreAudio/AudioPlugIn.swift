//
//  AudioPlugIn.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class AudioPlugIn: AudioObject {
    
    public var bundleID: String {
        get throws {
            try getString(for: kAudioPlugInPropertyBundleID)
        }
    }
    
    
    public var audioDevices: [AudioDevice] {
        get throws {
            let audioDeviceIDs = try getUInt32s(for: kAudioPlugInPropertyDeviceList)
            var audioDevices = [AudioDevice]()
            for audioDeviceID in audioDeviceIDs {
                audioDevices.append(AudioDevice(audioObjectID: audioDeviceID))
            }
            
            return audioDevices
        }
    }
    
    public var audioBoxes: [AudioBox] {
        get throws {
            let audioObjectIDs = try getUInt32s(for: kAudioPlugInPropertyBoxList)
            var audioBoxes = [AudioBox]()
            for audioObjectID in audioObjectIDs {
                audioBoxes.append(AudioBox(audioObjectID: audioObjectID))
            }
            
            return audioBoxes
        }
    }
    
    public var clockDevices: [ClockDevice] {
        get throws {
            let audioObjectIDs = try getUInt32s(for: kAudioPlugInPropertyClockDeviceList)
            var clockDevices = [ClockDevice]()
            for audioObjectID in audioObjectIDs {
                clockDevices.append(ClockDevice(audioObjectID: audioObjectID))
            }
            
            return clockDevices
        }
    }
    
    // These are redundant. 
    //kAudioPlugInPropertyTranslateUIDToDevice
    //kAudioPlugInPropertyTranslateUIDToBox
    //kAudioPlugInPropertyTranslateUIDToClockDevice
//    kAudioPlugInCreateAggregateDevice   = 'cagg',
//    kAudioPlugInDestroyAggregateDevice  = 'dagg'
}
