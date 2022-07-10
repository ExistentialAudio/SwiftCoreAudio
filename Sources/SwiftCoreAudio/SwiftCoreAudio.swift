import CoreAudio
import Foundation


enum AudioError: LocalizedError {
    case unknownError(OSStatus)
    case audioHardwareNotRunningError
    case audioHardwareUnspecifiedError
    case audioHardwareUnknownPropertyError
    case audioHardwareBadPropertySizeError
    case audioHardwareIllegalOperationError
    case audioHardwareBadObjectError
    case audioHardwareBadDeviceError
    case audioHardwareBadStreamError
    case audioHardwareUnsupportedOperationError
    case audioHardwareNotReadyError
    case audioDeviceUnsupportedFormatError
    case audioDevicePermissionsError
    
    init(status: OSStatus) {
        switch status {
            case kAudioHardwareNotRunningError:
                self = .audioHardwareNotRunningError
            case kAudioHardwareUnspecifiedError:
                self = .audioHardwareUnspecifiedError
            case kAudioHardwareUnknownPropertyError:
                self = .audioHardwareUnknownPropertyError
            case kAudioHardwareBadPropertySizeError:
                self = .audioHardwareBadPropertySizeError
            case kAudioHardwareIllegalOperationError:
                self = .audioHardwareIllegalOperationError
            case kAudioHardwareBadObjectError:
                self = .audioHardwareBadObjectError
            case kAudioHardwareBadDeviceError:
                self = .audioHardwareBadDeviceError
            case kAudioHardwareBadStreamError:
                self = .audioHardwareBadStreamError
            case kAudioHardwareUnsupportedOperationError:
                self = .audioHardwareUnsupportedOperationError
            case kAudioHardwareNotReadyError:
                self = .audioHardwareNotReadyError
            case kAudioDeviceUnsupportedFormatError:
                self = .audioDeviceUnsupportedFormatError
            case kAudioDevicePermissionsError:
                self = .audioDevicePermissionsError
            default:
                self = .unknownError(status)
        }
    }
}

enum AudioObjectClass {
    case audioSystemObject
    case audioPlugIn
    case audioTransportManager
    case audioBox
    case audioDevice
    case audioClockDevice
    case audioEndPointDevice
    case audioEndPoint
    case audioStream
    case audioControl
    case audioSliderControl
    case audioLevelControl
    case audioVolumeControl
    case audioLFEVolumeControl
    case audioBooleanControl
    case audioMuteControl
    case audioSoloControl
    case audioJackControl
    case audioLFEMuteControl
    case audioPhantomPowerControl
    case audioPhaseInvertControl
    case audioClipLightControl
    case audioTalkbackControl
    case audioListenbackControl
    case audioSelectorControl
    case audioDataSourceControl
    case audioDataDestinationControl
    case audioClockSourceControl
    case audioLineLevelControl
    case audioHighPassFilterControl
    case audioStereoPanControl
    case unknown
    
