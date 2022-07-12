//
//  LevelControl.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class LevelControl: Control {
    
    public var scalarValue: Double {
        get throws {
            Double(try getFloat32(for: kAudioLevelControlPropertyScalarValue))
        }
    }
    
    public var decibelValue: Double {
        get throws {
            Double(try getFloat32(for: kAudioLevelControlPropertyDecibelValue))
        }
    }
    
//    public var decibelRange: ClosedRange {
//        get throws {
//
//        }
//    }
    
//    kAudioLevelControlPropertyDecibelRange              = 'lcdr',
//    kAudioLevelControlPropertyConvertScalarToDecibels   = 'lcsd',
//    kAudioLevelControlPropertyConvertDecibelsToScalar   = 'lcds'
    
    
}
