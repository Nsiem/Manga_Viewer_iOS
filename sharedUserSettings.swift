//
//  sharedUserSettings.swift
//  kech8960_FinalProject
//
//  Created by Antony Kechichian on 2022-04-09.
//

import Foundation
import UIKit

class SharedSettings {
    static let sharedsettings = SharedSettings()
    var usersSettings: userSettings?
    
    var storageurlSettings : URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("StorageSettings.file")
    }
    // method to restore the person collection from a file

    func restoreSettings(){
        let jsonDecoder = JSONDecoder()
        var data = Data()
        do {
            data = try Data(contentsOf: storageurlSettings)
        } catch {
            print("Failed to restore user settings")
        }
        
        do {
            usersSettings = try jsonDecoder.decode(userSettings.self, from: data)
        } catch {
            print("Failed to load")
        }
        
    }

    // method to save the person collection to a file

    func saveSettings(){
        let jsonEncoder = JSONEncoder()
        var jsonData = Data()
        
        do {
            jsonData = try jsonEncoder.encode(usersSettings)
        } catch {
            print("Failed to encode users settings")
        }
        
        do {
            try jsonData.write(to: storageurlSettings)
        } catch {
            print("Failed to write users settings to storage")
        }
        
    }
    
}
