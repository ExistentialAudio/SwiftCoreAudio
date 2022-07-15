//
//  AudioError.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio

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
    case audioObjectUnknownUniqueID
    case notSupported
    
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
