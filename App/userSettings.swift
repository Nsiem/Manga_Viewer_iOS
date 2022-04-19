//
//  userSettings.swift
//  kech8960_FinalProject
//
//  Created by Antony Kechichian on 2022-04-09.
//

import Foundation
import UIKit

class userSettings: Codable {
    var darkmode: Bool?
    var invertSwipe: Bool?
    
    init(darkmode: Bool, invertSwipe: Bool) {
        self.darkmode = darkmode
        self.invertSwipe = invertSwipe
    }
    
    public enum CodingKeys: String, CodingKey {
        case invertSwipe
        case darkmode
        
    }

   

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let darkmodeOption = try container.decode(Data.self, forKey: .darkmode)
        
        self.darkmode = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(darkmodeOption) as? Bool)!
        
        let invertOption = try container.decode(Data.self, forKey: .invertSwipe)
        
        self.invertSwipe = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(invertOption) as? Bool)!

    } // decoder

   

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let darkmodeOption = try NSKeyedArchiver.archivedData(withRootObject: darkmode! as Bool, requiringSecureCoding: true)

        try container.encode(darkmodeOption, forKey: .darkmode)
        
        let invertOption = try NSKeyedArchiver.archivedData(withRootObject: invertSwipe! as Bool, requiringSecureCoding: true)

        try container.encode(invertOption, forKey: .invertSwipe)
       

    }
    
}
