//
//  AudioSystemView.swift
//  SwiftCoreAudioTest
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

struct AudioSystemView: View {
    
    @StateObject var audioSystem = AudioSystem.shared
    var body: some View {
        VStack {

            Group {
                Text("Audio Plug Ins").bold()
                ForEach(audioSystem.audioPlugIns) { AudioObjectView(audioObject: $0)}
            }

            Spacer()
            
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

        }
        .padding()
        .toggleStyle(.switch)
    }
}

struct AudioSystemView_Previews: PreviewProvider {
    static var previews: some View {
        AudioSystemView()
    }
}
