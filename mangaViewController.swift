//
//  mangaViewController.swift
//  kech8960_Final
//
//  Created by Antony Kechichian on 2022-03-30.
//

import UIKit

class mangaViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var viewTitle: UINavigationItem!
    
    @IBOutlet weak var mangaImage: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    private var manga: Manga?
    
    private var invertedSwipe = false
    
    // function to receive data
    func initWithManga(manga: Manga){
        self.manga = manga
    }
    
    func setBackgroundColor() {
        self.view.backgroundColor = UIColor.darkGray
        scrollView.backgroundColor = UIColor.darkGray
        backgroundView.backgroundColor = UIColor.darkGray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.5
        
        viewTitle.title = manga?.getName()
    
        mangaImage.image = manga?.getPanel()
        mangaImage.isUserInteractionEnabled = true
        let theProgress = (Float((self.manga?.getAmountRead())!) / 100)
        progressBar.progress = theProgress
        
        if(SharedSettings.sharedsettings.usersSettings?.darkmode == true) {
            setBackgroundColor()
        }
        
        if(SharedSettings.sharedsettings.usersSettings?.invertSwipe == true) {
            invertedSwipe = true
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return mangaImage
    }
    
    
    @IBAction func swipedRight(_ sender: Any) {
        if(invertedSwipe) {
            UIView.transition(with: self.mangaImage,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                                      animations: {
                self.mangaImage.image = self.manga?.getPrevPanel()
                    }, completion: nil)
        } else {
            UIView.transition(with: self.mangaImage,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                                      animations: {
                self.mangaImage.image = self.manga?.getNextPanel()
                    }, completion: nil)
        }
        
        
        let theProgress = (Float((self.manga?.getAmountRead())!) / 100)
        progressBar.progress = theProgress
    }
    
    
    @IBAction func swipedLeft(_ sender: Any) {
        if(invertedSwipe) {
            UIView.transition(with: self.mangaImage,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                                      animations: {
                self.mangaImage.image = self.manga?.getNextPanel()
                    }, completion: nil)
        } else {
            UIView.transition(with: self.mangaImage,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                                      animations: {
                self.mangaImage.image = self.manga?.getPrevPanel()
                    }, completion: nil)
        }
        
        let theProgress = (Float((self.manga?.getAmountRead())!) / 100)
        progressBar.progress = theProgress
    }

    @IBAction func bookmarkTap(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to bookmark this panel?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: {action in self.confirmComplete()})
        let denyAction = UIAlertAction(title: "No", style: .destructive)
        
        confirmAlert.addAction(confirmAction)
        confirmAlert.addAction(denyAction)
    
        present(confirmAlert, animated: true, completion: nil)
    }
    
    func confirmComplete() {
        let currentPanel = manga?.getCurrent()
        manga?.addBookmark(panel: currentPanel!)
        
        let successAlert = UIAlertController(title: "Success", message: "Bookmark has been added!", preferredStyle: .alert)
        let successAction = UIAlertAction(title: "Ok", style: .default)
        successAlert.addAction(successAction)
        
        present(successAlert, animated: true, completion: nil)
    }
}
