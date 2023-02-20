//
//  AudioStream.swift
//  
//
//  Created by Devin Roth on 2023-01-10.
//

import Foundation
import CoreAudio

public class AudioStream {
    public var audioObjectID: AudioObjectID
    
    public var direction: AudioDirection {
        get {
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioStreamPropertyDirection, mScope: 0, mElement: 0)
            var dataSize = UInt32(MemoryLayout<UInt32>.stride)
            var data = UInt32()
            
            let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
            
            guard status == noErr else {
                return .unknown
            }
            
            return AudioDirection(value: data)
        }
    }
    
    public var format: AudioStreamBasicDescription {
        get {

            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreamFormat, mScope: 0, mElement: 0)
            var dataSize = UInt32(MemoryLayout<AudioStreamBasicDescription>.stride)
            var audioStreamBasicDescription = AudioStreamBasicDescription()
            
            let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &audioStreamBasicDescription)
            
            return audioStreamBasicDescription
        }
    }
    
    init(audioObjectID: AudioObjectID) {
        self.audioObjectID = audioObjectID
    }
}

public enum AudioDirection: Int {
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
