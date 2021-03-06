//
//  AudioProperty.swift
//  
//
//  Created by Devin Roth on 2022-07-12.
//

import Foundation

public protocol AudioProperty {
    var value: UInt32 {
        get
    }
    var type: AudioPropertyType {
        get
    }
}
