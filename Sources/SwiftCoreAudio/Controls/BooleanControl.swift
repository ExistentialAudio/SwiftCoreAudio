//
//  BooleanControl.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class BooleanControl: Control {
    
    public var value: Bool {
        get throws {
            try getUInt32(for: kAudioBooleanControlPropertyValue) != 0
        }
    }
}
