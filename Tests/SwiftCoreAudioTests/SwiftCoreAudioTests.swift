import XCTest
@testable import SwiftCoreAudio
import CoreAudio


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

                
                let hasProperty = audioPlugIn.hasProperty(for: property.value, scope: AudioScope2.Global.value, element: 0)
                
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
            
                let hasProperty = audioBox.hasProperty(for: property.value, scope: AudioScope2.Global.value, element: 0)

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
                
                let hasProperty = audioBox.hasProperty(for: property.value, scope: AudioScope2.Global.value, element: 0)
                
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
            
            let hasProperty = audioDevice.hasProperty(for: property.value, scope: AudioScope2.Global.value, element: 0)
            
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
            for scope in AudioScope2.allCases {
                
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
    
    func testAudio() throws {
    
        let audioDevice = try AudioSystem.getAudioDevice(from: "NullAudioDevice_UID")
        XCTAssertEqual(audioDevice.has(property: AudioObjectProperty.Name), true)
        try XCTAssertEqual(audioDevice.getData(property: AudioObjectProperty.Name) as! String, "")
    }
    
}
