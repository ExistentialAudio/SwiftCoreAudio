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

public class AudioObject: ObservableObject, Identifiable {
    
    public var audioObjectID: AudioObjectID?
    
    #warning("Name is settable in certain situations")
    @Published public private(set) var name: String? = ""
    
    #warning("identifyIsEnabled should be settable")
    @Published public private(set) var identifyIsEnabled: Bool?
    
    @Published public private(set) var manufacturer: String?

    @Published public private(set) var elementName: String?

    @Published public private(set) var elementNumberName: String?
 
    @Published public private(set) var serialNumber: String?

    @Published public private(set) var firmwareVersion: String?
 
    @Published public private(set) var modelName: String?
    
    @Published public private(set) var ownedObjects = [AudioObject]()
    
    @Published public private(set) var bassAudioClass: AudioObjectClass?

    @Published public private(set) var audioClass: AudioObjectClass?

    @Published public private(set) var ownerAudioObjectID: AudioObjectID?
    
    init(audioObjectID: AudioObjectID) {
        
        self.audioObjectID = audioObjectID
        
        getProperties()

    }
    
    init() {
    }
    
    func getProperties() {
        
        name = try? getData(property: AudioObjectProperty.Name) as? String
        
        manufacturer = try? getData(property: AudioObjectProperty.Manufacturer) as? String
        
        elementName = try? getData(property: AudioObjectProperty.ElementName) as? String
        
        elementNumberName = try? getData(property: AudioObjectProperty.ElementNumberName) as? String
        
        serialNumber = try? getData(property: AudioObjectProperty.SerialNumber) as? String
        
        firmwareVersion = try? getData(property: AudioObjectProperty.FirmwareVersion) as? String
        
        modelName = try? getData(property: AudioObjectProperty.ModelName) as? String
        
        if let audioObjectIDs = try? getData(property: AudioObjectProperty.OwnedObjects) as? [UInt32] {
            ownedObjects = audioObjectIDs.map( {AudioObject(audioObjectID: $0)})
        }
        
        if let audioClassID = try? getData(property: AudioObjectProperty.BaseClass) as? UInt32 {
            bassAudioClass = AudioObjectClass(classID: audioClassID)
        }
        
        if let audioClassID = try? getData(property: AudioObjectProperty.Class) as? UInt32 {
            audioClass = AudioObjectClass(classID: audioClassID)
        }
        
        ownerAudioObjectID = try? getData(property: AudioObjectProperty.Owner) as? UInt32
        
        if let value = try? getData(property: AudioObjectProperty.Identify) as? UInt32 {
            identifyIsEnabled = value != 0
        }
    }
    
    
    func has (
        property: AudioProperty,
        scope: AudioScope = .global,
        element: Int = 0
    ) -> Bool {
        guard let audioObjectID = audioObjectID else {
            return false
        }
        
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: AudioObjectPropertyElement(element)
        )
        return AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress)
    }
    
    func isSettable (
        property: AudioProperty,
        scope: AudioScope = .global,
        channel: Int = 0
    ) throws -> Bool {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: AudioObjectPropertyElement(channel)
        )
        
        guard let audioObjectID = audioObjectID else {
            throw AudioError.audioHardwareBadDeviceError
        }
        
        guard AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress) else {
            throw AudioError.notSupported
        }
        
        var isSettable = DarwinBoolean(booleanLiteral: false)
        let status = AudioObjectIsPropertySettable(audioObjectID, &audioObjectPropertyAddress, &isSettable)
        guard status == noErr else {
            let error = AudioError(status: status)
            
            if error != .audioHardwareUnknownPropertyError {
                print("AudioObjectID: \(audioObjectID) (\(String(describing: name))) isSettable(\(property), \(scope), \(channel)) threw \(error)")
            }

            throw error
        }
        return isSettable.boolValue
    }
    
    
    func getDataSize (
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
        
        guard let audioObjectID = audioObjectID else {
            throw AudioError.audioHardwareBadDeviceError
        }
        
        guard AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress) else {
            throw AudioError.notSupported
        }
        
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
        guard status == noErr else {
            let error = AudioError(status: status)
            
            if error != .audioHardwareUnknownPropertyError {
                print("AudioObjectID: \(audioObjectID) (\(String(describing: name))) isSettable(\(property), \(scope), \(channel), \(String(describing: qualifier))) threw \(error)")
            }

            throw error
        }
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
        
        guard let audioObjectID = audioObjectID else {
            throw AudioError.audioHardwareBadDeviceError
        }
        
        guard AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress) else {
            throw AudioError.notSupported
        }
        
        var qualifierDataSize = UInt32(0)
        var qualifierData = "" as CFString
        
        if let qualifier = qualifier {
            qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            qualifierData = qualifier as CFString
        }
        var returnData: Any = ""
        
        var dataSize = try getDataSize(property: property, scope: scope, channel: channel, qualifier: qualifier)
        
        var status = noErr

        switch property.type {
            
        case .UInt32:
            var data = UInt32()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .CFString:
            var data = "" as CFString
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .UInt32Array:
            var data = [UInt32](
                repeating: 0,
                count: Int(dataSize) / MemoryLayout<UInt32>.stride
            )
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .Int32:
            var data = Int32()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .Float32:
            var data = Float32()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .Double:
            var data = Double()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .DoubleArray:
            var data = [Double](
                repeating: 0,
                count: Int(dataSize) / MemoryLayout<Double>.stride
            )
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .URL:
            var data = URL(fileURLWithPath: "") as CFURL
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .AudioChannelLayout:
            var data = AudioChannelLayout()
            #warning("FIX ME")
            //status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .AudioStreamBasicDescription:
            var data = AudioStreamBasicDescription()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .AudioStreamBasicDescriptionArray:
            var data = [AudioStreamBasicDescription](
                repeating: AudioStreamBasicDescription(),
                count: Int(dataSize) / MemoryLayout<AudioStreamBasicDescription>.stride
            )
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
            returnData = data
            
        case .AudioBufferList:
            var data = AudioBufferList()
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)

            
        default:
            throw AudioError.notSupported
        }
        
        guard status == noErr else {
            let error = AudioError(status: status)
            
            if error != .audioHardwareUnknownPropertyError {
                print("AudioObjectID: \(audioObjectID) (\(String(describing: name))) isSettable(\(property), \(scope), \(channel), \(String(describing: qualifier))) threw \(error)")
            }

            throw error
        }
        return returnData
    }
    
    #warning("Incomplete. Only works for UInt32, Int, Bool")
    func setData(
        property: AudioProperty,
        scope: AudioScope = .global,
        channel: Int = 0,
        qualifier: String? = nil,
        data: Any
    ) throws {
        var audioObjectPropertyAddress = AudioObjectPropertyAddress(
            mSelector: property.value,
            mScope: scope.value,
            mElement: UInt32(channel)
        )
        
        guard let audioObjectID = audioObjectID else {
            throw AudioError.audioHardwareBadDeviceError
        }
        
        guard AudioObjectHasProperty(audioObjectID, &audioObjectPropertyAddress) else {
            throw AudioError.notSupported
        }
        
        var qualifierDataSize = UInt32(0)
        var qualifierData = "" as CFString
        
        if let qualifier = qualifier {
            qualifierDataSize = UInt32(MemoryLayout<CFString>.stride)
            qualifierData = qualifier as CFString
        }
        
        var status = noErr

        switch data {
        case is String:
            let dataSize = UInt32(MemoryLayout<CFString>.stride)
            if let data = data as? String {
                var data = data as CFString
                status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, dataSize, &data)
            } else {
                throw AudioError.notSupported
            }
        case is Int, is UInt32:
            let dataSize = UInt32(MemoryLayout<UInt32>.stride)
            if let data = data as? UInt32 {
                var data = data
                status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, dataSize, &data)
            } else {
                throw AudioError.notSupported
            }
        case is Bool:
            let dataSize = UInt32(MemoryLayout<UInt32>.stride)
            if let data = data as? Bool {
                var data = data ? UInt32(1) : UInt32(0)
                status = AudioObjectSetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, dataSize, &data)
            } else {
                throw AudioError.notSupported
            }
        default:
            throw AudioError.notSupported
        }
    
        guard status == noErr else {
            let error = AudioError(status: status)
            
            if error != .audioHardwareUnknownPropertyError {
                print("AudioObjectID: \(audioObjectID) (\(String(describing: name))) isSettable(\(property), \(scope), \(channel), \(String(describing: qualifier))) threw \(error)")
            }

            throw error
        }
    }
}

public enum AudioPropertyType: CaseIterable {
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

public enum AudioObjectProperty: CaseIterable, AudioProperty {
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
    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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

public protocol AudioQualifier {
    
}

extension String: AudioQualifier {
    
}
