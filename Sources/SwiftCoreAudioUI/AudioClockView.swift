//
//  AudioClockView.swift
//  
//
//  Created by Devin Roth on 2022-07-21.
//

import SwiftUI
import SwiftCoreAudio

struct AudioClockView: View {
    
    var audioClock: ClockDevice
    var body: some View {
        AudioObjectView(audioObject: audioClock)
    }
}
