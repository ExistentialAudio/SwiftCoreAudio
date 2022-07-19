//
//  AudioObjectView.swift
//  SwiftCoreAudioTest
//
//  Created by Devin Roth on 2022-07-18.
//

import SwiftUI
import SwiftCoreAudio

struct AudioObjectView: View {
    
    let audioObject: AudioObject
    
    var body: some View {
        VStack {
            if let name = audioObject.name {
                Text("Name: \(name)")
            }
            if let manufacturer = audioObject.manufacturer {
                Text("Manufacturer: \(manufacturer)")
            }
            if let elementName = audioObject.elementName {
                Text("Element Name: \(elementName)")
            }
            if let elementNumberName = audioObject.elementNumberName {
                Text("Element Number Name: \(elementNumberName)")
            }
            if let serialNumber = audioObject.serialNumber {
                Text("Serial Number: \(serialNumber)")
            }
            if let firmwareVersion = audioObject.firmwareVersion {
                Text("Firmware Version: \(firmwareVersion)")
            }
            if let modelName = audioObject.modelName {
                Text("Model Name: \(modelName)")
            }
            if let identifyIsEnabled = audioObject.identifyIsEnabled {
                Text("Identify Is Enabled: \(identifyIsEnabled ? "True" : "False")")
            }
        }
    }
}

struct AudioObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AudioObjectView(audioObject: AudioDevice(uniqueID: "NullAudioDevice_UID")!)
    }
}
