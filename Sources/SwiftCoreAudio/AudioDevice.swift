//
//  AudioDevice.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public class AudioDevice: AudioObject {

    public var configurationApplicationBundleID: String?
    
    public var deviceUID: String?
    
    public var modelUID: String?
    
    public var transportType: TransportType?
    
    public var relatedAudioDevices: [AudioDevice]?
    
    public var clockDomain: Int?

    public var isAlive: Bool?
    
    public var isRunning: Bool?
    
    public var canBeDefaultDevice: Bool?
    
    public var canBeSystemDevice: Bool?
 
    public var latency: Int?
    
    public var streams = [Stream]()
    
    public var controls = [Control]()
    
    public var safetyOffset: Int?
    
    public var nominalSampleRate: Double?
    
    public var availableNominalSampleRates: [Double]?
    
    public var icon: URL?
    
    public var isHidden: Bool?
    
    public var preferredChannelsForStereo: (left: Int, right: Int)?
    
    public var preferredChannelLayout: AudioChannelLayout?
    
    public var plugInError: AudioError?
    
    
    /*
    A pid_t indicating the process that currently owns exclusive access to the
    AudioDevice or a value of -1 indicating that the device is currently
    available to all processes. If the AudioDevice is in a non-mixable mode,
    the HAL will automatically take hog mode on behalf of the first process to
    start an IOProc.
    Note that when setting this property, the value passed in is ignored. If
    another process owns exclusive access, that remains unchanged. If the
    current process owns exclusive access, it is released and made available to
    all processes again. If no process has exclusive access (meaning the current
    value is -1), this process gains ownership of exclusive access.  On return,
    the pid_t pointed to by inPropertyData will contain the new value of the
    property.
    */
    public var hogModeProcessID: pid_t?
    
    public var bufferFrameSize: Int?

    public var bufferFrameSizeRange: ClosedRange<Int>?
    
    public var variableBufferMaxFrameSize: Int?

    public var IOCycleUsage: Double?

    public var streamConfiguration: AudioBufferList?
    
    public var IOProcStreamUsage: AudioHardwareIOProcStreamUsage?

    public var actualSampleRate: Double?
    
    public var clockDevice: ClockDevice?
    
    public var IOThreadOSWorkgroup: WorkGroup?

    public var isProcessMuted: Bool?
    
    public init?(uniqueID: String) {
        
        guard let audioDevice = AudioSystem.getAudioDevice(from: uniqueID) else {
            return nil
        }
        
        super.init(audioObjectID: audioDevice.audioObjectID)

    }
    
    override init(audioObjectID: AudioObjectID) {
        super.init(audioObjectID: audioObjectID)
    }
    
    
    
//
//    // Implimented in AudioControls
//    public func getJackIsConnected(for direction: AudioDirection, channel: Int) throws -> Bool {
//        try getUInt32(
//            for: kAudioDevicePropertyJackIsConnected,
//            scope: AudioObjectPropertyScope(direction.rawValue),
//            element: AudioObjectPropertyElement(channel)
//        ) != 0
//    }
//
//    public func setJackIsConnect(for direction: AudioDirection, channel: Int, to value: Bool) throws {
//        try setUInt32(
//            for: kAudioDevicePropertyJackIsConnected,
//            scope: AudioObjectPropertyScope(direction.rawValue),
//            element: AudioObjectPropertyElement(channel),
//            to: value ? 1 : 0
//        )
//    }
//
//    public func getVolume(for scope: AudioScope, channel: Int) throws -> Double {
//        Double(try getFloat32(
//            for: kAudioDevicePropertyVolumeScalar,
//            scope: scope.value,
//            element: UInt32(channel)
//        ))
//    }
//
//    public func setVolume(for scope: AudioScope, channel: Int, to value: Double) throws {
//        try setFloat32(
//            for: kAudioDevicePropertyVolumeScalar,
//            scope: scope.value,
//            element: UInt32(channel),
//            to: Float32(value)
//        )
//    }
//
//    public func getDecibels(for direction: AudioDirection, channel: Int) throws -> Double {
//        Double(try getFloat32(
//            for: kAudioDevicePropertyVolumeDecibels,
//            scope: AudioObjectPropertyScope(direction.rawValue),
//            element: AudioObjectPropertyElement(channel)
//        ))
//    }
//
//    public func setDecibels(for direction: AudioDirection, channel: Int, to value: Double) throws {
//        try setFloat32(
//            for: kAudioDevicePropertyVolumeDecibels,
//            scope: AudioObjectPropertyScope(direction.rawValue),
//            element: AudioObjectPropertyElement(channel),
//            to: Float32(value)
//        )
//    }
    
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
    
    // Methods
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
 
    // For Listeners Only
    //    kAudioDevicePropertyDeviceHasChanged                = 'diff',
    // kAudioDeviceProcessorOverload
//    kAudioDevicePropertyIOStoppedAbnormally
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
