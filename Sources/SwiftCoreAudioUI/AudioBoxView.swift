//
//  SwiftUIView.swift
//  
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

public struct AudioBoxView: View {
    
    @ObservedObject var audioBox: AudioBox
    
    public var body: some View {
        Text("Box UniqueID: " + audioBox.uniqueID)
        Text("TransportType: \(audioBox.transportType.description)")
        Text("HasAudio: \(audioBox.hasAudio.description)")
        Text("HasVideo: \(audioBox.hasVideo.description)")
        Text("HasMIDI: \(audioBox.hasMIDI.description)")
        Text("IsProtected: \(audioBox.isProtected.description)")
        
        Toggle("IsAcquired", isOn: $audioBox.isAquired)
        Text("Acquired: \(audioBox.isAquired.description)")
        
        Group {
            ForEach(audioBox.audioDevices) { AudioDeviceView(audioDevice: $0)}
        }
        
        Group {
            ForEach(audioBox.clockDevices) { AudioObjectView(audioObject: $0)}
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}


//case BoxUID
//case TransportType
//case HasAudio
//case HasVideo
//case HasMIDI
//case IsProtected
//case Acquired // Settable
//case AcquisitionFailed
//case DeviceList
//case ClockDeviceList
