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
        try setUInt32(for: kAudioObjectPropertyIdentify, to: name ? 0 : 1)
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
        let audioObjectIDs = try getUInt32s(for: kAudioObjectPropertyOwnedObjects)
        
        var audioObjects = [AudioObject]()
        
        for audioObjectID in audioObjectIDs {
            audioObjects.append(AudioObject(audioObjectID: audioObjectID))
        }
        return audioObjects
    }
    
    public var bassClass: AudioObjectClass {
        get throws {
            AudioObjectClass(classID: try getUInt32(for: kAudioObjectPropertyBaseClass))
        }
    }

    public var classType: AudioObjectClass {
        get throws {
            AudioObjectClass(classID: try getUInt32(for: kAudioObjectPropertyClass))
        }
    }

    public var owner: AudioObject {
        get throws {
            AudioObject(audioObjectID: try getUInt32(for: kAudioObjectPropertyOwner))
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
    
    func getInt32(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> Int32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<Int32>.stride)
        var data = Int32()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setInt32(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to int: Int32
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<Int32>.stride)
        var data = int
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }

    func getUInt32(
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
    
    func setUInt32(
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
    
    func getUInt32s(
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
    
    func setUInt32s(
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
    
    
    func getDouble(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> Float64 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<Float64>.stride)
        var data = Float64()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setDouble(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to float64: Float64
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<Float64>.stride)
        var data = float64
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }

    
    func getDoubles(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> [Float64] {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = try getDataSize(for: selector, scope: scope, element: element)
        var data = [Float64](repeating: 0, count: Int(dataSize) / MemoryLayout<Float64>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setDoubles(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to float64: [Float64]
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<Float64>.stride * float64.count)
        var data = float64
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }

    func getURL(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> URL {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<CFURL>.stride)
        var data = URL(fileURLWithPath: "") as CFURL
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data as URL
    }
    
    func setURL(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to url: URL
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<Float64>.stride)
        var data = url as CFURL
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }
    
    func getAudioChannelLayout(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> AudioChannelLayout {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<AudioChannelLayout>.stride)
        var data = AudioChannelLayout()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setAudioChannelLayout(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to audioChannelLayout: AudioChannelLayout
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<AudioChannelLayout>.stride)
        var data = audioChannelLayout
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }
    
    func getAudioBufferList(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> AudioBufferList {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<AudioBufferList>.stride)
        var data = AudioBufferList()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setAudioBufferList(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to audioBufferList: AudioBufferList
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<AudioBufferList>.stride)
        var data = audioBufferList
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }
    
    func getAudioHardwareIOProcStreamUsage(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> AudioHardwareIOProcStreamUsage {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<AudioHardwareIOProcStreamUsage>.stride)
        var data = AudioHardwareIOProcStreamUsage(mIOProc: &dataSize, mNumberStreams: 0, mStreamIsOn: 0)
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    @available(macOS 11, *)
    func getWorkGroup (
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> WorkGroup {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<WorkGroup>.stride)
        var data = os_workgroup_t(__name: nil, port: 0)
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data!
    }
    
    func getAudioStreamBasicDescription(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> AudioStreamBasicDescription {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<AudioStreamBasicDescription>.stride)
        var data = AudioStreamBasicDescription()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func getAudioStreamBasicDescriptions(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain
    ) throws -> [AudioStreamBasicDescription] {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = try getDataSize(for: selector, scope: scope, element: element)
        var data = [AudioStreamBasicDescription](repeating: AudioStreamBasicDescription(), count: Int(dataSize) / MemoryLayout<AudioStreamBasicDescription>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setAudioStreamBasicDescriptions(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to audioStreamBasicDescriptions: [AudioStreamBasicDescription]
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<AudioStreamBasicDescription>.stride * audioStreamBasicDescriptions.count)
        var data = audioStreamBasicDescriptions
        let status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, 0, nil, dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
    }

//    AudioObjectAddPropertyListener
//    AudioObjectRemovePropertyListener
//    AudioObjectAddPropertyListenerBlock
//    AudioObjectRemovePropertyListenerBlock
}
