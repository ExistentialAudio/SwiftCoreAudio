//
//  SwiftUIView.swift
//  
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

public struct AudioPlugInView: View {
    
    var audioPlugIn: AudioPlugIn
    
    public var body: some View {
        VStack {
            Text("BundleID: " + audioPlugIn.bundleID).bold()
            Group {
                ForEach(audioPlugIn.audioBoxes) { AudioBoxView(audioBox: $0)}
            }
        }
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView(audioPlugIn: AudioPlugIn(bundleID: "com.apple.audio.coreaudio")!)
//    }
//}
