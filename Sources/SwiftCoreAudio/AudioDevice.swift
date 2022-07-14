//
//  AudioDevice.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

class AudioDevice: AudioObject {

    public var configurationApplicationBundleID: String {
        get throws {
            try getString(for: kAudioDevicePropertyConfigurationApplication)
        }
    }
    
    public var deviceUID: String {
        get throws {
            try getString(for: kAudioDevicePropertyDeviceUID)
        }
    }
    
    public var modelUID: String {
        get throws {
            try getString(for: kAudioDevicePropertyModelUID)
        }
    }
    
    public var transportType: TransportType {
        get throws {
            try TransportType(value: getUInt32(for: kAudioBoxPropertyTransportType))
        }
    }
    
    public var relatedAudioDevices: [AudioDevice] {
        get throws {
            let audioDeviceIDs = try getUInt32s(for: kAudioDevicePropertyRelatedDevices)
            var audioDevices = [AudioDevice]()
            for audioDeviceID in audioDeviceIDs {
                audioDevices.append(AudioDevice(audioObjectID: audioDeviceID))
            }
            
            return audioDevices
        }
    }
    
    public var clockDomain: Int {
        get throws {
            try Int(getUInt32(for: kAudioDevicePropertyRelatedDevices))
        }
    }

    public var isAlive: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyDeviceIsAlive) == 0 ? false : true
        }
    }
    
    public var isRunning: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyDeviceIsRunning) == 0 ? false : true
        }
    }
    
    public var canBeDefaultDevice: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyDeviceCanBeDefaultDevice) == 0 ? false : true
        }
    }
    
    public var canBeSystemDevice: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyDeviceCanBeDefaultSystemDevice) == 0 ? false : true
        }
    }
    
    public func setCanBeSystemDevice(to value: Bool) throws {
        try setUInt32(for: kAudioDevicePropertyDeviceCanBeDefaultDevice, scope: kAudioDevicePropertyScopeOutput, element: 0, to: value ? 1 : 0)
    }
    
    public var latency: Int {
        get throws {
            try Int(getUInt32(for: kAudioDevicePropertyLatency))
        }
    }
    
    public var streams: [Stream] {
        get throws {
            let audioObjectIDs = try getUInt32s(for: kAudioDevicePropertyRelatedDevices)
            var streams = [Stream]()
            for audioObjectID in audioObjectIDs {
                streams.append(Stream(audioObjectID: audioObjectID))
            }
            
            return streams
        }
    }
    
    public var controls: [Control] {
        get throws {
            let audioObjectIDs = try getUInt32s(for: kAudioDevicePropertyRelatedDevices)
            var controls = [Control]()
            for audioObjectID in audioObjectIDs {
                controls.append(Control(audioObjectID: audioObjectID))
            }
            
            return controls
        }
    }

    public var safetyOffset: Int {
        get throws {
            try Int(getUInt32(for: kAudioDevicePropertySafetyOffset))
        }
    }
    
    public var nominalSampleRate: Double {
        get throws {
            try getDouble(for: kAudioDevicePropertyNominalSampleRate)
        }
    }
    
    public func setNominalSampleRate(sampleRate: Double) throws {
        try setDouble(for: kAudioDevicePropertyNominalSampleRate, to: sampleRate)
    }
    
    public var availableNominalSampleRates: [Double] {
        get throws {
            try getDoubles(for: kAudioDevicePropertyAvailableNominalSampleRates)
        }
    }
    
    public var icon: URL {
        get throws {
            try getURL(for: kAudioDevicePropertyIcon)
        }
    }
    
    public var isHidden: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyIsHidden) == 0 ? false : true
        }
    }
    
    public var preferredChannelsForStereo: (left: Int, right: Int) {
        get throws {
            let stereoChannels = try getUInt32s(for: kAudioDevicePropertyPreferredChannelsForStereo)
            return (Int(stereoChannels[0]), Int(stereoChannels[1]))
        }
    }
    
    public var preferredChannelLayout: AudioChannelLayout {
        get throws {
            try getAudioChannelLayout(for: kAudioDevicePropertyPreferredChannelLayout)
        }
    }
    
    public var plugInError: AudioError {
        get throws {
            try AudioError(status: OSStatus(getUInt32(for: kAudioDevicePropertyPlugIn)))
        }
    }
    
    
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
    public var hogModeProcessID: pid_t? {
        get throws {
            let pid = try Int32(getInt32(for: kAudioDevicePropertyHogMode))
            return pid == -1 ? nil : pid
        }
    }
    
    public func toggleHodMode() throws {
        try setInt32(for: kAudioDevicePropertyHogMode, to: 0)
    }
    
    public var bufferFrameSize: Int {
        get throws {
            try Int(getUInt32(for: kAudioDevicePropertyBufferFrameSize))
        }
    }

    public func setBufferFrameSize(to frameSize: Int) throws {
        try setUInt32(for: kAudioDevicePropertyBufferFrameSize, to: UInt32(frameSize))
    }

    public var bufferFrameSizeRange: ClosedRange<Int> {
        get throws {
            let range = try getUInt32s(for: kAudioDevicePropertyBufferFrameSizeRange)
            return Int(range[0])...Int(range[1])
        }
    }
    
    public var variableBufferMaxFrameSize: Int {
        get throws {
            try Int(getUInt32(for: kAudioDevicePropertyUsesVariableBufferFrameSizes))
        }
    }

    public var IOCycleUsage: Double {
        get throws {
            try getDouble(for: kAudioDevicePropertyIOCycleUsage)
        }
    }

    public var streamConfiguration: AudioBufferList {
        get throws {
            try getAudioBufferList(for: kAudioDevicePropertyStreamConfiguration)
        }
    }
    
    public var IOProcStreamUsage: AudioHardwareIOProcStreamUsage {
        get throws {
            try getAudioHardwareIOProcStreamUsage(for: kAudioDevicePropertyIOProcStreamUsage)
        }
    }

    public var actualSampleRate: Double {
        get throws {
            try getDouble(for: kAudioDevicePropertyActualSampleRate)
        }
    }

    public var clockDevice: ClockDevice {
        get throws {
            ClockDevice(audioObjectID: try getUInt32(for: kAudioDevicePropertyClockDevice))
        }
    }
    
    @available(macOS 11, *)
    public var IOThreadOSWorkgroup: WorkGroup {
        get throws {
            WorkGroup(__name: nil, port: 0)!
        }
    }

    public var isProcessMuted: Bool {
        get throws {
            try getUInt32(for: kAudioDevicePropertyProcessMute) == 0 ? false : true
        }
    }
    
    public func setIsProcessMuted(isMuted: Bool) throws {
        try setUInt32(for: kAudioDevicePropertyProcessMute, to: isMuted ? 1 : 0)
    }
    
    // Implimented in AudioControls
    public func getJackIsConnected(for direction: AudioDirection, channel: Int) throws -> Bool {
        try getUInt32(
            for: kAudioDevicePropertyJackIsConnected,
            scope: AudioObjectPropertyScope(direction.rawValue),
            element: AudioObjectPropertyElement(channel)
        ) != 0
    }

    public func setJackIsConnect(for direction: AudioDirection, channel: Int, to value: Bool) throws {
        try setUInt32(
            for: kAudioDevicePropertyJackIsConnected,
            scope: AudioObjectPropertyScope(direction.rawValue),
            element: AudioObjectPropertyElement(channel),
            to: value ? 1 : 0
        )
    }
    
    public func getVolume(for scope: AudioScope, channel: Int) throws -> Double {
        Double(try getFloat32(
            for: kAudioDevicePropertyVolumeScalar,
            scope: scope.value,
            element: UInt32(channel)
        ))
    }
    
    public func setVolume(for scope: AudioScope, channel: Int, to value: Double) throws {
        try setFloat32(
            for: kAudioDevicePropertyVolumeScalar,
            scope: scope.value,
            element: UInt32(channel),
            to: Float32(value)
        )
    }
    
    public func getDecibels(for direction: AudioDirection, channel: Int) throws -> Double {
        Double(try getFloat32(
            for: kAudioDevicePropertyVolumeDecibels,
            scope: AudioObjectPropertyScope(direction.rawValue),
            element: AudioObjectPropertyElement(channel)
        ))
    }
    
    public func setDecibels(for direction: AudioDirection, channel: Int, to value: Double) throws {
        try setFloat32(
            for: kAudioDevicePropertyVolumeDecibels,
            scope: AudioObjectPropertyScope(direction.rawValue),
            element: AudioObjectPropertyElement(channel),
            to: Float32(value)
        )
    }
    
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

