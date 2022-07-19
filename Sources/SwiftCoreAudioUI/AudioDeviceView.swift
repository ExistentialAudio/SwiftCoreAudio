//
//  AudioDevice.swift
//  SwiftCoreAudioTest
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

struct AudioDeviceView: View {
    
    let audioDevice: AudioDevice
    
    var body: some View {
        VStack {
            AudioObjectView(audioObject: audioDevice)
        }
    }
}

struct AudioDevice_Previews: PreviewProvider {
    static var previews: some View {
        AudioDeviceView(audioDevice: AudioDevice(uniqueID: "NullAudioDevice_UID")!)
    }
}


