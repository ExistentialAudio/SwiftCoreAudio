import XCTest
@testable import SwiftCoreAudio
import CoreAudio

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

enum AudioObjectProperty: CaseIterable {
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



enum AudioPlugInProperty: CaseIterable {
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

enum AudioBoxProperty: CaseIterable {
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

enum AudioDeviceProperty: CaseIterable {
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

enum AudioClockDeviceProperty: CaseIterable {
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

enum AudioEndpointProperty: CaseIterable {
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

enum AudioStreamProperty: CaseIterable {
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

enum AudioControlProperty: CaseIterable {
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

enum AudioScope: CaseIterable {
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

final class SwiftCoreAudioTests: XCTestCase {
    
    func testAudioPlugIn() throws {
        let audioPlugIn = try AudioSystem.getAudioPlugIn(from: "")
        
        for property in AudioObjectProperty.allCases {
            

                let hasProperty = audioPlugIn.hasProperty(for: property.value)

                if hasProperty {
                    let isSettable = try audioPlugIn.isPropertySettable(for: property.value)
                    
                    var value: Any
                    
                    switch property.type {
                    case .UInt32:
                        value = try audioPlugIn.getUInt32(for: property.value)
                    case .CFString:
                        value = try audioPlugIn.getString(for: property.value)
                    case .UInt32Array:
                        value = try audioPlugIn.getUInt32s(for: property.value)
                    default:
                        value = "Unknown value"
                    }
                    print("AudioPlugIn \(property) isSettable: \(isSettable) value: \(value) ")
                }
        }
        
        for property in AudioPlugInProperty.allCases {

                
                let hasProperty = audioPlugIn.hasProperty(for: property.value, scope: AudioScope.Global.value, element: 0)
                
            if hasProperty {
                let isSettable = try audioPlugIn.isPropertySettable(for: property.value)
                
                var value: Any
                
                switch property.type {
                case .UInt32:
                    value = try audioPlugIn.getUInt32(for: property.value)
                case .CFString:
                    value = try audioPlugIn.getString(for: property.value)
                case .UInt32Array:
                    value = try audioPlugIn.getUInt32s(for: property.value)
                default:
                    value = "Unknown value"
                }
                print("AudioPlugIn \(property) isSettable: \(isSettable) value: \(value) ")
            }
        }
    }
    
    func testAudioBox() throws {

        let audioBox = try AudioSystem.getAudioBox(from: "NullAudioBox_UID")
        
        for property in AudioObjectProperty.allCases {
            
                let hasProperty = audioBox.hasProperty(for: property.value, scope: AudioScope.Global.value, element: 0)

            if hasProperty {
                let isSettable = try audioBox.isPropertySettable(for: property.value)
                
                var value: Any
                
                switch property.type {
                case .UInt32:
                    value = try audioBox.getUInt32(for: property.value)
                case .CFString:
                    value = try audioBox.getString(for: property.value)
                case .UInt32Array:
                    value = try audioBox.getUInt32s(for: property.value)
                default:
                    value = "Unknown value"
                }
                print("audioBox \(property) isSettable: \(isSettable) value: \(value) ")
            }
        }
        
        for property in AudioBoxProperty.allCases {
                
                let hasProperty = audioBox.hasProperty(for: property.value, scope: AudioScope.Global.value, element: 0)
                
            if hasProperty {
                let isSettable = try audioBox.isPropertySettable(for: property.value)
                
                var value: Any
                
                switch property.type {
                case .UInt32:
                    value = try audioBox.getUInt32(for: property.value)
                case .CFString:
                    value = try audioBox.getString(for: property.value)
                case .UInt32Array:
                    value = try audioBox.getUInt32s(for: property.value)
                default:
                    value = "Unknown value"
                }
                print("audioBox \(property) isSettable: \(isSettable) value: \(value) ")
            }
        }
    }
    func testAudioDevice() throws {

        let audioDevice = try AudioSystem.getAudioDevice(from: "NullAudioDevice_UID")
        
        for property in AudioObjectProperty.allCases {
            
            let hasProperty = audioDevice.hasProperty(for: property.value, scope: AudioScope.Global.value, element: 0)
            
            if hasProperty {
                let isSettable = try audioDevice.isPropertySettable(for: property.value)
                
                var value: Any
                
                switch property.type {
                case .UInt32:
                    value = try audioDevice.getUInt32(for: property.value)
                case .CFString:
                    value = try audioDevice.getString(for: property.value)
                case .UInt32Array:
                    value = try audioDevice.getUInt32s(for: property.value)
                case .URL:
                    value = try audioDevice.getURL(for: property.value)
                default:
                    value = "Unknown value"
                }
                print("audioDevice \(property) isSettable: \(isSettable) value: \(value) ")
            }
        }
        
        for property in AudioDeviceProperty.allCases {
            for scope in AudioScope.allCases {
                
                let hasProperty = audioDevice.hasProperty(for: property.value, scope: scope.value, element: 0)
                
                if hasProperty {
                    let isSettable = try audioDevice.isPropertySettable(for: property.value, scope: scope.value, element: 0)
                    
                    var value: Any
                    
                    switch property.type {
                    case .UInt32:
                        value = try audioDevice.getUInt32(for: property.value, scope: scope.value, element: 0)
                    case .CFString:
                        value = try audioDevice.getString(for: property.value, scope: scope.value, element: 0)
                    case .UInt32Array:
                        value = try audioDevice.getUInt32s(for: property.value, scope: scope.value, element: 0)
                    case .URL:
                        value = try audioDevice.getURL(for: property.value, scope: scope.value, element: 0)
                    case .Double:
                        value = try audioDevice.getDouble(for: property.value, scope: scope.value, element: 0)
                    case .DoubleArray:
                        value = try audioDevice.getDoubles(for: property.value, scope: scope.value, element: 0)
                    case .Float32:
                        value = try audioDevice.getDouble(for: property.value, scope: scope.value, element: 0)
                    default:
                        value = "Unknown value"
                    }
                    print("audioDevice \(property) isSettable: \(isSettable) value: \(value) ")
                }
            }
        }
    }
    
    
}
