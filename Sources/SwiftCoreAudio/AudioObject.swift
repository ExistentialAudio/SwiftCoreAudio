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

public class AudioObject: ObservableObject {
    
    let audioObjectID: AudioObjectID
    
    @Published public var name: String?
    
    @Published public var identifyIsEnabled: Bool?
    
    @Published public var manufacturer: String?

    @Published public var elementName: String?

    @Published public var elementNumberName: String?
 
    @Published public var serialNumber: String?

    @Published public var firmwareVersion: String?
 
    @Published public var modelName: String?
    
    @Published public var ownedObjects: [AudioObject]?
    
    @Published public var bassAudioClass: AudioObjectClass?

    @Published public var audioClass: AudioObjectClass?

    @Published public var owner: AudioObject?
    
    public init(audioObjectID: AudioObjectID) {
        
        self.audioObjectID = audioObjectID
        
        getProperties()

    }
    
    func getProperties() {
        
        name = try? getData(property: AudioObjectProperty.Name) as? String
        
        manufacturer = try? getData(property: AudioObjectProperty.Manufacturer) as? String
        
        elementName = try? getData(property: AudioObjectProperty.ElementName) as? String
        
        elementNumberName = try? getData(property: AudioObjectProperty.ElementNumberName) as? String
        
        serialNumber = try? getData(property: AudioObjectProperty.SerialNumber) as? String
        
        firmwareVersion = try? getData(property: AudioObjectProperty.FirmwareVersion) as? String
        
        modelName = try? getData(property: AudioObjectProperty.ModelName) as? String
        
        ownedObjects = try? getData(property: AudioObjectProperty.OwnedObjects) as? [AudioObject]
        
        bassAudioClass = try? AudioObjectClass(classID: getData(property: AudioObjectProperty.BaseClass) as! UInt32); #warning ("Don't use !")
        
        audioClass = try? AudioObjectClass(classID: getData(property: AudioObjectProperty.Class) as! UInt32); #warning ("Don't use !")
        
        owner = try? getData(property: AudioObjectProperty.OwnedObjects) as? AudioObject
        
        identifyIsEnabled = try? getData(property: AudioObjectProperty.Identify) as? Int != 0
    }
    
    
    func has (
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
            status = AudioObjectGetPropertyData(audioObjectID, &audioObjectPropertyAddress, qualifierDataSize, &qualifierData, &dataSize, &data)
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

public enum AudioPlugInProperty: CaseIterable, AudioProperty {
    case BundleID
    case DeviceList
    case TranslateUIDToDevice
    case BoxList
    case TranslateUIDToBox
    case ClockDeviceList
    case TranslateUIDToClockDevice
    
    

    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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

public enum AudioTransportManagerProperty: CaseIterable {
    case EndPointList
    case TranslateUIDToEndPoint
    case TransportType
    
    public var value: UInt32 {
        switch self {
        case .EndPointList:
            return kAudioTransportManagerPropertyEndPointList
        case .TranslateUIDToEndPoint:
            return kAudioTransportManagerPropertyTranslateUIDToEndPoint
        case .TransportType:
            return kAudioTransportManagerPropertyTransportType
        }
    }
    
    public var type: AudioPropertyType {
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

public enum AudioBoxProperty: CaseIterable, AudioProperty {
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
    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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

public enum AudioDeviceProperty: CaseIterable, AudioProperty {
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
    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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

public enum AudioClockDeviceProperty: CaseIterable, AudioProperty {
    case DeviceUID
    case TransportType
    case ClockDomain
    case DeviceIsAlive
    case DeviceIsRunning
    case Latency
    case ControlList
    case NominalSampleRate
    case AvailableNominalSampleRates
    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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

public enum AudioEndpointProperty: CaseIterable, AudioProperty {
    case Composition
    case EndPointList
    case IsPrivate
    
    public var value: UInt32 {
        switch self {
        case .Composition:
            return kAudioEndPointDevicePropertyComposition
        case .EndPointList:
            return kAudioEndPointDevicePropertyEndPointList
        case .IsPrivate:
            return kAudioEndPointDevicePropertyIsPrivate
        }
    }
    
    public var type: AudioPropertyType {
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

public enum AudioStreamProperty: CaseIterable, AudioProperty {
    case IsActive
    case Direction
    case TerminalType
    case StartingChannel
    case Latency
    case VirtualFormat
    case AvailableVirtualFormats
    case PhysicalFormat
    case AvailablePhysicalFormats
    
    public var value: UInt32 {
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
    
    public var type: AudioPropertyType {
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
    
    public var value: UInt32 {
        switch self {
        case .Scope:
            return kAudioControlPropertyScope
        case .Element:
            return kAudioControlPropertyElement
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .Scope:
            return .UInt32
        case .Element:
            return .UInt32
        }
    }
}

public enum AudioScope2: CaseIterable {
    case Global
    case Input
    case Output
    case PlayThrough

    public var value: UInt32 {
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

public enum AudioSystemProperty: CaseIterable, AudioProperty {
    
    case Devices
    case DefaultInputDevice
    case DefaultOutputDevice
    case DefaultSystemOutputDevice
    case TranslateUIDToDevice
    case MixStereoToMono
    case PlugInList
    case TranslateBundleIDToPlugIn
    case TransportManagerList
    case TranslateBundleIDToTransportManager
    case BoxList
    case TranslateUIDToBox
    case ClockDeviceList
    case TranslateUIDToClockDevice
    case ProcessIsMain
    case IsInitingOrExiting
    case UserIDChanged
    case ProcessIsAudible
    case SleepingIsAllowed
    case UnloadingIsAllowed
    case HogModeIsAllowed
    case UserSessionIsActiveOrHeadless
    case ServiceRestarted
    case PowerHint
    
    public var value: UInt32 {
        switch self {
        case .Devices:
            return kAudioHardwarePropertyDevices
        case .DefaultInputDevice:
            return kAudioHardwarePropertyDefaultInputDevice
        case .DefaultOutputDevice:
            return kAudioHardwarePropertyDefaultOutputDevice
        case .DefaultSystemOutputDevice:
            return kAudioHardwarePropertyDefaultSystemOutputDevice
        case .TranslateUIDToDevice:
            return kAudioHardwarePropertyTranslateUIDToDevice
        case .MixStereoToMono:
            return kAudioHardwarePropertyMixStereoToMono
        case .PlugInList:
            return kAudioHardwarePropertyPlugInList
        case .TranslateBundleIDToPlugIn:
            return kAudioHardwarePropertyTranslateBundleIDToPlugIn
        case .TransportManagerList:
            return kAudioHardwarePropertyTransportManagerList
        case .TranslateBundleIDToTransportManager:
            return kAudioHardwarePropertyTranslateBundleIDToTransportManager
        case .BoxList:
            return kAudioHardwarePropertyBoxList
        case .TranslateUIDToBox:
            return kAudioHardwarePropertyTranslateUIDToBox
        case .ClockDeviceList:
            return kAudioHardwarePropertyClockDeviceList
        case .TranslateUIDToClockDevice:
            return kAudioHardwarePropertyTranslateUIDToClockDevice
        case .ProcessIsMain:
            return kAudioHardwarePropertyProcessIsMain
        case .IsInitingOrExiting:
            return kAudioHardwarePropertyIsInitingOrExiting
        case .UserIDChanged:
            return kAudioHardwarePropertyUserIDChanged
        case .ProcessIsAudible:
            return kAudioHardwarePropertyProcessIsAudible
        case .SleepingIsAllowed:
            return kAudioHardwarePropertySleepingIsAllowed
        case .UnloadingIsAllowed:
            return kAudioHardwarePropertyUnloadingIsAllowed
        case .HogModeIsAllowed:
            return kAudioHardwarePropertyHogModeIsAllowed
        case .UserSessionIsActiveOrHeadless:
            return kAudioHardwarePropertyUserSessionIsActiveOrHeadless
        case .ServiceRestarted:
            return kAudioHardwarePropertyServiceRestarted
        case .PowerHint:
            return kAudioHardwarePropertyPowerHint
        }
    }
    
    public var type: AudioPropertyType {
        switch self {
        case .Devices:
            return .UInt32Array
        case .DefaultInputDevice:
            return .UInt32
        case .DefaultOutputDevice:
            return .UInt32
        case .DefaultSystemOutputDevice:
            return .UInt32
        case .TranslateUIDToDevice:
            return .UInt32
        case .MixStereoToMono:
            return .UInt32
        case .PlugInList:
            return .UInt32Array
        case .TranslateBundleIDToPlugIn:
            return .UInt32
        case .TransportManagerList:
            return .UInt32Array
        case .TranslateBundleIDToTransportManager:
            return .UInt32
        case .BoxList:
            return .UInt32Array
        case .TranslateUIDToBox:
            return .UInt32
        case .ClockDeviceList:
            return .UInt32Array
        case .TranslateUIDToClockDevice:
            return .UInt32
        case .ProcessIsMain:
            return .UInt32
        case .IsInitingOrExiting:
            return .UInt32
        case .UserIDChanged:
            return .UInt32
        case .ProcessIsAudible:
            return .UInt32
        case .SleepingIsAllowed:
            return .UInt32
        case .UnloadingIsAllowed:
            return .UInt32
        case .HogModeIsAllowed:
            return .UInt32
        case .UserSessionIsActiveOrHeadless:
            return .UInt32
        case .ServiceRestarted:
            return .UInt32
        case .PowerHint:
            return .UInt32
        }
    }
    
    
}

public protocol AudioQualifier {
    
}

extension String: AudioQualifier {
    
}
