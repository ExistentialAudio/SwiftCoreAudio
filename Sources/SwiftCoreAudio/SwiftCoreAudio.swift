import Foundation
import CoreAudio

public class SwiftCoreAudio {
    
    public enum Direction {
    case input
    case output
    }
    
    // CoreAudio helper methods.
    public static func getAudioDeviceID(from uniqueID: String) -> AudioDeviceID? {
            // setup the variables
            var inAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyTranslateUIDToDevice, mScope: 0, mElement: 10)
            let inQualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            var inQualifierData = uniqueID as CFString
            var outDataSize = UInt32(MemoryLayout<AudioObjectID>.stride)
            var audioDeviceID: AudioObjectID = 0
            
            // get the id
            let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &inAddress, inQualifierDataSize, &inQualifierData, &outDataSize, &audioDeviceID);
            
            // check for errors
            guard (status == noErr) else {
                print("Failed to retrieve AudioDeviceID from UID: \(uniqueID)")
                return nil
            }
                
            return audioDeviceID
    }
    
    public static func getAudioBoxID(from uniqueID: String) -> AudioDeviceID? {
            // setup the variables
            var inAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyTranslateUIDToBox, mScope: 0, mElement: 0)
            let inQualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            var inQualifierData = uniqueID as CFString
            var outDataSize = UInt32(MemoryLayout<AudioObjectID>.stride)
            var audioDeviceID: AudioObjectID = 0
            
            // get the id
            let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &inAddress, inQualifierDataSize, &inQualifierData, &outDataSize, &audioDeviceID);
            
            // check for errors
            guard (status == noErr) else {
                print("Failed to retrieve AudioDeviceID from UID: \(uniqueID)")
                return nil
            }
                
            return audioDeviceID
    }
    
    public static func getDefaultAudioUID(direction: Direction) -> String? {
        
        // setup the variables
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = direction == .input ? kAudioHardwarePropertyDefaultInputDevice : kAudioHardwarePropertyDefaultOutputDevice
        var outDataSize = UInt32(MemoryLayout<AudioObjectID>.stride)
        var audioDeviceID: AudioObjectID = 0
        
        // get the id
        let status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &inAddress, 0, nil, &outDataSize, &audioDeviceID);
        
        // check for errors
        guard (status == noErr) else {
            print("Failed to default audio device")
            return nil
        }
        
        return getUniqueID(from: audioDeviceID)
    }
    
    public static func getUniqueID(from audioDeviceID: AudioDeviceID)->String? {
        
        // setup the variables
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = kAudioDevicePropertyDeviceUID
        var outDataSize = UInt32(MemoryLayout<CFString>.stride)
        var uniqueID = "" as CFString
        
        // get the uniqueID
        let status = AudioObjectGetPropertyData(audioDeviceID, &inAddress, 0, nil, &outDataSize, &uniqueID);
        
        // check for errors
        guard (status == noErr) else {
            print("Failed to uniqueID")
            return nil
        }
        
        return String(uniqueID)
    }
    
    
    public static func setAudioBox(isAquired: Bool, with audioBoxUID: String) {
        
        guard let audioBoxID = getAudioBoxID(from: audioBoxUID) else {
            fatalError("couldn't get audio box id.")
        }
        
        // setup the variables
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = kAudioBoxPropertyAcquired
        let outDataSize = UInt32(MemoryLayout<UInt32>.stride)
        var isAquired: UInt32 = isAquired ? 1 : 0
        
        // set the data
        let status = AudioObjectSetPropertyData(audioBoxID, &inAddress, 0, nil, outDataSize, &isAquired)
        
        guard status == noErr else {
            print("Failed to aquire audio box")
            fatalError("\(status)")
        }
    }
    
    public static func setDefaultAudioDevice(to audioDeviceUID: String, direction: Direction) {
        guard var audioDeviceID = getAudioDeviceID(from: audioDeviceUID) else {
            fatalError("couldn't get audio device id.")
        }
        
        // setup the variablesds
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = direction == .input ? kAudioHardwarePropertyDefaultInputDevice : kAudioHardwarePropertyDefaultOutputDevice
        inAddress.mScope = direction == .input ? kAudioDevicePropertyScopeInput : kAudioDevicePropertyScopeOutput
        let outDataSize = UInt32(MemoryLayout<AudioDeviceID>.stride)
        
        // set the data
        let status = AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject), &inAddress, 0, nil, outDataSize, &audioDeviceID)
        
        guard status == noErr else {
            print("Failed to set defaultaudio device")
            fatalError("\(status)")
        }
    }
    
    public static func setVolume(of audioDeviceUID: String, to volume: Float32) {
        guard let audioDeviceID = getAudioDeviceID(from: audioDeviceUID) else {
            fatalError("couldn't get audio device id.")
        }
        
        // setup the variablesds
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = kAudioDevicePropertyVolumeScalar
        inAddress.mScope = kAudioDevicePropertyScopeOutput
        inAddress.mElement = kAudioObjectPropertyElementMain
        let outDataSize = UInt32(MemoryLayout<Float32>.stride)
        var volume = volume

        var status = noErr
        // set the data. First we are going to try the main element.
        // In the case of AirPods there is no main volume unless it's using the microphone.
        for element in 0...2 {
            inAddress.mElement = UInt32(element)
            if AudioObjectHasProperty(audioDeviceID, &inAddress) {
                status = AudioObjectSetPropertyData(audioDeviceID, &inAddress, 0, nil, outDataSize, &volume)

                guard status == noErr else {
                    print("Failed to set volume")
                    fatalError("\(status)")
                }
            }
        }
    }
    
    public static func getVolume(of audioDeviceUID: String) -> Float32 {
        guard let audioDeviceID = getAudioDeviceID(from: audioDeviceUID) else {
            fatalError("couldn't get audio device id.")
        }
        
        // setup the variablesds
        var inAddress = AudioObjectPropertyAddress()
        inAddress.mSelector = kAudioDevicePropertyVolumeScalar
        inAddress.mScope = kAudioDevicePropertyScopeOutput
        inAddress.mElement = kAudioObjectPropertyElementMain
        var outDataSize = UInt32(MemoryLayout<Float32>.stride)
        var volume = Float32()

        // get the data. First we are going to try the main element.
        // In the case of AirPods there is no main volume unless it's using the microphone.
        
        var status = noErr
        
        for element in 0...1 {
            inAddress.mElement = UInt32(element)
            if AudioObjectHasProperty(audioDeviceID, &inAddress) {
                status = AudioObjectGetPropertyData(audioDeviceID, &inAddress, 0, nil, &outDataSize, &volume)

                guard status == noErr else {
                    print("Failed to set volume")
                    fatalError("\(status)")
                }
                
                return volume
            }
        }
        
        return 1.0
    }

}
