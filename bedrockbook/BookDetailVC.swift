//
//  BookDetailVC.swift
//  bedrockbook
//
//  Created by QUANG on 7/17/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit
import FloatRatingView
import SDWebImage
import FirebaseDatabase
import SCLAlertView
import Armchair


var newBorrow = false
var borrowID = ""

var newReturn = false
var returnID = ""

class BookDetailVC: UIViewController {
    
    //MARK: Variables
    var book: Book?
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var lblPageCount: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPublisher: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var viewContainImage: UIView!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var btnBorrowOutlet: UIButton!
    
    @IBOutlet weak var webDescription: UIWebView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //Change color
        DispatchQueue.main.async {
            
            self.viewContainImage.layer.borderColor = UIColor.black.cgColor
            self.viewContainImage.layer.borderWidth = 0.1
            self.viewContainImage.clipsToBounds = false
            self.viewContainImage.layer.shadowColor = UIColor.black.cgColor
            self.viewContainImage.layer.shadowOpacity = 1
            self.viewContainImage.layer.shadowOffset = CGSize.zero
            self.viewContainImage.layer.shadowRadius = 10
            self.viewContainImage.layer.shadowPath = UIBezierPath(roundedRect: self.viewContainImage.bounds, cornerRadius: 10).cgPath

            
            
            if self.book?.borrowID != "0" {
                if self.book?.borrowID == userName {
                    //Return enable
                    self.btnBorrowOutlet.isEnabled = true
                    self.btnBorrowOutlet.setTitle("Return", for: .normal)
                }
                else {
                    //Is borrowed by somebody
                    self.btnBorrowOutlet.isEnabled = false
                    self.btnBorrowOutlet.setTitle("Currently being borrowed by \(self.book?.borrowID ?? "")", for: .normal)
                    self.btnBorrowOutlet.setTitle("Currently being borrowed by \(self.book?.borrowID ?? "")", for: .disabled)
                    self.btnBorrowOutlet.setTitle("Currently being borrowed by \(self.book?.borrowID ?? "")", for: .application)
                    self.btnBorrowOutlet.setTitle("Currently being borrowed by \(self.book?.borrowID ?? "")", for: .focused)
                    self.btnBorrowOutlet.setTitle("Currently being borrowed by \(self.book?.borrowID ?? "")", for: .highlighted)


                }
            }
            else {
                //Return enable
                self.btnBorrowOutlet.isEnabled = true
                self.btnBorrowOutlet.setTitle("Borrow", for: .normal)
            }
        }
    

        if let book = book {
            if !book.title.isEmpty {
                navigationBar.topItem?.title = book.title
            }
            else {
                navigationBar.topItem?.title = "Untitled"
            }
            DispatchQueue.main.async {
                self.ratingView.rating = Float(book.averageRating)
            }
            lblPageCount.text = "Pages: \(book.pageCount)"
            if book.categories.count > 1 {
                let shortCat = [book.categories[0], book.categories[1]]
                lblCategory.text = "Categories: \(shortCat.joined(separator: ", "))"
            }
            lblCategory.text = "Categories: \(book.categories.joined(separator: ", "))"
            lblPublisher.text = "Publisher: \(book.publisher)"
            if book.authors.count > 0 {
                lblAuthor.text = "Main author: \(book.authors[0])"
            }
            else {
                lblAuthor.text = "Not Found"
            }
            bookImage.sd_setImage(with: book.imageLink, completed: nil)
            let valueToPassInWebview = String(format: customColorWeb, book.bookDescription)
            webDescription.loadHTMLString(valueToPassInWebview, baseURL: nil)
            
            print(book.bookDescription)
            
            lblAuthor.sizeToFit()
            lblPublisher.sizeToFit()
            lblCategory.sizeToFit()
        }
    }

    @IBAction func btnBorrow(_ sender: UIButton) {
        Armchair.userDidSignificantEvent(true)
        if book?.borrowID != "0" {
            if book?.borrowID == userName {
                //Return enable
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("I want to return") {
                    print("Returning")
                    
                    newReturn = true
                    returnID = (self.book?.ID)!
                    
                    ref = Database.database().reference()
                    
                    ref.child("books").child((self.book?.ID)!).child("borrowID").setValue("0")
                    ref.child("status").childByAutoId().child("text").setValue("\(userName!) has returned \(self.book?.title ?? "").")
                    
                    //Return enable
                    self.btnBorrowOutlet.isEnabled = true
                    self.btnBorrowOutlet.setTitle("Borrow", for: .normal)
                }
                alertView.addButton("No") {
                    print("Doing Nothing")
                }
                alertView.showInfo("Confirmation", subTitle: "Are you sure you want to return?")
            }
            else {
                //Is borrowed by somebody
                btnBorrowOutlet.isEnabled = false
                btnBorrowOutlet.setTitle("Currently being borrowed by \(book?.borrowID ?? "").", for: .normal)
            }
        }
        else {
            //Return enable
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertView = SCLAlertView(appearance: appearance)
            alertView.addButton("I want to borrow") {
                print("Borrowing")
                ref = Database.database().reference()
                
                ref.child("books").child((self.book?.ID)!).child("borrowID").setValue(userName)
                ref.child("status").childByAutoId().child("text").setValue("\(userName!) has borrowed \(self.book?.title ?? "")")
                
                newBorrow = true
                borrowID = (self.book?.ID)!
                
                //Return enable
                self.btnBorrowOutlet.isEnabled = true
                self.btnBorrowOutlet.setTitle("Return", for: .normal)
            }
            alertView.addButton("No") {
                print("Doing Nothing")
            }
            alertView.showSuccess("Confirmation", subTitle: "Are you sure you want to borrow?")
        }
    }
    
    @IBAction func btnReturn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