    init(classID: AudioClassID) {
        switch classID {
        case kAudioSystemObjectClassID:
            self = .audioSystemObject
        case kAudioPlugInClassID:
            self = .audioPlugIn
        case kAudioTransportManagerClassID:
            self = .audioTransportManager
        case kAudioBoxClassID:
            self = .audioBox
        case kAudioDeviceClassID:
            self = .audioDevice
        case kAudioClockDeviceClassID:
            self = .audioClockDevice
        case kAudioEndPointDeviceClassID:
            self = .audioEndPointDevice
        case kAudioEndPointClassID:
            self = .audioEndPoint
        case kAudioStreamClassID:
            self = .audioStream
        case kAudioControlClassID:
            self = .audioControl
        case kAudioSliderControlClassID:
            self = .audioSliderControl
        case kAudioLevelControlClassID:
            self = .audioLevelControl
        case kAudioVolumeControlClassID:
            self = .audioVolumeControl
        case kAudioLFEVolumeControlClassID:
            self = .audioLFEVolumeControl
        case kAudioBooleanControlClassID:
            self = .audioBooleanControl
        case kAudioMuteControlClassID:
            self = .audioMuteControl
        case kAudioSoloControlClassID:
            self = .audioSoloControl
        case kAudioJackControlClassID:
            self = .audioJackControl
        case kAudioLFEMuteControlClassID:
            self = .audioLFEMuteControl
        case kAudioPhantomPowerControlClassID:
            self = .audioPhantomPowerControl
        case kAudioPhaseInvertControlClassID:
            self = .audioPhaseInvertControl
        case kAudioClipLightControlClassID:
            self = .audioClipLightControl
        case kAudioTalkbackControlClassID:
            self = .audioTalkbackControl
        case kAudioListenbackControlClassID:
            self = .audioListenbackControl
        case kAudioSelectorControlClassID:
            self = .audioSelectorControl
        case kAudioDataSourceControlClassID:
            self = .audioDataSourceControl
        case kAudioDataDestinationControlClassID:
            self = .audioDataDestinationControl
        case kAudioClockSourceControlClassID:
            self = .audioClockSourceControl
        case kAudioLineLevelControlClassID:
            self = .audioLineLevelControl
        case kAudioHighPassFilterControlClassID:
            self = .audioHighPassFilterControl
        case kAudioStereoPanControlClassID:
            self = .audioStereoPanControl
        default:
            self = .unknown
        }
    }
    

}

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

// Singleton Class
class AudioSystem: AudioObject {
    
    static let audioSystem = AudioSystem(audioObjectID: AudioObjectID(kAudioObjectSystemObject))
    
    static public var devices: [AudioDevice] {
        get throws {
            let audioDeviceIDs = try audioSystem.getInts(for: kAudioHardwarePropertyDevices)
            var audioDevices = [AudioDevice]()
            for audioDeviceID in audioDeviceIDs {
                audioDevices.append(AudioDevice(audioObjectID: audioDeviceID))
            }
            return audioDevices
        }
    }
    
    static public var defaultInputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultInputDevice))
        }
    }
    
    static public var defaultOutputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultOutputDevice))
        }
    }
    
    static public var defaultSystemOutputDevice: AudioDevice {
        get throws {
            AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyDefaultSystemOutputDevice))
        }
    }
    
    static public func getAudioDevice(from uniqueID: String) throws -> AudioDevice {
        return AudioDevice(audioObjectID: try audioSystem.getInt(for: kAudioHardwarePropertyTranslateUIDToDevice, qualifier: uniqueID))
    }

//    kAudioHardwarePropertyMixStereoToMono                       = 'stmo',
//    kAudioHardwarePropertyPlugInList                            = 'plg#',
//    kAudioHardwarePropertyTranslateBundleIDToPlugIn             = 'bidp',
//    kAudioHardwarePropertyTransportManagerList                  = 'tmg#',
//    kAudioHardwarePropertyTranslateBundleIDToTransportManager   = 'tmbi',
//    kAudioHardwarePropertyBoxList                               = 'box#',
//    kAudioHardwarePropertyTranslateUIDToBox                     = 'uidb',
//    kAudioHardwarePropertyClockDeviceList                       = 'clk#',
//    kAudioHardwarePropertyTranslateUIDToClockDevice             = 'uidc',
//    kAudioHardwarePropertyProcessIsMain                            = 'main',
//    kAudioHardwarePropertyIsInitingOrExiting                    = 'inot',
//    kAudioHardwarePropertyUserIDChanged                         = 'euid',
//    kAudioHardwarePropertyProcessIsAudible                      = 'pmut',
//    kAudioHardwarePropertySleepingIsAllowed                     = 'slep',
//    kAudioHardwarePropertyUnloadingIsAllowed                    = 'unld',
//    kAudioHardwarePropertyHogModeIsAllowed                      = 'hogr',
//    kAudioHardwarePropertyUserSessionIsActiveOrHeadless         = 'user',
//    kAudioHardwarePropertyServiceRestarted                      = 'srst',
//    kAudioHardwarePropertyPowerHint                             = 'powh'
    
//    AudioHardwareUnload
//    AudioHardwareCreateAggregateDevice
//    AudioHardwareDestroyAggregateDevice
    

}

