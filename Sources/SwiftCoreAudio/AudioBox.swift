//
//  AudioBox.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class AudioBox: AudioObject {

    public var uniqueID: String {
        get throws {
            try getString(for: kAudioBoxPropertyBoxUID)
        }
    }
    
    public var transportType: TransportType {
        get throws {
            return try TransportType(value: getInt(for: kAudioBoxPropertyTransportType))
        }
    }
    
    public var hasAudio: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyHasAudio) == 0 ? false : true
        }
    }
    
    public var hasVideo: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyHasVideo) == 0 ? false : true
        }
    }
    
    public var hasHDMI: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyHasMIDI) == 0 ? false : true
        }
    }
    
    public var isProtected: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyIsProtected) == 0 ? false : true
        }
    }
    
    public var isAquired: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyAcquired) == 0 ? false : true
        }
    }
    
    public func setIsAquired(isAquired: Bool) throws {
        try setInt(for: kAudioBoxPropertyAcquired, to: isAquired ? 1 : 0)
    }
    
    public var acquisitionFailed: Bool {
        get throws {
            try getInt(for: kAudioBoxPropertyAcquisitionFailed) == 0 ? false : true
        }
    }

    public var audioDevices: [AudioDevice] {
        get throws {
            let audioDeviceIDs = try getInts(for: kAudioHardwarePropertyDevices)
            var audioDevices = [AudioDevice]()
            for audioDeviceID in audioDeviceIDs {
                audioDevices.append(AudioDevice(audioObjectID: audioDeviceID))
            }
            
            return audioDevices
        }
    }
    
    public var clockDevices: [ClockDevice] {
        get throws {
            let audioObjectIDs = try getInts(for: kAudioHardwarePropertyClockDeviceList)
            var clockDevices = [ClockDevice]()
            for audioObjectID in audioObjectIDs {
                clockDevices.append(ClockDevice(audioObjectID: audioObjectID))
            }
            
            return clockDevices
        }
    }

}
