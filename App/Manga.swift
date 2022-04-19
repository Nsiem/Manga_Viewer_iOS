//
//  Manga.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-30.
//

import Foundation
import UIKit

class Manga: Codable {
    
    var mangaPath: URL
    var name: String
    var photo: UIImage
    var mangaPanels = [URL]()
    var currentPanel: Int
    var bookmarks = [Int]()
    
    init(mangaPath: URL, name: String, photo: UIImage, mangaPanels: [URL], currentPanel: Int, bookmarks: [Int]){
        self.mangaPath = mangaPath
        self.name = name
        self.photo = photo
        self.mangaPanels = mangaPanels
        self.currentPanel = currentPanel
        self.bookmarks = bookmarks
    }
    
    func getName()  -> String {
        return self.name
    }
    
    func getPhoto() -> UIImage {
        return self.photo
    }
    
    func getBookmarks() -> [Int] {
        return self.bookmarks
    }
    
    func getCurrent() -> Int {
        return self.currentPanel
    }
    
    func setCurrent(newCurrent: Int) {
        self.currentPanel = newCurrent
    }
    
    func getPanel() -> UIImage {
        if currentPanel < mangaPanels.count {
            let mangaPanel = UIImage(data: NSData(contentsOf: self.mangaPanels[currentPanel])! as Data)
            return mangaPanel!
        } else {
            let mangaPanel = UIImage(data: NSData(contentsOf: self.mangaPanels[0])! as Data)
            return mangaPanel!
        }
    }
    
    func getPanelBookmark(bookmarkPanel: Int) -> UIImage {
        return UIImage(data: NSData(contentsOf: self.mangaPanels[bookmarkPanel])! as Data)!
    }
    
    func getNextPanel() -> UIImage {
        self.currentPanel += 1
        
        if currentPanel < mangaPanels.count {
            let mangaPanel = UIImage(data: NSData(contentsOf: self.mangaPanels[currentPanel])! as Data)
            return mangaPanel!
        } else {
            let mangaPanel = UIImage(data: NSData(contentsOf: self.mangaPanels[0])! as Data)
            self.currentPanel = 0
            return mangaPanel!
        }
    }
    
    func getPrevPanel() -> UIImage {
        self.currentPanel -= 1
        
        if currentPanel <= 0 {
            self.currentPanel = 0
            return UIImage(data: NSData(contentsOf: self.mangaPanels[0])! as Data)!
        } else {
            let mangaPanel = UIImage(data: NSData(contentsOf: self.mangaPanels[currentPanel])! as Data)
            return mangaPanel!
        }
    }
    
    func getAmountRead() -> Int {
        let amountRead = Int(Float(currentPanel) / Float(mangaPanels.count) * 100)
        return amountRead
    }
    
    func addBookmark(panel: Int) {
        self.bookmarks.append(panel)
    }
    
    func deleteBookmark(bookmark: Int) {
        self.bookmarks.remove(at: bookmark)
    }

    
    
    public enum CodingKeys: String, CodingKey {
        case mangaPath
        case name
        case photo
        case mangaPanels
        case currentPanel
        case bookmarks
    }

   

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let imageData = try container.decode(Data.self, forKey: .photo)

        self.photo = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? UIImage)!

        
        let nameData = try container.decode(Data.self, forKey: .name)

        self.name = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(nameData) as? String ?? "no name"

        
        let mangaPathData = try container.decode(Data.self, forKey: .mangaPath)

        self.mangaPath = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mangaPathData) as? URL)!
        
        
        let mangaPanelsData = try container.decode(Data.self, forKey: .mangaPanels)
        
        self.mangaPanels = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mangaPanelsData) as? [URL])!
        
        
        let currentPanelData = try container.decode(Data.self, forKey: .currentPanel)
        
        self.currentPanel = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(currentPanelData) as? Int)!
        
        
        let bookmarksData = try container.decode(Data.self, forKey: .bookmarks)
        
        self.bookmarks = try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(bookmarksData) as? [Int])!

    } // decoder

   

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

       

        let imageData = try NSKeyedArchiver.archivedData(withRootObject: photo, requiringSecureCoding: true)

        try container.encode(imageData, forKey: .photo)

       

        let nameData = try NSKeyedArchiver.archivedData(withRootObject: name, requiringSecureCoding: true)

        try container.encode(nameData, forKey: .name)

       

        let mangaPathData = try NSKeyedArchiver.archivedData(withRootObject: mangaPath, requiringSecureCoding: true)

        try container.encode(mangaPathData, forKey: .mangaPath)
        
        
        let mangaPanelsData = try NSKeyedArchiver.archivedData(withRootObject: mangaPanels, requiringSecureCoding: true)

        try container.encode(mangaPanelsData, forKey: .mangaPanels)

        
        let currentPanel = try NSKeyedArchiver.archivedData(withRootObject: currentPanel, requiringSecureCoding: true)

        try container.encode(currentPanel, forKey: .currentPanel)
        
        
        let bookmarksData = try NSKeyedArchiver.archivedData(withRootObject: bookmarks, requiringSecureCoding: true)

        try container.encode(bookmarksData, forKey: .bookmarks)
       

    }
    
}

