//
//  AudioDevice.swift
//  VSXSystemwide
//
//  Created by Devin Roth on 2023-01-10.
//

import Foundation
import CoreAudio

public class AudioDevice: Hashable {
    
    public let uniqueID: String
    
    var audioObjectID: AudioObjectID? {
        get {
            
            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyTranslateUIDToDevice, mScope: 0, mElement: 0)
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
    
    public var name: String {
        get {
            
            guard let audioObjectID = audioObjectID else {
                return "Unknown Audio Device"
            }

            var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceNameCFString, mScope: 0, mElement: 0)
            var dataSize = UInt32(MemoryLayout<CFString>.stride)
            var data = "" as CFString

            let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)

            guard status == noErr else {
                return "Unknown Audio Device"
            }

            return data as String
        }
    }
    
    var streams: [AudioStream] {
        
        guard let audioObjectID = audioObjectID else {
            return [AudioStream]()
        }
        
       // setup variables
       var status = noErr
       var inAddress = AudioObjectPropertyAddress(
           mSelector: kAudioDevicePropertyStreams,
           mScope: kAudioObjectPropertyScopeGlobal,
           mElement: 0
       )
       
       // get the size
       var size = UInt32()
       
       status = AudioObjectGetPropertyDataSize(
           audioObjectID,
           &inAddress,
           0,
           nil,
           &size
       )
        
        guard status == noErr else {
            return [AudioStream]()
        }
        
       // get the audio object ids
       var data = [AudioObjectID](repeating: AudioObjectID(), count: Int(size)/MemoryLayout<AudioObjectID>.stride)
       
       status = AudioObjectGetPropertyData(
           audioObjectID,
           &inAddress,
           0,
           nil,
           &size,
           &data
       )
           
       guard status == noErr else {
           return [AudioStream]()
       }

       // map to streams
        return data.compactMap { AudioStream(audioObjectID: $0)}
    }
    
    var volume: Double {
        get {
            guard let audioObjectID = audioObjectID else {
                return 0
            }
            
            var inAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyVolumeScalar,
                mScope: kAudioDevicePropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain
            )
            
            var volume: Float32 = 0
            var size = UInt32(MemoryLayout<UInt32>.stride)
            
            if (!AudioObjectHasProperty(audioObjectID, &inAddress)) {
                inAddress.mElement = 1
            }
            
            let status = AudioObjectGetPropertyData(
                audioObjectID,
                &inAddress,
                0,
                nil,
                &size,
                &volume
            )

            if status != noErr {
                print("Failed to get the volume")
                return 0
            }

            return Double(volume)
        }
        
        set {
                
            guard let audioObjectID = audioObjectID else {
                return
            }
            
            var inAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyVolumeScalar,
                mScope: kAudioDevicePropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain
            )
            let size = UInt32(MemoryLayout<Float32>.stride)
            var status: OSStatus = noErr
            var volume = Float32(newValue)
            
            // adjust the master or adjust channel 1 and channel 2
            if (AudioObjectHasProperty(audioObjectID, &inAddress)) {
                status = AudioObjectSetPropertyData(
                    audioObjectID,
                    &inAddress,
                    0,
                    nil,
                    size,
                    &volume
                )

                if status != noErr {
                    print("Failed to set the master volume.")
                }
                
            } else {
                inAddress.mElement = 1

                status = AudioObjectSetPropertyData(
                    audioObjectID,
                    &inAddress,
                    0,
                    nil,
                    size,
                    &volume
                )

                if status != noErr {
                    print("Failed to set the channel 1 volume.")
                }

                inAddress.mElement = 2
                status = AudioObjectSetPropertyData(
                    audioObjectID,
                    &inAddress,
                    0,
                    nil,
                    size,
                    &volume
                )

                if status != noErr {
                    print("Failed to set the channel 2 volume.")
                }
            }
        }
    }
    
    // Equatable
    public static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        lhs.uniqueID == rhs.uniqueID
    }
    
    // Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
    
    public init(uniqueID: String) {
        self.uniqueID = uniqueID
    }
    
    init?(audioObjectID: AudioObjectID) {
        
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceUID, mScope: 0, mElement: 0)
        var dataSize = UInt32(MemoryLayout<CFString>.stride)
        var data = "" as CFString
        
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
        
        guard status == noErr else {
            return nil
        }
        
        uniqueID = data as String
    }
    
    
}