class AudioServerPlugIn: AudioObject {
    
//    kAudioPlugInClassID = 'aplg'
    
//    kAudioPlugInPropertyBundleID                  = 'piid',
//    kAudioPlugInPropertyDeviceList                = 'dev#',
//    kAudioPlugInPropertyTranslateUIDToDevice      = 'uidd',
//    kAudioPlugInPropertyBoxList                   = 'box#',
//    kAudioPlugInPropertyTranslateUIDToBox         = 'uidb',
//    kAudioPlugInPropertyClockDeviceList           = 'clk#',
//    kAudioPlugInPropertyTranslateUIDToClockDevice = 'uidc'
    
//    kAudioPlugInCreateAggregateDevice   = 'cagg',
//    kAudioPlugInDestroyAggregateDevice  = 'dagg'
}

class AudioTransportManager: AudioObject {
    
//    kAudioTransportManagerClassID   = 'trpm'
    
//    kAudioTransportManagerPropertyEndPointList              = 'end#',
//    kAudioTransportManagerPropertyTranslateUIDToEndPoint    = 'uide',
//    kAudioTransportManagerPropertyTransportType             = 'tran'
    
//    kAudioTransportManagerCreateEndPointDevice  = 'cdev',
//    kAudioTransportManagerDestroyEndPointDevice = 'ddev'
}

class AudioBox: AudioObject {
 
    //    kAudioTransportManagerClassID   = 'trpm'
//    kAudioBoxClassID    = 'abox'
    
//    kAudioBoxPropertyBoxUID             = 'buid',
//    kAudioBoxPropertyTransportType      = 'tran',
//    kAudioBoxPropertyHasAudio           = 'bhau',
//    kAudioBoxPropertyHasVideo           = 'bhvi',
//    kAudioBoxPropertyHasMIDI            = 'bhmi',
//    kAudioBoxPropertyIsProtected        = 'bpro',
//    kAudioBoxPropertyAcquired           = 'bxon',
//    kAudioBoxPropertyAcquisitionFailed  = 'bxof',
//    kAudioBoxPropertyDeviceList         = 'bdv#',
//    kAudioBoxPropertyClockDeviceList    = 'bcl#'
}

class AudioDevice: AudioObject {
    
