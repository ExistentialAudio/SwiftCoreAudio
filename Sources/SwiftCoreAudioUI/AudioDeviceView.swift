//
//  AudioDevice.swift
//  SwiftCoreAudioTest
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

public struct AudioDeviceView: View {
    
    let audioDevice: AudioDevice
    
    public var body: some View {
        VStack {
            AudioObjectView(audioObject: audioDevice)
        }
    }
    
    public init(audioDevice: AudioDevice) {
        self.audioDevice = audioDevice
    }
}

struct AudioDevice_Previews: PreviewProvider {
    static var previews: some View {
        AudioDeviceView(audioDevice: AudioDevice(uniqueID: "NullAudioDevice_UID")!)
    }
}


