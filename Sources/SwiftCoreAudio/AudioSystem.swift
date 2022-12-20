//
//  AudioSystem.swift
//  
//
//  Created by Devin Roth on 2022-07-10.
//

import Foundation
import CoreAudio



public class AudioSystem: AudioObject {
    
    public static let shared = AudioSystem(audioObjectID: AudioObjectID(kAudioObjectSystemObject))
     
    @Published public var audioDevices = [AudioDevice]()

    @Published public private(set) var audioPlugIns = [AudioPlugIn]()

    @Published public private(set) var transportManagers = [TransportManager]()

    @Published public private(set) var audioBoxes = [AudioBox]()

    @Published public private(set) var clockDevices = [ClockDevice]()

    @Published public var defaultInputDevice: AudioDevice? {
        didSet {
            guard let defaultInputDevice = defaultInputDevice else {
                return
            }
            do {
                try setData(property: AudioSystemProperty.DefaultInputDevice, data: defaultInputDevice.audioObjectID)
            } catch {
                self.defaultInputDevice = oldValue
            }
        }
    }

#warning("Not working")
    @Published public var defaultOutputDevice: AudioDevice? {
        didSet {
            guard let defaultOutputDevice = defaultOutputDevice else {
                return
            }
            do {
                try setData(property: AudioSystemProperty.DefaultOutputDevice, scope: .wildcard, channel: 0, data: defaultOutputDevice.audioObjectID)
            } catch {
                self.defaultOutputDevice = oldValue
            }
        }
    }

    @Published public var defaultSystemOutputDevice: AudioDevice? {
        didSet {
            guard let defaultSystemOutputDevice = defaultSystemOutputDevice else {
                return
            }
            do {
                try setData(property: AudioSystemProperty.DefaultSystemOutputDevice, data: defaultSystemOutputDevice.audioObjectID)
            } catch {
                self.defaultSystemOutputDevice = oldValue
            }
        }
    }
    