    //    kAudioTransportManagerClassID   = 'trpm'
//    kAudioBoxClassID    = 'abox'
//    kAudioDeviceClassID = 'adev'
    
//    kAudioDeviceTransportTypeUnknown        = 0,
//    kAudioDeviceTransportTypeBuiltIn        = 'bltn',
//    kAudioDeviceTransportTypeAggregate      = 'grup',
//    kAudioDeviceTransportTypeVirtual        = 'virt',
//    kAudioDeviceTransportTypePCI            = 'pci ',
//    kAudioDeviceTransportTypeUSB            = 'usb ',
//    kAudioDeviceTransportTypeFireWire       = '1394',
//    kAudioDeviceTransportTypeBluetooth      = 'blue',
//    kAudioDeviceTransportTypeBluetoothLE    = 'blea',
//    kAudioDeviceTransportTypeHDMI           = 'hdmi',
//    kAudioDeviceTransportTypeDisplayPort    = 'dprt',
//    kAudioDeviceTransportTypeAirPlay        = 'airp',
//    kAudioDeviceTransportTypeAVB            = 'eavb',
//    kAudioDeviceTransportTypeThunderbolt    = 'thun'
    
    
//    kAudioDevicePropertyConfigurationApplication        = 'capp',
//    kAudioDevicePropertyDeviceUID                       = 'uid ',
//    kAudioDevicePropertyModelUID                        = 'muid',
//    kAudioDevicePropertyTransportType                   = 'tran',
//    kAudioDevicePropertyRelatedDevices                  = 'akin',
//    kAudioDevicePropertyClockDomain                     = 'clkd',
//    kAudioDevicePropertyDeviceIsAlive                   = 'livn',
//    kAudioDevicePropertyDeviceIsRunning                 = 'goin',
//    kAudioDevicePropertyDeviceCanBeDefaultDevice        = 'dflt',
//    kAudioDevicePropertyDeviceCanBeDefaultSystemDevice  = 'sflt',
//    kAudioDevicePropertyLatency                         = 'ltnc',
//    kAudioDevicePropertyStreams                         = 'stm#',
//    kAudioObjectPropertyControlList                     = 'ctrl',
//    kAudioDevicePropertySafetyOffset                    = 'saft',
//    kAudioDevicePropertyNominalSampleRate               = 'nsrt',
//    kAudioDevicePropertyAvailableNominalSampleRates     = 'nsr#',
//    kAudioDevicePropertyIcon                            = 'icon',
//    kAudioDevicePropertyIsHidden                        = 'hidn',
//    kAudioDevicePropertyPreferredChannelsForStereo      = 'dch2',
//    kAudioDevicePropertyPreferredChannelLayout          = 'srnd'
    
//
//    kAudioDevicePropertyPlugIn                          = 'plug',
//    kAudioDevicePropertyDeviceHasChanged                = 'diff',
//    kAudioDevicePropertyDeviceIsRunningSomewhere        = 'gone',
//    kAudioDeviceProcessorOverload                       = 'over',
//    kAudioDevicePropertyIOStoppedAbnormally             = 'stpd',
//    kAudioDevicePropertyHogMode                         = 'oink',
//    kAudioDevicePropertyBufferFrameSize                 = 'fsiz',
//    kAudioDevicePropertyBufferFrameSizeRange            = 'fsz#',
//    kAudioDevicePropertyUsesVariableBufferFrameSizes    = 'vfsz',
//    kAudioDevicePropertyIOCycleUsage                    = 'ncyc',
//    kAudioDevicePropertyStreamConfiguration             = 'slay',
//    kAudioDevicePropertyIOProcStreamUsage               = 'suse',
//    kAudioDevicePropertyActualSampleRate                = 'asrt',
//    kAudioDevicePropertyClockDevice                     = 'apcd',
//    kAudioDevicePropertyIOThreadOSWorkgroup             = 'oswg',
//    kAudioDevicePropertyProcessMute                        = 'appm'
    
//    kAudioDevicePropertyJackIsConnected                                 = 'jack',
//    kAudioDevicePropertyVolumeScalar                                    = 'volm',
//    kAudioDevicePropertyVolumeDecibels                                  = 'vold',
//    kAudioDevicePropertyVolumeRangeDecibels                             = 'vdb#',
//    kAudioDevicePropertyVolumeScalarToDecibels                          = 'v2db',
//    kAudioDevicePropertyVolumeDecibelsToScalar                          = 'db2v',
//    kAudioDevicePropertyStereoPan                                       = 'span',
//    kAudioDevicePropertyStereoPanChannels                               = 'spn#',
//    kAudioDevicePropertyMute                                            = 'mute',
//    kAudioDevicePropertySolo                                            = 'solo',
//    kAudioDevicePropertyPhantomPower                                    = 'phan',
//    kAudioDevicePropertyPhaseInvert                                     = 'phsi',
//    kAudioDevicePropertyClipLight                                       = 'clip',
//    kAudioDevicePropertyTalkback                                        = 'talb',
//    kAudioDevicePropertyListenback                                      = 'lsnb',
//    kAudioDevicePropertyDataSource                                      = 'ssrc',
//    kAudioDevicePropertyDataSources                                     = 'ssc#',
//    kAudioDevicePropertyDataSourceNameForIDCFString                     = 'lscn',
//    kAudioDevicePropertyDataSourceKindForID                             = 'ssck',
//    kAudioDevicePropertyClockSource                                     = 'csrc',
//    kAudioDevicePropertyClockSources                                    = 'csc#',
//    kAudioDevicePropertyClockSourceNameForIDCFString                    = 'lcsn',
//    kAudioDevicePropertyClockSourceKindForID                            = 'csck',
//    kAudioDevicePropertyPlayThru                                        = 'thru',
//    kAudioDevicePropertyPlayThruSolo                                    = 'thrs',
//    kAudioDevicePropertyPlayThruVolumeScalar                            = 'mvsc',
//    kAudioDevicePropertyPlayThruVolumeDecibels                          = 'mvdb',
//    kAudioDevicePropertyPlayThruVolumeRangeDecibels                     = 'mvd#',
//    kAudioDevicePropertyPlayThruVolumeScalarToDecibels                  = 'mv2d',
//    kAudioDevicePropertyPlayThruVolumeDecibelsToScalar                  = 'mv2s',
//    kAudioDevicePropertyPlayThruStereoPan                               = 'mspn',
//    kAudioDevicePropertyPlayThruStereoPanChannels                       = 'msp#',
//    kAudioDevicePropertyPlayThruDestination                             = 'mdds',
//    kAudioDevicePropertyPlayThruDestinations                            = 'mdd#',
//    kAudioDevicePropertyPlayThruDestinationNameForIDCFString            = 'mddc',
//    kAudioDevicePropertyChannelNominalLineLevel                         = 'nlvl',
//    kAudioDevicePropertyChannelNominalLineLevels                        = 'nlv#',
//    kAudioDevicePropertyChannelNominalLineLevelNameForIDCFString        = 'lcnl',
//    kAudioDevicePropertyHighPassFilterSetting                           = 'hipf',
//    kAudioDevicePropertyHighPassFilterSettings                          = 'hip#',
//    kAudioDevicePropertyHighPassFilterSettingNameForIDCFString          = 'hipl',
//    kAudioDevicePropertySubVolumeScalar                                 = 'svlm',
//    kAudioDevicePropertySubVolumeDecibels                               = 'svld',
//    kAudioDevicePropertySubVolumeRangeDecibels                          = 'svd#',
//    kAudioDevicePropertySubVolumeScalarToDecibels                       = 'sv2d',
//    kAudioDevicePropertySubVolumeDecibelsToScalar                       = 'sd2v',
//    kAudioDevicePropertySubMute                                         = 'smut'
    
//    AudioDeviceIOBlock
//    AudioDeviceIOProc
//    AudioHardwareIOProcStreamUsage
    
//    AudioDeviceCreateIOProcID
//    AudioDeviceCreateIOProcIDWithBlock
//    AudioDeviceDestroyIOProcID
//    AudioDeviceStart
//    AudioDeviceStartAtTime
//    AudioDeviceStop
//    AudioDeviceGetCurrentTime
//    AudioDeviceTranslateTime
//    AudioDeviceGetNearestStartTime
    
}


