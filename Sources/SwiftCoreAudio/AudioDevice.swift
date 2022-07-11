//
//  AudioDevice.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

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

