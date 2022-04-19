//
//  ViewController.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-30.
//

import UIKit

let simpleTableID = "reusableCell"

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var cellProgress: UILabel!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var optionsButton: UIBarButtonItem!
    @IBOutlet weak var theTable: UITableView!
    
    let addMangaSegue = "addMangaSegue"
    let mangaViewSegue = "mangaViewSegue"
    let bookmarksSegue = "bookmarksSegue"
    
    func optionMenuCreate() -> UIMenu {
        
        let addMangaItem = UIAction(title: "Add Manga", image: UIImage(systemName: "plus")) { (action) in
            self.addMangaOptionClicked()
                    }
        
        let addMangaOption = UIMenu(title: "", options: .displayInline, children: [addMangaItem])
        
        
        let sortAlphaUp = UIAction(title: "Sort Alphabetically", image: UIImage(systemName: "chevron.compact.up")) { (action) in
            self.sortAlpha(direction: 0)
            }
        let sortAlphaDown = UIAction(title: "Sort Alphabetically", image: UIImage(systemName: "chevron.compact.down")) { (action) in
            self.sortAlpha(direction: 1)
            }
        let sortNumUp =  UIAction(title: "Sort by progress", image: UIImage(systemName: "chevron.compact.up")) { (action) in
            self.sortProgress(direction: 0)
            }
        let sortNumDown = UIAction(title: "Sort by progress", image: UIImage(systemName: "chevron.compact.down")) { (action) in
            self.sortProgress(direction: 1)
            }

        
        let sortMenu = UIMenu(title: "", options: .displayInline, children: [sortAlphaUp, sortAlphaDown, sortNumUp, sortNumDown])
        
        let optionMenu = UIMenu(title: "Options Menu", image: nil, identifier: nil, options: [], children: [addMangaOption, sortMenu])
        
        return optionMenu
    }
    
    func sortAlpha(direction: Int) {
        if direction == 0 {
            SharedManga.sharedManga.mangaList?.mangas.sort(by: {$0.getName() < $1.getName()})
        } else {
            SharedManga.sharedManga.mangaList?.mangas.sort(by: {$0.getName() > $1.getName()})
        }
        self.theTable.reloadData()
    }
    
    func sortProgress(direction: Int) {
        if direction == 0 {
            SharedManga.sharedManga.mangaList?.mangas.sort(by: {$0.getAmountRead() < $1.getAmountRead()})
        } else {
            SharedManga.sharedManga.mangaList?.mangas.sort(by: {$0.getAmountRead() > $1.getAmountRead()})
        }
        self.theTable.reloadData()
    }
    
    
    func addMangaOptionClicked() {
        performSegue(withIdentifier: addMangaSegue, sender: nil)
    }
    
    func settingMenuCreate() -> UIMenu {

        let invertSwipe = UIAction(title: "Invert swipe direction", image: UIImage(systemName: "rectangle.and.hand.point.up.left"), state: .off) { (action) in
            if SharedSettings.sharedsettings.usersSettings?.invertSwipe == true {
                SharedSettings.sharedsettings.usersSettings?.invertSwipe = false
            } else {
                SharedSettings.sharedsettings.usersSettings?.invertSwipe = true
            }
            self.refreshMenu()
        }
        if SharedSettings.sharedsettings.usersSettings?.invertSwipe == true {
            invertSwipe.state = .on
        } else {
            invertSwipe.state = .off
        }
        
        let darkmode = UIAction(title: "Dark Mode", image: UIImage(systemName: "moon"), state: .off) { (action) in
            if SharedSettings.sharedsettings.usersSettings?.darkmode == true {
                SharedSettings.sharedsettings.usersSettings?.darkmode = false
            } else {
                SharedSettings.sharedsettings.usersSettings?.darkmode = true
            }
            self.refreshMenu()
        }
        if SharedSettings.sharedsettings.usersSettings?.darkmode == true {
            darkmode.state = .on
        } else {
            darkmode.state = .off
        }

        let settingsMenu = UIMenu(title: "Settings Menu", children: [invertSwipe, darkmode])

        return settingsMenu
    }
    
    func refreshMenu() {
        let settingMenu = settingMenuCreate()
        settingsButton.menu = settingMenu
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            setBackgroundColor(dark: true)
        } else {
            setBackgroundColor(dark: false)
        }
        
    }
    
    func setBackgroundColor(dark: Bool) {
        if dark == true {
            self.view.backgroundColor = UIColor.darkGray
            self.theTable.backgroundColor = UIColor.darkGray
        } else {
            self.view.backgroundColor = UIColor.systemBackground
            self.theTable.backgroundColor = UIColor.systemBackground
        }
        self.theTable.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = SharedManga()
        
        SharedManga.sharedManga.mangaList = MangaList()
        
        SharedManga.sharedManga.restoreMangaList()
        
        _ = SharedSettings()
        
        SharedSettings.sharedsettings.usersSettings = userSettings(darkmode: false, invertSwipe: false)
        
        SharedSettings.sharedsettings.restoreSettings()

        let optionsMenu = optionMenuCreate()
        optionsButton.menu = optionsMenu
        
        let settingMenu = settingMenuCreate()
        settingsButton.menu = settingMenu
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            setBackgroundColor(dark: true)
        }

        
        theTable.delegate = self
        theTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.theTable.reloadData()
        
    }
    
    //MARK: table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (SharedManga.sharedManga.mangaList?.getNumberofManga())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var reusedCell = tableView.dequeueReusableCell(withIdentifier: simpleTableID, for: indexPath) as? tableViewCell
        if(reusedCell == nil) {
            reusedCell = tableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: simpleTableID)
        }
        
        reusedCell?.layer.masksToBounds = true
        reusedCell?.layer.borderWidth = 0.5
        reusedCell?.layer.borderColor = UIColor.lightGray.cgColor
        
        if (SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            reusedCell?.backgroundColor = UIColor.darkGray
            reusedCell?.contentView.backgroundColor = UIColor.darkGray
            reusedCell?.cellProgress.textColor = UIColor.black
        } else {
            reusedCell?.backgroundColor = UIColor.systemBackground
            reusedCell?.contentView.backgroundColor = UIColor.systemBackground
            reusedCell?.cellProgress.textColor = UIColor.gray
        }
        
        reusedCell?.cellImageView.image = SharedManga.sharedManga.mangaList?.mangas[indexPath.row].getPhoto()
        reusedCell?.cellLabel.text = SharedManga.sharedManga.mangaList?.mangas[indexPath.row].getName()
        reusedCell?.cellProgress.text = "\( SharedManga.sharedManga.mangaList!.mangas[indexPath.row].getAmountRead())%"
        
        return reusedCell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let bookmarksAction = UIContextualAction(style: .normal, title: "Bookmarks") { [self]
            (action, sourceView, completionHandler) in
            //CHANGE TABLE DATA TO MANGA THINGY
            performSegue(withIdentifier: bookmarksSegue, sender: SharedManga.sharedManga.mangaList?.mangas[indexPath.row])
            
            completionHandler(true)
        }
        bookmarksAction.image = UIImage(systemName: "bookmark")
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
           
            SharedManga.sharedManga.mangaList!.deleteManga(manga: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, bookmarksAction])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: mangaViewSegue, sender: SharedManga.sharedManga.mangaList?.mangas[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is mangaViewController {
            let mangaViewC = segue.destination as? mangaViewController

            mangaViewC?.initWithManga(manga: sender as! Manga)
        } else if segue.destination is bookmarksViewController {
            let settingViewC = segue.destination as? bookmarksViewController
            
            settingViewC?.initWithMangaBookmarks(manga: sender as! Manga)
            
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
    }

}