class AudioClockDevice {
    
    //    kAudioTransportManagerClassID   = 'trpm'
//    kAudioBoxClassID    = 'abox'
//    kAudioDeviceClassID = 'adev'
//    kAudioClockDeviceClassID    = 'aclk'
    
//    kAudioClockDevicePropertyDeviceUID                   = 'cuid',
//    kAudioClockDevicePropertyTransportType               = 'tran',
//    kAudioClockDevicePropertyClockDomain                 = 'clkd',
//    kAudioClockDevicePropertyDeviceIsAlive               = 'livn',
//    kAudioClockDevicePropertyDeviceIsRunning             = 'goin',
//    kAudioClockDevicePropertyLatency                     = 'ltnc',
//    kAudioClockDevicePropertyControlList                 = 'ctrl',
//    kAudioClockDevicePropertyNominalSampleRate           = 'nsrt',
//    kAudioClockDevicePropertyAvailableNominalSampleRates = 'nsr#'
    
}

class AudioEndpointDevice {
    

    
//    #define kAudioEndPointDeviceUIDKey  "uid"
//    #define kAudioEndPointDeviceNameKey "name"
//    #define kAudioEndPointDeviceEndPointListKey "endpoints"
//    #define kAudioEndPointDeviceMasterEndPointKey   "master"
//    #define kAudioEndPointDeviceIsPrivateKey    "private"
    
//    kAudioEndPointDevicePropertyComposition         = 'acom',
//    kAudioEndPointDevicePropertyEndPointList        = 'agrp',
//    kAudioEndPointDevicePropertyIsPrivate           = 'priv'
    
    
    
}

class AudioEndPoint: AudioDevice {
    

    
//    #define kAudioEndPointUIDKey    "uid"
//    #define kAudioEndPointNameKey   "name"
//    #define kAudioEndPointInputChannelsKey  "channels-in"
//    #define kAudioEndPointOutputChannelsKey "channels-out"

}

