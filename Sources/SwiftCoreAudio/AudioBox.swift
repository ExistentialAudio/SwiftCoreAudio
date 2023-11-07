//
//  AudioBox.swift
//  
//
//  Created by Devin Roth on 2023-01-10.
//

import Foundation
import CoreAudio

public class AudioBox {
    
    let uniqueID: String
    
    public var audioObjectID: AudioObjectID? {
        get {
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyTranslateUIDToBox, mScope: 0, mElement: 0)
            let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            var qualifierData = uniqueID as CFString
            var dataSize = UInt32(MemoryLayout<AudioObjectID>.stride)
            var data = AudioObjectID()
            
            let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            
            guard status == noErr else {
                return nil
            }
            
            guard data != 0 else {
                return nil
            }
            
            return data
        }
    }
    
    public var isAcquired: Bool {
        get {
            
            guard let audioObjectID = audioObjectID else {
                return false
            }
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioBoxPropertyAcquired, mScope: 0, mElement: 0)
            var dataSize = UInt32(MemoryLayout<UInt32>.stride)
            var data = UInt32(0)
            
            let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
            
            guard status == noErr else {
                return false
            }
            
            return data != 0
        }
        
        set {
            
            guard let audioObjectID = audioObjectID else {
                return
            }
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioBoxPropertyAcquired, mScope: 0, mElement: 0)
            let dataSize = UInt32(MemoryLayout<UInt32>.stride)
            var data = UInt32(newValue ? 1 : 0)
            
            _ = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        }
    }
    
    public var version: String? {
        get {
            
            guard let audioObjectID = audioObjectID else {
                return nil
            }
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioObjectPropertyFirmwareVersion, mScope: 0, mElement: 0)
            var dataSize = UInt32(MemoryLayout<CFString>.stride)
            var data = "" as CFString
            
            let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
            
            guard status == noErr else {
                return nil
            }
            
            return data as String
        }
    }
    
    public var isAlive: Bool {
        get {
            return audioObjectID != nil
        }
    }
    
    public init(uniqueID: String) {
        self.uniqueID = uniqueID
    }
    
}
