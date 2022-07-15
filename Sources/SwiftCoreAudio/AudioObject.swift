//
//  AudioObject.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

protocol AudioDataType {
    
}

extension UInt32 {
    
}

class AudioObject {
    
    let audioObjectID: AudioObjectID
    
    public init(audioObjectID: AudioObjectID) {
        self.audioObjectID = audioObjectID
    }
    
//    public lazy var name = try? getString(for: kAudioObjectPropertyName)
//
//    public var name: Result<String, Error> {
//        get {
//            return .success(getString(for: kAudioObjectPropertyName))
//        }
//    }
    
    
    
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
        try getUInt32s(for: kAudioObjectPropertyOwnedObjects).map { AudioObject(audioObjectID: $0) }
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
    
    
    
    
    
    
    
    func has(
        property: AudioProperty,
        scope: AudioScope = .global,
        element: Int = 0
    ) -> Bool {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: AudioObjectPropertyElement(element)
        )
        return AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress)
    }
    
    func isSettable(
        property: AudioProperty,
        scope: AudioScope = .global,
        element: Int = 0
    ) throws -> Bool {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: AudioObjectPropertyElement(element)
        )
        var isSettable = DarwinBoolean(booleanLiteral: false)
        let status = AudioObjectIsPropertySettable(audioObjectID, &audioObjectPropertyAddress, &isSettable)
        guard status == noErr else { throw AudioError(status: status) }
        return isSettable.boolValue
    }
    
    
    func getDataSize(
        property: AudioProperty,
        scope: AudioScope = .global,
        channel: Int = 0,
        qualifier: String? = nil
    ) throws -> UInt32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: UInt32(channel)
        )
        
        var dataSize = UInt32(0)
        
        var qualifierDataSize = UInt32(0)
        var qualifierData = "" as CFString
        
        if let qualifier = qualifier {
            qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            qualifierData = qualifier as CFString
        }
        
        let status = AudioObjectGetPropertyDataSize(
            audioObjectID, &audioObjectPropertyAddress,
            qualifierDataSize,
            &qualifierData,
            &dataSize
        )
        guard status == noErr else { throw AudioError(status: status) }
        return dataSize
    }
    
    func getData(
        property: AudioProperty,
        scope: AudioScope = .global,
        channel: Int = 0,
        qualifier: String? = nil
    ) throws -> Any {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: UInt32(channel)
        )
        var dataSize = try getDataSize(property: property, scope: scope, channel: channel, qualifier: qualifier)
        
        
        var data: Any = ""
        
        switch property.type {
        case .UInt32:
            print("")
        case .CFString:
            data = "" as CFString
        case .UInt32Array:
            data = [UInt32](
                repeating: 0,
                count: Int(dataSize) / MemoryLayout<UInt32>.stride
            )
        case .Int32:
            data = Int32()
        case .Float32:
            data = Float32()
        case .Double:
            data = Double()
        case .DoubleArray:
            data = [Double](
                repeating: 0,
                count: Int(dataSize) / MemoryLayout<Double>.stride
            )
        case .URL:
            data = URL(fileURLWithPath: "") as CFURL
        case .AudioChannelLayout:
            data = AudioChannelLayout()
        case .AudioStreamBasicDescription:
            data = AudioStreamBasicDescription()
        case .AudioStreamBasicDescriptionArray:
            data = [AudioStreamBasicDescription](
                repeating: AudioStreamBasicDescription(),
                count: Int(dataSize) / MemoryLayout<AudioStreamBasicDescription>.stride
            )
        case .AudioBufferList:
            data = AudioBufferList()
        default:
            throw AudioError.notSupported
        }

        
        var qualifierDataSize = UInt32(0)
        var qualifierData = "" as CFString
        
        if let qualifier = qualifier {
            qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            qualifierData = qualifier as CFString
        }
        
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
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
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> UInt32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(0)
        var qualifierData = qualifier as CFString?
        let status = AudioObjectGetPropertyDataSize(audioObjectID, &audioObjectPropertyAddress, UInt32(MemoryLayout<CFString>.stride), &qualifierData, &dataSize)
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
    
    func getFloat32(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        qualifier: String? = nil
    ) throws -> Float32 {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        var dataSize = UInt32(MemoryLayout<Float32>.stride)
        var data = Float32()
        var qualifierData = qualifier as CFString?
        let qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
        let status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
        guard status == noErr else { throw AudioError(status: status) }
        return data
    }
    
    func setFloat32(
        for selector: AudioObjectPropertySelector,
        scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal,
        element: AudioObjectPropertyElement = kAudioObjectPropertyElementMain,
        to float32: Float32
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(mSelector: selector, mScope: scope, mElement: element)
        let dataSize = UInt32(MemoryLayout<Float32>.stride)
        var data = float32
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

enum AudioPropertyType: CaseIterable {
    case CFString
    case UInt32
    case UInt32Array
    case Int32
    case Float32
    case Double
    case DoubleArray
    case URL
    case AudioChannelLayout
    case AudioStreamBasicDescription
    case AudioStreamBasicDescriptionArray
    case AudioBufferList
    case AudioHardwareIOProcStreamUsage
    case WorkGroup

}

enum AudioObjectProperty: CaseIterable, AudioProperty {
    case BaseClass
    case Class
    case Owner
    case Name // Settable
    case ModelName
    case Manufacturer
    case ElementName
    case ElementCategoryName
    case ElementNumberName
    case OwnedObjects
    case Identify // Settable
    case SerialNumber
    case FirmwareVersion
    
    var value: UInt32 {
        switch self {
        case .BaseClass:
            return kAudioObjectPropertyBaseClass
        case .Class:
            return kAudioObjectPropertyClass
        case .Owner:
            return kAudioObjectPropertyOwner
        case .Name:
            return kAudioObjectPropertyName
        case .ModelName:
            return kAudioObjectPropertyModelName
        case .Manufacturer:
            return kAudioObjectPropertyManufacturer
        case .ElementName:
            return kAudioObjectPropertyElementName
        case .ElementCategoryName:
            return kAudioObjectPropertyElementCategoryName
        case .ElementNumberName:
            return kAudioObjectPropertyElementNumberName
        case .OwnedObjects:
            return kAudioObjectPropertyOwnedObjects
        case .Identify:
            return kAudioObjectPropertyIdentify
        case .SerialNumber:
            return kAudioObjectPropertySerialNumber
        case .FirmwareVersion:
            return kAudioObjectPropertyFirmwareVersion
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .BaseClass:
            return .UInt32
        case .Class:
            return .UInt32
        case .Owner:
            return .UInt32
        case .Name:
            return .CFString
        case .ModelName:
            return .CFString
        case .Manufacturer:
            return .CFString
        case .ElementName:
            return .CFString
        case .ElementCategoryName:
            return .CFString
        case .ElementNumberName:
            return .CFString
        case .OwnedObjects:
            return .UInt32Array
        case .Identify:
            return .UInt32
        case .SerialNumber:
            return .CFString
        case .FirmwareVersion:
            return .CFString
        }
    }
}

enum AudioPlugInProperty: CaseIterable, AudioProperty {
    case BundleID
    case DeviceList
    case TranslateUIDToDevice
    case BoxList
    case TranslateUIDToBox
    case ClockDeviceList
    case TranslateUIDToClockDevice
    
    

    
    var value: UInt32 {
        switch self {
        case .BundleID:
            return kAudioPlugInPropertyBundleID
        case .DeviceList:
            return kAudioPlugInPropertyDeviceList
        case .TranslateUIDToDevice:
            return kAudioPlugInPropertyTranslateUIDToDevice
        case .BoxList:
            return kAudioPlugInPropertyBoxList
        case .TranslateUIDToBox:
            return kAudioPlugInPropertyTranslateUIDToBox
        case .ClockDeviceList:
            return kAudioPlugInPropertyClockDeviceList
        case .TranslateUIDToClockDevice:
            return kAudioPlugInPropertyTranslateUIDToClockDevice
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .BundleID:
            return .CFString
        case .DeviceList:
            return .UInt32Array
        case .TranslateUIDToDevice:
            return .UInt32
        case .BoxList:
            return .UInt32Array
        case .TranslateUIDToBox:
            return .UInt32
        case .ClockDeviceList:
            return .UInt32Array
        case .TranslateUIDToClockDevice:
            return .UInt32
        }
    }
}

enum AudioTransportManagerProperty: CaseIterable {
    case EndPointList
    case TranslateUIDToEndPoint
    case TransportType
    
    var value: UInt32 {
        switch self {
        case .EndPointList:
            return kAudioTransportManagerPropertyEndPointList
        case .TranslateUIDToEndPoint:
            return kAudioTransportManagerPropertyTranslateUIDToEndPoint
        case .TransportType:
            return kAudioTransportManagerPropertyTransportType
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .EndPointList:
            return .UInt32Array
        case .TranslateUIDToEndPoint:
            return .UInt32
        case .TransportType:
            return .UInt32
        }
    }
}

enum AudioBoxProperty: CaseIterable, AudioProperty {
    case BoxUID
    case TransportType
    case HasAudio
    case HasVideo
    case HasMIDI
    case IsProtected
    case Acquired // Settable
    case AcquisitionFailed
    case DeviceList
    case ClockDeviceList
    
    var value: UInt32 {
        switch self {
        case .BoxUID:
            return kAudioBoxPropertyBoxUID
        case .TransportType:
            return kAudioBoxPropertyTransportType
        case .HasAudio:
            return kAudioBoxPropertyHasAudio
        case .HasVideo:
            return kAudioBoxPropertyHasVideo
        case .HasMIDI:
            return kAudioBoxPropertyHasMIDI
        case .IsProtected:
            return kAudioBoxPropertyIsProtected
        case .Acquired:
            return kAudioBoxPropertyAcquired
        case .AcquisitionFailed:
            return kAudioBoxPropertyAcquisitionFailed
        case .DeviceList:
            return kAudioBoxPropertyDeviceList
        case .ClockDeviceList:
            return kAudioBoxPropertyClockDeviceList
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .BoxUID:
            return .CFString
        case .TransportType:
            return .UInt32
        case .HasAudio:
            return .UInt32
        case .HasVideo:
            return .UInt32
        case .HasMIDI:
            return .UInt32
        case .IsProtected:
            return .UInt32
        case .Acquired:
            return .UInt32
        case .AcquisitionFailed:
            return .UInt32
        case .DeviceList:
            return .UInt32Array
        case .ClockDeviceList:
            return .UInt32Array
        }
    }
}

enum AudioDeviceProperty: CaseIterable, AudioProperty {
    case ConfigurationApplication
    case DeviceUID
    case ModelUID
    case TransportType
    case RelatedDevices
    case ClockDomain
    case DeviceIsAlive
    case DeviceIsRunning
    case DeviceCanBeDefaultDevice
    case DeviceCanBeDefaultSystemDevice
    case Latency
    case Streams
    case ControlList
    case SafetyOffset
    case NominalSampleRate// Settable
    case AvailableNominalSampleRates
    case Icon
    case IsHidden
    case PreferredChannelsForStereo// Settable
    case PreferredChannelLayout// Settable
    
    var value: UInt32 {
        switch self {
        case .ConfigurationApplication:
            return kAudioDevicePropertyConfigurationApplication
        case .DeviceUID:
            return kAudioDevicePropertyDeviceUID
        case .ModelUID:
            return kAudioDevicePropertyModelUID
        case .TransportType:
            return kAudioDevicePropertyTransportType
        case .RelatedDevices:
            return kAudioDevicePropertyRelatedDevices
        case .ClockDomain:
            return kAudioDevicePropertyClockDomain
        case .DeviceIsAlive:
            return kAudioDevicePropertyDeviceIsAlive
        case .DeviceIsRunning:
            return kAudioDevicePropertyDeviceIsRunning
        case .DeviceCanBeDefaultDevice:
            return kAudioDevicePropertyDeviceCanBeDefaultDevice
        case .DeviceCanBeDefaultSystemDevice:
            return kAudioDevicePropertyDeviceCanBeDefaultSystemDevice
        case .Latency:
            return kAudioDevicePropertyLatency
        case .Streams:
            return kAudioDevicePropertyStreams
        case .ControlList:
            return kAudioObjectPropertyControlList
        case .SafetyOffset:
            return kAudioDevicePropertySafetyOffset
        case .NominalSampleRate:
            return kAudioDevicePropertyNominalSampleRate
        case .AvailableNominalSampleRates:
            return kAudioDevicePropertyAvailableNominalSampleRates
        case .Icon:
            return kAudioDevicePropertyIcon
        case .IsHidden:
            return kAudioDevicePropertyIsHidden
        case .PreferredChannelsForStereo:
            return kAudioDevicePropertyPreferredChannelsForStereo
        case .PreferredChannelLayout:
            return kAudioDevicePropertyPreferredChannelLayout
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .ConfigurationApplication:
            return .CFString
        case .DeviceUID:
            return .CFString
        case .ModelUID:
            return .CFString
        case .TransportType:
            return .UInt32
        case .RelatedDevices:
            return .UInt32Array
        case .ClockDomain:
            return .UInt32
        case .DeviceIsAlive:
            return .UInt32
        case .DeviceIsRunning:
            return .UInt32
        case .DeviceCanBeDefaultDevice:
            return .UInt32
        case .DeviceCanBeDefaultSystemDevice:
            return .UInt32
        case .Latency:
            return .UInt32
        case .Streams:
            return .UInt32Array
        case .ControlList:
            return .UInt32Array
        case .SafetyOffset:
            return .UInt32
        case .NominalSampleRate:
            return .Double
        case .AvailableNominalSampleRates:
            return .DoubleArray
        case .Icon:
            return .URL
        case .IsHidden:
            return .UInt32
        case .PreferredChannelsForStereo:
            return .Double
        case .PreferredChannelLayout:
            return .Double
        }
    }
}

enum AudioClockDeviceProperty: CaseIterable, AudioProperty {
    case DeviceUID
    case TransportType
    case ClockDomain
    case DeviceIsAlive
    case DeviceIsRunning
    case Latency
    case ControlList
    case NominalSampleRate
    case AvailableNominalSampleRates
    
    var value: UInt32 {
        switch self {
        case .DeviceUID:
            return kAudioClockDevicePropertyDeviceUID
        case .TransportType:
            return kAudioClockDevicePropertyTransportType
        case .ClockDomain:
            return kAudioDevicePropertyClockDomain
        case .DeviceIsAlive:
            return kAudioClockDevicePropertyDeviceIsAlive
        case .DeviceIsRunning:
            return kAudioClockDevicePropertyDeviceIsRunning
        case .Latency:
            return kAudioClockDevicePropertyLatency
        case .ControlList:
            return kAudioClockDevicePropertyControlList
        case .NominalSampleRate:
            return kAudioClockDevicePropertyNominalSampleRate
        case .AvailableNominalSampleRates:
            return kAudioClockDevicePropertyAvailableNominalSampleRates
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .DeviceUID:
            return .UInt32
        case .TransportType:
            return .UInt32
        case .ClockDomain:
            return .UInt32
        case .DeviceIsAlive:
            return .UInt32
        case .DeviceIsRunning:
            return .UInt32
        case .Latency:
            return .UInt32
        case .ControlList:
            return .UInt32Array
        case .NominalSampleRate:
            return .Double
        case .AvailableNominalSampleRates:
            return .DoubleArray
        }
    }
}

enum AudioEndpointProperty: CaseIterable, AudioProperty {
    case Composition
    case EndPointList
    case IsPrivate
    
    var value: UInt32 {
        switch self {
        case .Composition:
            return kAudioEndPointDevicePropertyComposition
        case .EndPointList:
            return kAudioEndPointDevicePropertyEndPointList
        case .IsPrivate:
            return kAudioEndPointDevicePropertyIsPrivate
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .Composition:
            return .CFString
        case .EndPointList:
            return .UInt32Array
        case .IsPrivate:
            return .UInt32
        }
    }
}

enum AudioStreamProperty: CaseIterable, AudioProperty {
    case IsActive
    case Direction
    case TerminalType
    case StartingChannel
    case Latency
    case VirtualFormat
    case AvailableVirtualFormats
    case PhysicalFormat
    case AvailablePhysicalFormats
    
    var value: UInt32 {
        switch self {
        case .IsActive:
            return kAudioStreamPropertyIsActive
        case .Direction:
            return kAudioStreamPropertyDirection
        case .TerminalType:
            return kAudioStreamPropertyTerminalType
        case .StartingChannel:
            return kAudioStreamPropertyStartingChannel
        case .Latency:
            return kAudioStreamPropertyLatency
        case .VirtualFormat:
            return kAudioStreamPropertyVirtualFormat
        case .AvailableVirtualFormats:
            return kAudioStreamPropertyAvailableVirtualFormats
        case .PhysicalFormat:
            return kAudioStreamPropertyPhysicalFormat
        case .AvailablePhysicalFormats:
            return kAudioStreamPropertyAvailablePhysicalFormats
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .IsActive:
            return .UInt32
        case .Direction:
            return .UInt32
        case .TerminalType:
            return .UInt32
        case .StartingChannel:
            return .UInt32
        case .Latency:
            return .UInt32
        case .VirtualFormat:
            return .AudioStreamBasicDescription
        case .AvailableVirtualFormats:
            return .AudioStreamBasicDescriptionArray
        case .PhysicalFormat:
            return .AudioStreamBasicDescription
        case .AvailablePhysicalFormats:
            return .AudioStreamBasicDescriptionArray
        }
    }
}

enum AudioControlProperty: CaseIterable, AudioProperty {
    case Scope
    case Element
    
    var value: UInt32 {
        switch self {
        case .Scope:
            return kAudioControlPropertyScope
        case .Element:
            return kAudioControlPropertyElement
        }
    }
    
    var type: AudioPropertyType {
        switch self {
        case .Scope:
            return .UInt32
        case .Element:
            return .UInt32
        }
    }
}

enum AudioScope2: CaseIterable {
    case Global
    case Input
    case Output
    case PlayThrough

    var value: UInt32 {
        switch self {
        case .Global:
            return kAudioObjectPropertyScopeGlobal
        case .Input:
            return kAudioObjectPropertyScopeInput
        case .Output:
            return kAudioObjectPropertyScopeOutput
        case .PlayThrough:
            return kAudioObjectPropertyScopePlayThrough
        }
    }
}

protocol AudioQualifier {
    
}

extension String: AudioQualifier {
    
}
