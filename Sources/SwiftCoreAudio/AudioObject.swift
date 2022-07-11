//
//  AudioObject.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class AudioObject {
    
    let audioObjectID: AudioObjectID
    
    public init(audioObjectID: AudioObjectID) {
        self.audioObjectID = audioObjectID
    }
    
    public var name: String {
        get throws {
            try getString(for: kAudioObjectPropertyName)
        }
    }
    
    public func identify(to name: Bool) throws {
        try setInt(for: kAudioObjectPropertyIdentify, to: name ? 0 : 1)
    }
    
    public var manufacturer: String {
        get throws {
            try getString(for: kAudioObjectPropertyManufacturer)
        }
    }

    public var elementName: String {
        get throws {
            try getString(for: kAudioObjectPropertyElementName)
        }
    }

    public var elementNumberName: String {
        get throws {
            try getString(for: kAudioObjectPropertyElementNumberName)
        }
    }
 
    public var serialNumber: String {
        get throws {
            try getString(for: kAudioObjectPropertySerialNumber)
        }
    }

    public var firmwareVersion: String {
        get throws {
            try getString(for: kAudioObjectPropertyFirmwareVersion)
        }
    }
 
    public var modelName: String {
        get throws {
            try getString(for: kAudioObjectPropertyModelName)
        }
    }
    
    public func getOwnedObjects() throws -> [AudioObject] {
        let audioObjectIDs = try getInts(for: kAudioObjectPropertyOwnedObjects)
        
        var audioObjects = [AudioObject]()
        
        for audioObjectID in audioObjectIDs {
            audioObjects.append(AudioObject(audioObjectID: audioObjectID))
        }
        return audioObjects
    }
    
    public var bassClass: AudioObjectClass {
        get throws {
            AudioObjectClass(classID: try getInt(for: kAudioObjectPropertyBaseClass))
        }
    }

    public var classType: AudioObjectClass {
        get throws {
            AudioObjectClass(classID: try getInt(for: kAudioObjectPropertyClass))
        }
    }

    public var owner: AudioObject {
        get throws {
            AudioObject(audioObjectID: try getInt(for: kAudioObjectPropertyOwner))
        }
    }
    
    func hasProperty(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) -> Bool {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        return AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress)
    }
    
    func isPropertySettable(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> Bool {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var isSettable = DarwinBoolean(booleanLiteral: false)
        let status = AudioObjectIsPropertySettable(audioObjectID, &audioObjectPropertyAddress, &isSettable)
        guard status == noErr else { throw AudioError(status: status) }
        return isSettable.boolValue
    }

    func getDataSize(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> UInt32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(0)
        let status = AudioObjectGetPropertyDataSize(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize)
        guard status == noErr else { throw AudioError(status: status) }
        return dataSize
    }
    
    func getString(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> String {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = try getDataSize(for: selector, scope: scope, element: element)
        var data = "" as CFString
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data as String
    }
    
    func setString(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to string: String
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<CFString>.stride)
        var data = string as CFString
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }

    func getInt(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> UInt32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<UInt32>.stride)
        var data = UInt32()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setInt(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to int: UInt32
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<UInt32>.stride)
        var data = int
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }
    
    func getInts(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> [UInt32] {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = try getDataSize(for: selector, scope: scope, element: element)
        var data = [UInt32](repeating: 0, count: Int(dataSize) / MemoryLayout<UInt32>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setInts(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to ints: [UInt32]
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<UInt32>.stride * ints.count)
        var data = ints
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }
    

//    AudioObjectAddPropertyListener
//    AudioObjectRemovePropertyListener
//    AudioObjectAddPropertyListenerBlock
//    AudioObjectRemovePropertyListenerBlock
}