class AudioStream: AudioDevice {

    
//    kAudioStreamTerminalTypeUnknown                 = 0,
//    kAudioStreamTerminalTypeLine                    = 'line',
//    kAudioStreamTerminalTypeDigitalAudioInterface   = 'spdf',
//    kAudioStreamTerminalTypeSpeaker                 = 'spkr',
//    kAudioStreamTerminalTypeHeadphones              = 'hdph',
//    kAudioStreamTerminalTypeLFESpeaker              = 'lfes',
//    kAudioStreamTerminalTypeReceiverSpeaker         = 'rspk',
//    kAudioStreamTerminalTypeMicrophone              = 'micr',
//    kAudioStreamTerminalTypeHeadsetMicrophone       = 'hmic',
//    kAudioStreamTerminalTypeReceiverMicrophone      = 'rmic',
//    kAudioStreamTerminalTypeTTY                     = 'tty_',
//    kAudioStreamTerminalTypeHDMI                    = 'hdmi',
//    kAudioStreamTerminalTypeDisplayPort             = 'dprt'
    
//    kAudioStreamPropertyIsActive                    = 'sact',
//    kAudioStreamPropertyDirection                   = 'sdir',
//    kAudioStreamPropertyTerminalType                = 'term',
//    kAudioStreamPropertyStartingChannel             = 'schn',
//    kAudioStreamPropertyLatency                     = kAudioDevicePropertyLatency,
//    kAudioStreamPropertyVirtualFormat               = 'sfmt',
//    kAudioStreamPropertyAvailableVirtualFormats     = 'sfma',
//    kAudioStreamPropertyPhysicalFormat              = 'pft ',
//    kAudioStreamPropertyAvailablePhysicalFormats    = 'pfta'
}


class AudioControl {
    

    
//    kAudioControlPropertyScope      = 'cscp',
//    kAudioControlPropertyElement    = 'celm'
    
}

class AudioSliderControl {
    
    

    
//    kAudioSliderControlPropertyValue    = 'sdrv',
//    kAudioSliderControlPropertyRange    = 'sdrr'
    
}

class AudioLevelControl {
    

    
//    kAudioLevelControlPropertyScalarValue               = 'lcsv',
//    kAudioLevelControlPropertyDecibelValue              = 'lcdv',
//    kAudioLevelControlPropertyDecibelRange              = 'lcdr',
//    kAudioLevelControlPropertyConvertScalarToDecibels   = 'lcsd',
//    kAudioLevelControlPropertyConvertDecibelsToScalar   = 'lcds'
    
    
}

class AudioBooleanControl {
    

    
//    kAudioBooleanControlPropertyValue   = 'bcvl'
}

class AudioSelectorControl {
    

    
//    kAudioSelectorControlPropertyCurrentItem    = 'scci',
//    kAudioSelectorControlPropertyAvailableItems = 'scai',
//    kAudioSelectorControlPropertyItemName       = 'scin',
//    kAudioSelectorControlPropertyItemKind       = 'clkk'
    
//    kAudioSelectorControlItemKindSpacer = 'spcr'
//    kAudioClockSourceItemKindInternal   = 'int '
    
}


class AudioStereoPanControl {
    

    
//    kAudioStereoPanControlPropertyValue             = 'spcv',
//    kAudioStereoPanControlPropertyPanningChannels   = 'spcc'
}

class AudioAggregateDevice {
    
//    kAudioAggregateDeviceClassID            = 'aagg'
//    #define kAudioAggregateDeviceUIDKey             "uid"
//    #define kAudioAggregateDeviceNameKey            "name"
//    #define kAudioAggregateDeviceSubDeviceListKey   "subdevices"
//    #define kAudioAggregateDeviceMainSubDeviceKey "master"
//    #define kAudioAggregateDeviceClockDeviceKey     "clock"
//    #define kAudioAggregateDeviceIsPrivateKey       "private"
//    #define kAudioAggregateDeviceIsStackedKey       "stacked"
}
