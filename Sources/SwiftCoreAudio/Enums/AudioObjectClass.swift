//
//  CoreAudio.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

public enum AudioObjectClass {
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
