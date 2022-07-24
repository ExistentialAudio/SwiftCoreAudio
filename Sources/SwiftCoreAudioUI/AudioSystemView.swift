//
//  AudioSystemView.swift
//  SwiftCoreAudioTest
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

public struct AudioSystemView: View {
    
    @StateObject var audioSystem = AudioSystem.shared
    
    public var body: some View {
        VStack {
            
            Group {
                Text("Default Input: \(audioSystem.defaultInputDevice?.name ?? "None")")
                Text("Default Output: \(audioSystem.defaultOutputDevice?.name ?? "None")")
                Text("System Sounds Output: \(audioSystem.defaultSystemOutputDevice?.name ?? "None")")
            }
            
            Spacer()
            
            Group {
                Toggle("Mix Stereo To Mono", isOn: $audioSystem.mixStereoToMono)
                Toggle("Process Is Audible", isOn: $audioSystem.processIsAudible)
                Toggle("Unloading Is Allowed", isOn: $audioSystem.unloadingIsAllowed)
                Toggle("Hog Mode Is Allowed", isOn: $audioSystem.hogModeIsAllowed)
                Toggle("Power Saver Is Enabled", isOn: $audioSystem.powerSaverIsEnabled)
            }
            
            Spacer()
            
            Group {
                Text("Process Is Main: \(audioSystem.processIsMain.description)")
                Text("Is Initing Or Exiting: \(audioSystem.isInitingOrExiting.description)")
                Text("User Session Is Active Or Headless: \(audioSystem.userSessionIsActiveOrHeadless.description)")
            }
            
            Spacer()
            
            Group {
                Text("Audio Plug Ins").bold()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(audioSystem.audioPlugIns) { AudioPlugInView(audioPlugIn: $0)}
                    }
                }
                Text("Audio Devices").bold()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(audioSystem.audioDevices) { AudioDeviceView(audioDevice: $0)}
                    }
                }
//                Text("Audio Transport Managers").bold()
//                ScrollView(.horizontal) {
//                    HStack {
//                        ForEach(audioSystem.transportManagers) { AudioObjectView(audioObject: $0)}
//                    }
//                }
//                Text("Audio Boxes").bold()
//                ScrollView(.horizontal) {
//                    HStack {
//                        ForEach(audioSystem.audioBoxes) { AudioBoxView(audioBox: $0)}
//                    }
//                }
//                Text("Audio Clocks").bold()
//                ScrollView(.horizontal) {
//                    HStack {
//                        ForEach(audioSystem.audioClocks) { AudioClockView(audioClock: $0)}
//                    }
//                }
            }

        }
        .padding()
        .toggleStyle(.switch)
    }
    
    public init() {
        
    }
}

struct AudioSystemView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSystemView()
    }
}
