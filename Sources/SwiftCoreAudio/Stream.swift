//
//  Stream.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio




public class Stream: AudioObject {

    public var isActive: Bool?
    
    public var direction: AudioDirection?
    
    public var terminalType: TerminalType?

    public var startingChannel: Int?
    
    public var latency: Int?

    public var virtualFormat: AudioStreamBasicDescription?
    
    public var virtualFormats: [AudioStreamBasicDescription]?
    
    public var physicalFormat: AudioStreamBasicDescription?
    
    public var phyicalFormats: [AudioStreamBasicDescription]?
}
