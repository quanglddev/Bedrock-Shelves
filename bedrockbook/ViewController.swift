//
//  ViewController.swift
//  bedrockbook
//
//  Created by Nguyenxloc on 6/30/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SwiftyJSON
import FirebaseDatabase
import FBSDKLoginKit
import SCLAlertView

class ViewController: UIViewController {
    
    //Mark Variables
    var books = [Book]()
    var myCollection = [Book]()
    
    var isAdding = false
    
    var isMyCollection = false
    
    var searchedBooks = [Book]()
    
    //MARK: Outlets (outlets la cac cai IBOutlet nay)
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var bookCountOutlet: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLogoutOutlet: UIBarButtonItem!
    @IBOutlet weak var btnMyCollectionOutlet: UIBarButtonItem!
    
    
    //Implement Search bar
    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Actions
    override func viewDidAppear(_ animated: Bool) {
                
        checkBorrowReturn()

        self.booksCollectionView.reloadData()
        if isMyCollection {
            bookCountOutlet.title = "Book Count: \(myCollection.count)"
            
        }
        else {
            bookCountOutlet.title = "Book Count: \(books.count)"
            
        }
    }
    
    // Mark : Default
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books..."
        searchController.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {

            let scb = searchController.searchBar
            scb.tintColor = UIColor.white
            scb.barTintColor = UIColor.white
            
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }

            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        else {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search Books...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            searchController.searchBar.setImage(UIImage(named: "my_search_icon"), for: UISearchBarIcon.clear, state: .normal)
            searchController.searchBar.setImage(UIImage(named: "my_search_icon"), for: UISearchBarIcon.search, state: .normal)
            searchController.searchBar.tintColor = .white
        }

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true


        //UI
        booksCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        booksCollectionView.backgroundColor = UIColor.white
        
        //getAvailableBooksFromFirebase()

        self.autoUpdateAddedBook()
        
        updateUserInfo()
        
        //Implement delete
        navigationItem.leftBarButtonItems = [btnLogoutOutlet, btnMyCollectionOutlet]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    deinit {
        ref.child("books").removeAllObservers()
    }

    
    //Bar Button
    @IBAction func btnLogout(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("I want to log out") {
            print("Logging out")
            
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            userDefaults.set("", forKey: defaultsKeys.userName)
            userDefaults.set("", forKey: defaultsKeys.userUid)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! UINavigationController
            self.present(newViewController, animated: true, completion: nil)
        }
        alertView.addButton("No") {
            print("Doing Nothing")
        }
        alertView.showError("Confirmation", subTitle: "Are you sure you want to log out?")
    }

    
    @IBAction func btnMyCollection(_ sender: UIBarButtonItem) {
        myCollection.removeAll()
        if !isMyCollection {
            //Open collection
            isMyCollection = true
            sender.image = #imageLiteral(resourceName: "icons8-book-shelf-64")
            for book in books {
                if book.borrowID == userName {
                    myCollection.append(book)
                }
            }
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.isEnabled = false
            }
        }
        else {
            //Open Shelves
            isMyCollection = false
            sender.image = #imageLiteral(resourceName: "icons8-user-64")
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.isEnabled = true
            }
        }
        
        
        self.booksCollectionView.reloadData()
        if isMyCollection {
            bookCountOutlet.title = "Book Count: \(myCollection.count)"
            
        }
        else {
            bookCountOutlet.title = "Book Count: \(books.count)"
            
        }
    }
}


extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "Title") {
        searchedBooks = books.filter({( book : Book) -> Bool in
            return book.title.lowercased().contains(searchText.lowercased()) || book.authors.map {$0.lowercased()}.superContains(string: searchText.lowercased())
        })
        
        
        booksCollectionView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}


extension ViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension Array {
    func superContains(string: String) -> Bool {
        if self.first is String {
            let strArray = self.map { $0 as! String }

            for input in strArray {
                if input.contains(string) {
                    return true
                }
            }
        }
        return false
    }
}
