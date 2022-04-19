//
//  addMangaViewController.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-30.
//

import UIKit
import UniformTypeIdentifiers
import Foundation

class addMangaViewController: UIViewController, UIDocumentPickerDelegate {

    @IBOutlet var addMangaTap: UITapGestureRecognizer!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var selectMangaButton: UIButton!
    
    @IBOutlet weak var mangaImage: UIImageView!
    
    var mangaURL: URL? = nil
    var mangaPanels = [URL]()
    var mangaName: String? = nil
    var mangaPhoto: UIImage? = nil
    var thumbnail: UIImage? = nil
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.darkGray
        self.textField.backgroundColor = UIColor.gray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mangaImage.layer.borderWidth = 1.0
        mangaImage.layer.borderColor = UIColor.gray.cgColor
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            setBackgroundColor()
        }
        
    }
    
    //MARK: Document picker functions
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        mangaURL = url
        let keys : [URLResourceKey] = [.nameKey, .isDirectoryKey]
        do {
            var templist = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: keys)
            templist.sort(by: {$0.absoluteString < $1.absoluteString})
            thumbnail = UIImage(data: NSData(contentsOf: templist[0])! as Data)
            mangaImage.image = thumbnail
            mangaPhoto = thumbnail
            
            for (_, value) in templist.enumerated() {
                mangaPanels.append(value)
            }
        } catch{
            return
        }
        
    }

    @IBAction func addMangaViewTapped(_ sender: Any) {
        textField.resignFirstResponder()
    }
    
    
    @IBAction func selectMangaButtonClicked(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        mangaName = textField.text
        
        if (mangaURL == nil || mangaName == "") {
            let errorAlert = UIAlertController(title: "Error", message: "You must select a manga and name", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default)
            errorAlert.addAction(errorAction)
            present(errorAlert, animated: true, completion: nil)
            } else {
                let successAlert = UIAlertController(title: "Success", message: "\(String(describing: mangaName!)) has been added!", preferredStyle: .alert)
                let successAction = UIAlertAction(title: "Ok", style: .default, handler: {action in self.confirmComplete()})
                successAlert.addAction(successAction)
                
                let newManga = Manga(mangaPath: mangaURL!, name: mangaName!, photo: thumbnail!, mangaPanels: mangaPanels, currentPanel: 0, bookmarks: [])
                SharedManga.sharedManga.mangaList?.addManga(manga: newManga)
                
                present(successAlert, animated: true, completion: nil)
                
            }
    }
    
    func confirmComplete() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
