//
//  Firebase_Helper.swift
//  bedrockbook
//
//  Created by QUANG on 7/24/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import FirebaseDatabase

extension ViewController {

    func pushBooksToDatabase() {
        ref = Database.database().reference()
        
        let book = books[books.count - 1]
        
        let uuid = book.ID
        
        self.booksCollectionView.reloadData()
        if isMyCollection {
            bookCountOutlet.title = "Book Count: \(myCollection.count)"

        }
        else {
            bookCountOutlet.title = "Book Count: \(books.count)"

        }

        ref.child("books").child(uuid).child("ID").setValue(book.ID)
        ref.child("books").child(uuid).child("title").setValue(book.title)
        ref.child("books").child(uuid).child("authors").setValue(book.authors.joined(separator: ", "))
        ref.child("books").child(uuid).child("publisher").setValue(book.publisher)
        ref.child("books").child(uuid).child("publishedDate").setValue(book.publishedDate)
        ref.child("books").child(uuid).child("bookDescription").setValue(book.bookDescription)
        ref.child("books").child(uuid).child("pageCount").setValue("\(book.pageCount)")
        ref.child("books").child(uuid).child("mainCategory").setValue(book.mainCategory)
        ref.child("books").child(uuid).child("categories").setValue(book.categories.joined(separator: ", "))
        ref.child("books").child(uuid).child("averageRating").setValue("\(book.averageRating)")
        ref.child("books").child(uuid).child("ratingsCount").setValue("\(book.ratingsCount)")
        ref.child("books").child(uuid).child("thumbnailLink").setValue(book.thumbnailLink.absoluteString)
        ref.child("books").child(uuid).child("imageLink").setValue(book.imageLink.absoluteString)
        ref.child("books").child(uuid).child("language").setValue(book.language)
        ref.child("books").child(uuid).child("retailPrice").setValue("\(book.retailPrice)")
        ref.child("books").child(uuid).child("currencyCode").setValue("\(book.currencyCode)")
        ref.child("books").child(uuid).child("buyLink").setValue(book.buyLink.absoluteString)
        
        self.booksCollectionView.reloadData()
        if isMyCollection {
            bookCountOutlet.title = "Book Count: \(myCollection.count)"
            
        }
        else {
            bookCountOutlet.title = "Book Count: \(books.count)"
            
        }
    }
    
    func updateUserInfo() {
        if let uid = userDefaults.string(forKey: defaultsKeys.userUid), !uid.isEmpty {
            if let name = userDefaults.string(forKey: defaultsKeys.userName), !name.isEmpty {
                ref = Database.database().reference()
                
                print(uid)
                print(name)
                
                userUid = uid
                userName = name
                ref.child("users").child(userUid!).child("uid").setValue(uid)
                ref.child("users").child(userUid!).child("name").setValue(name)
            }
        }
    }
    
