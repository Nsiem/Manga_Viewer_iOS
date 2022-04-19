//
//  MangaList.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-31.
//

import Foundation
import UIKit

class MangaList: Codable {
    var mangas = [Manga]()
    
    func addManga(manga: Manga) {
        self.mangas.append(manga)
    }
    
    func getNumberofManga() -> Int {
        return self.mangas.count
    }
    
    func deleteManga(manga: Int) {
        self.mangas.remove(at: manga)
    }
    
}