    @Published public var mixStereoToMono = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.MixStereoToMono, data: mixStereoToMono)
            } catch {
                mixStereoToMono = oldValue
            }
        }
    }

    @Published public var processIsAudible = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.ProcessIsAudible, data: processIsAudible)
            } catch {
                processIsAudible = oldValue
            }
        }
    }
    
    @Published public var sleepingIsAllowed = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.SleepingIsAllowed, data: sleepingIsAllowed)
            } catch {
                sleepingIsAllowed = oldValue
            }
        }
    }
    
    @Published public var unloadingIsAllowed = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.UnloadingIsAllowed, data: unloadingIsAllowed)
            } catch {
                unloadingIsAllowed = oldValue
            }
        }
    }
    
    @Published public var hogModeIsAllowed = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.HogModeIsAllowed, data: hogModeIsAllowed)
            } catch {
                hogModeIsAllowed = oldValue
            }
        }
    }
    
    @Published public var powerSaverIsEnabled = false {
        didSet {
            do {
                try setData(property: AudioSystemProperty.HogModeIsAllowed, data: powerSaverIsEnabled)
            } catch {
                powerSaverIsEnabled = oldValue
            }
        }
    }
    
    @Published public private(set) var processIsMain = false
    
    @Published public private(set) var isInitingOrExiting = false
    
    @Published public private(set)  var userSessionIsActiveOrHeadless = false
    
    func updateAudioDevices() {
        if let audioObjectID = try? getData(property: AudioSystemProperty.Devices) as? [AudioDeviceID] {
            self.audioDevices = audioObjectID.map({ AudioDevice(audioObjectID: $0) })
        }
    }
    
    override func getProperties() {
        super.getProperties()

        if let audioObjectID = try? getData(property: AudioSystemProperty.Devices) as? [AudioDeviceID] {
            self.audioDevices = audioObjectID.map({ AudioDevice(audioObjectID: $0) })
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.PlugInList) as? [AudioObjectID] {
            self.audioPlugIns = audioObjectID.map({ AudioPlugIn(audioObjectID: $0) })
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.TransportManagerList) as? [AudioDeviceID] {
            self.transportManagers = audioObjectID.map({
                TransportManager(audioObjectID: $0)
            })
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.BoxList) as? [AudioDeviceID] {
            self.audioBoxes = audioObjectID.map({
                AudioBox(audioObjectID: $0)
            })
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.ClockDeviceList) as? [AudioDeviceID] {
            self.clockDevices = audioObjectID.map({
                ClockDevice(audioObjectID: $0)
            })
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultInputDevice) as? AudioDeviceID {
            self.defaultInputDevice = AudioDevice(audioObjectID: audioObjectID)
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultOutputDevice) as? AudioDeviceID {
            self.defaultOutputDevice = AudioDevice(audioObjectID: audioObjectID)
        }

        if let audioObjectID = try? getData(property: AudioSystemProperty.DefaultSystemOutputDevice) as? AudioDeviceID {
            self.defaultSystemOutputDevice = AudioDevice(audioObjectID: audioObjectID)
        }

        if let value = try? getData(property: AudioSystemProperty.MixStereoToMono) as? UInt32 {
            mixStereoToMono = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.ProcessIsMain) as? UInt32 {
            processIsMain = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.IsInitingOrExiting) as? UInt32 {
            isInitingOrExiting = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.ProcessIsAudible) as? UInt32 {
            processIsAudible = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.UnloadingIsAllowed) as? UInt32 {
            unloadingIsAllowed = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.HogModeIsAllowed) as? UInt32 {
            hogModeIsAllowed = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.UserSessionIsActiveOrHeadless) as? UInt32 {
            userSessionIsActiveOrHeadless = value != 0
        }

        if let value = try? getData(property: AudioSystemProperty.PowerHint) as? UInt32 {
            powerSaverIsEnabled = value != 0
        }
        setupListener()
    }
    
    func setupListener() {
        
        for property in AudioSystemProperty.allCases {
            
            var address = AudioObjectPropertyAddress(
                mSelector: AudioObjectPropertySelector(property.value),
                mScope: kAudioObjectPropertyScopeGlobal,
                mElement: kAudioObjectPropertyElementMain)
            
            let status = AudioObjectAddPropertyListener(AudioObjectID(kAudioObjectSystemObject), &address, listenerProc(), nil)
            
            print(status)
        }
        
    }
    
    func listenerProc() -> AudioObjectPropertyListenerProc {
        return { audioObjectID, _, address, _ in
            
            switch address.pointee.mSelector {
            case kAudioHardwarePropertyDevices:
                AudioSystem.shared.updateAudioDevices()
                print("Devices Changed")
            default:
                print("Something else")
            }

            return noErr
        }
    }
    

    static func getAudioDevice(from uniqueID: String) -> AudioDevice? {
        AudioSystem.shared.audioDevices.first { $0.deviceUID == uniqueID }
    }

    static func getAudioPlugIn(from bundleID: String) -> AudioPlugIn? {
        AudioSystem.shared.audioPlugIns.first { $0.bundleID == bundleID }
    }

    static func getTransportManager(from uniqueID: String) -> TransportManager? {
        AudioSystem.shared.transportManagers.first { $0.uniqueID == uniqueID }
    }

    static func getAudioBox(from uniqueID: String) -> AudioBox? {
        AudioSystem.shared.audioBoxes.first { $0.uniqueID == uniqueID }
    }

    static func getClockDevice(from uniqueID: String) -> ClockDevice? {
        AudioSystem.shared.clockDevices.first { $0.uniqueID == uniqueID }
    }

    public func userIDChanged() {}
//
//    // Only for notifications.
////    kAudioHardwarePropertyServiceRestarted                      = 'srst',
//
//    static func unload() {
//        AudioHardwareUnload()
//    }
//
//    #warning("To Do")
//    static func createAggregateDevice() {
//
//    }
//
//    static func destroyAggregateDevice() {
//
//    }

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