    /*
    func getAvailableBooksFromFirebase() {
        //Clear all rooms which saved locally
        self.books.removeAll()
        print(self.books.count)
        
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value) { (rootSnapshot) in
            if rootSnapshot.children.allObjects.count > 0 {
                if let booksRef = rootSnapshot.children.allObjects[0] as? DataSnapshot { //This is books ref
                    for book in booksRef.children.allObjects as! [DataSnapshot] {
                        let value = book.value as? NSDictionary
                        let id = value?["ID"] as? String ?? ""
                        let title = value?["title"] as? String ?? ""
                        let authors = value?["authors"] as? String ?? ""
                        let publisher = value?["publisher"] as? String ?? ""
                        let publishedDate = value?["publishedDate"] as? String ?? ""
                        let bookDescription = value?["bookDescription"] as? String ?? ""
                        let pageCount = value?["pageCount"] as? Int ?? 0
                        let mainCategory = value?["mainCategory"] as? String ?? ""
                        let categories = value?["categories"] as? String ?? ""
                        let averageRating = value?["averageRating"] as? Double ?? 0.0
                        let ratingsCount = value?["ratingsCount"] as? Int ?? 0
                        let thumbnailLink = value?["thumbnailLink"] as? String ?? "https://google.com"
                        let imageLink = value?["imageLink"] as? String ?? "https://google.com"
                        let language = value?["language"] as? String ?? ""
                        let retailPrice = value?["retailPrice"] as? Double ?? 0.0
                        let currencyCode = value?["currencyCode"] as? String ?? ""
                        let buyLink = value?["buyLink"] as? String ?? "https://google.com"
                        
                        let newBook = Book(ID: id, title: title, authors: authors.components(separatedBy: ", "), publisher: publisher, publishedDate: publishedDate, bookDescription: bookDescription, pageCount: pageCount, mainCategory: mainCategory, categories: categories.components(separatedBy: ", "), averageRating: averageRating, ratingsCount: ratingsCount, thumbnailLink: URL(string: thumbnailLink)!, imageLink: URL(string: imageLink)!, language: language, retailPrice: retailPrice, currencyCode: currencyCode, buyLink: URL(string: buyLink)!)
                        
                        self.books.append(newBook)
                        
                        print(self.books.count)
                        print(booksRef.children.allObjects.count)
                        
                        if self.books.count == booksRef.children.allObjects.count {
                            self.booksCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }*/
    
    func autoUpdateAddedBook() {
        
        Database.database().reference().child("books").observe(.childAdded) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let id = value?["ID"] as? String ?? ""
            let title = value?["title"] as? String ?? ""
            let authors = value?["authors"] as? String ?? ""
            let publisher = value?["publisher"] as? String ?? ""
            let publishedDate = value?["publishedDate"] as? String ?? ""
            let bookDescription = value?["bookDescription"] as? String ?? ""
            let pageCount = value?["pageCount"] as? Int ?? 0
            let mainCategory = value?["mainCategory"] as? String ?? ""
            let categories = value?["categories"] as? String ?? ""
            let averageRating = value?["averageRating"] as? Double ?? 0.0
            let ratingsCount = value?["ratingsCount"] as? Int ?? 0
            let thumbnailLink = value?["thumbnailLink"] as? String ?? "https://google.com"
            let imageLink = value?["imageLink"] as? String ?? "https://google.com"
            let language = value?["language"] as? String ?? ""
            let retailPrice = value?["retailPrice"] as? Double ?? 0.0
            let currencyCode = value?["currencyCode"] as? String ?? ""
            let buyLink = value?["buyLink"] as? String ?? "https://google.com"
            let borrowID = value?["borrowID"] as? String ?? "0"
            
            let newBook = Book(ID: id, title: title, authors: authors.components(separatedBy: ", "), publisher: publisher, publishedDate: publishedDate, bookDescription: bookDescription, pageCount: pageCount, mainCategory: mainCategory, categories: categories.components(separatedBy: ", "), averageRating: averageRating, ratingsCount: ratingsCount, thumbnailLink: URL(string: thumbnailLink)!, imageLink: URL(string: imageLink)!, language: language, retailPrice: retailPrice, currencyCode: currencyCode, buyLink: URL(string: buyLink)!, borrowID: borrowID)
            
            print(self.books.count)
            if !self.isAdding {
                self.books.append(newBook)
            }
            else {
                self.isAdding = !self.isAdding
            }
            print(self.books.count)
            
            //swift 3
            DispatchQueue.main.async{
                self.booksCollectionView.reloadData()

                if self.isMyCollection {
                    self.bookCountOutlet.title = "Book Count: \(self.myCollection.count)"
                    
                }
                else {
                    self.bookCountOutlet.title = "Book Count: \(self.books.count)"
                    
                }
            }
        }
    }
}



extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}

struct Post : Hashable {
    var id : Int
    var hashValue : Int { return self.id }
}

func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.id == rhs.id
}

