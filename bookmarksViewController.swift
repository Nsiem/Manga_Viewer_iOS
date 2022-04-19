//
//  ViewController.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-30.
//

import UIKit

let simpleTableIDBookmarks = "reusableCellBookmarks"

class tableViewCellBookmarks: UITableViewCell {
    
    @IBOutlet weak var cellImageBookmarks: UIImageView!
    
    @IBOutlet weak var cellLabelBookmarks: UILabel!
    
}

class bookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mangaViewSegue = "mangaViewSegueFromBookmarks"
    let unwind = "unwindAfterDelete"
    
    @IBOutlet weak var bookmarksTable: UITableView!
    
    private var manga: Manga?
    private var mangaBookmarks = [Int]()
    private var count = 1
    
    
    // function to receive data
    func initWithMangaBookmarks(manga: Manga){
        self.manga = manga
        self.mangaBookmarks = manga.getBookmarks()
    }
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.darkGray
        bookmarksTable.backgroundColor = UIColor.darkGray
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarksTable.delegate = self
        bookmarksTable.dataSource = self
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            setBackgroundColor()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaBookmarks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var reusedCellBookmarks = tableView.dequeueReusableCell(withIdentifier: simpleTableIDBookmarks, for: indexPath) as? tableViewCellBookmarks
        if(reusedCellBookmarks == nil) {
            reusedCellBookmarks = tableViewCellBookmarks(style: UITableViewCell.CellStyle.default, reuseIdentifier: simpleTableIDBookmarks)
        }
        
        reusedCellBookmarks?.layer.masksToBounds = true
        reusedCellBookmarks?.layer.borderWidth = 0.5
        reusedCellBookmarks?.layer.borderColor = UIColor.lightGray.cgColor
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            reusedCellBookmarks?.backgroundColor = UIColor.darkGray
            reusedCellBookmarks?.contentView.backgroundColor = UIColor.darkGray
        }
        
        reusedCellBookmarks?.cellImageBookmarks.image = self.manga?.getPanelBookmark(bookmarkPanel: self.mangaBookmarks[indexPath.row])
        reusedCellBookmarks?.cellLabelBookmarks.text = "\(self.manga!.getName()) bookmark \(self.count)"
        
        self.count += 1
        
        return reusedCellBookmarks!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            self.manga?.deleteBookmark(bookmark: indexPath.row)
            self.performSegue(withIdentifier: self.unwind, sender: nil)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.manga?.setCurrent(newCurrent: self.mangaBookmarks[indexPath.row])
        performSegue(withIdentifier: mangaViewSegue, sender: self.manga)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is mangaViewController {
            let mangaViewC = segue.destination as? mangaViewController

            mangaViewC?.initWithManga(manga: sender as! Manga)
        }
    }

}

