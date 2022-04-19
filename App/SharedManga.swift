//
//  SharedManga.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-31.
//

import Foundation
import UIKit

class SharedManga {
    static let sharedManga = SharedManga()
    var mangaList: MangaList?
    
    var storageurl : URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL.appendingPathComponent("Storage.file")
    }
    
    
    
    // method to restore the person collection from a file

    func restoreMangaList(){
        let jsonDecoder = JSONDecoder()
        var data = Data()
        do {
            data = try Data(contentsOf: storageurl)
        } catch {
            print("Failed to restore Manga List")
        }
        
        do {
            mangaList = try jsonDecoder.decode(MangaList.self, from: data)
        } catch {
            print("Failed to load mangalist")
        }
        
    }

    // method to save the person collection to a file

    func saveMangaList(){
        let jsonEncoder = JSONEncoder()
        var jsonData = Data()
        
        do {
            jsonData = try jsonEncoder.encode(mangaList)
        } catch {
            print("Failed to encode manga list")
        }
        
        do {
            try jsonData.write(to: storageurl)
        } catch {
            print("Failed to write manga list to storage.json")
        }
        
    }
    
}
