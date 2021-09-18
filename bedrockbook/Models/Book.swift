//
//  Book.swift
//  bedrockbook
//
//  Created by Nguyenxloc on 7/6/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit

class Book: NSObject, NSCoding {
    
    struct PropertyKey {
        static let ID = "ID"
        static let title = "title"
        static let authors = "authors"
        static let publisher = "publisher"
        static let publishedDate = "publishedDate"
        static let bookDescription = "bookDescription"
        static let pageCount = "pageCount"
        static let mainCategory = "mainCategory"
        static let categories = "categories"
        static let averageRating = "averageRating"
        static let ratingsCount = "ratingsCount"
        static let thumbnailLink = "thumbnailLink"
        static let imageLink = "imageLink"
        static let language = "language"
        static let retailPrice = "retailPrice"
        static let currencyCode = "currencyCode"
        static let buyLink = "buyLink"
        static let borrowID = "borrowID"
    }
    
    
    //MARK: Variables
    var ID: String
    var title: String
    var authors: [String]
    var publisher: String
    var publishedDate: String
    var bookDescription: String
    var pageCount: Int
    var mainCategory: String
    var categories: [String]
    var averageRating: Double
    var ratingsCount: Int
    var thumbnailLink: URL
    var imageLink: URL
    var language: String
    var retailPrice: Double
    var currencyCode: String
    var buyLink: URL
    var borrowID: String
    
    //MARK: Initializers
    init(ID: String, title: String, authors: [String], publisher: String, publishedDate: String, bookDescription: String, pageCount: Int, mainCategory: String, categories: [String], averageRating: Double, ratingsCount: Int, thumbnailLink: URL, imageLink: URL, language: String, retailPrice: Double, currencyCode: String, buyLink: URL, borrowID: String) {
        self.ID = ID
        self.title = title
        self.authors = authors
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.bookDescription = bookDescription
        self.pageCount = pageCount
        self.mainCategory = mainCategory
        self.categories = categories
        self.averageRating = averageRating
        self.ratingsCount = ratingsCount
        self.thumbnailLink = thumbnailLink
        self.imageLink = imageLink
        self.language = language
        self.retailPrice = retailPrice
        self.currencyCode = currencyCode
        self.buyLink = buyLink
        self.borrowID = borrowID
    }
    
    
    //Mark: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(ID,forKey:PropertyKey.ID)
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(authors, forKey : PropertyKey.authors)
        aCoder.encode(publisher, forKey : PropertyKey.publisher)
        aCoder.encode(publishedDate, forKey : PropertyKey.publishedDate)
        aCoder.encode(bookDescription, forKey : PropertyKey.bookDescription)
        aCoder.encode(pageCount, forKey : PropertyKey.pageCount)
        aCoder.encode(mainCategory, forKey : PropertyKey.mainCategory)
        aCoder.encode(categories, forKey : PropertyKey.categories)
        aCoder.encode(averageRating, forKey : PropertyKey.averageRating)
        aCoder.encode(ratingsCount, forKey : PropertyKey.ratingsCount)
        aCoder.encode(thumbnailLink, forKey : PropertyKey.thumbnailLink)
        aCoder.encode(imageLink, forKey : PropertyKey.imageLink)
        aCoder.encode(language, forKey : PropertyKey.language)
        aCoder.encode(retailPrice, forKey : PropertyKey.retailPrice)
        aCoder.encode(currencyCode, forKey : PropertyKey.currencyCode)
        aCoder.encode(buyLink, forKey : PropertyKey.buyLink)
        aCoder.encode(borrowID, forKey : PropertyKey.borrowID)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let ID = aDecoder.decodeObject(forKey: PropertyKey.ID) as? String else { print("error 1") ;return nil }
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String else { print("error 2") ;return nil }
        guard let authors = aDecoder.decodeObject(forKey: PropertyKey.authors) as? [String] else { print("error 3") ;return nil }
        guard let publisher = aDecoder.decodeObject(forKey: PropertyKey.publisher) as? String else { print("error 4") ;return nil }
        guard let publishedDate = aDecoder.decodeObject(forKey: PropertyKey.publishedDate) as? String else {print("error 5") ; return nil }
        guard let bookDescription = aDecoder.decodeObject(forKey: PropertyKey.bookDescription) as? String else {
            print("error 6")
            return nil
            
        }
        let pageCount = aDecoder.decodeInteger(forKey: PropertyKey.pageCount)
        guard let mainCategory = aDecoder.decodeObject(forKey: PropertyKey.mainCategory) as? String else { print("error 7") ;return nil }
        guard let categories = aDecoder.decodeObject(forKey: PropertyKey.categories) as? [String] else { print("error 8") ;return nil }
        let averageRating = aDecoder.decodeDouble(forKey: PropertyKey.averageRating)
        let ratingsCount = aDecoder.decodeInteger(forKey: PropertyKey.ratingsCount)
        guard let thumbnailLink = aDecoder.decodeObject(forKey: PropertyKey.thumbnailLink) as? URL else { print("error 10") ;return nil }
        guard let imageLink = aDecoder.decodeObject(forKey: PropertyKey.imageLink) as? URL else { print("error 11") ;return nil }
        guard let language = aDecoder.decodeObject(forKey: PropertyKey.language) as? String else { print("error 12") ;return nil }
        let retailPrice = aDecoder.decodeDouble(forKey: PropertyKey.retailPrice)
        guard let currencyCode = aDecoder.decodeObject(forKey: PropertyKey.currencyCode) as? String else { print("error 13") ;return nil }
        guard let buyLink = aDecoder.decodeObject(forKey: PropertyKey.buyLink) as? URL else { print("error 14") ;return nil }
        guard let borrowID = aDecoder.decodeObject(forKey: PropertyKey.borrowID) as? String else { print("error 15") ;return nil }

        
        self.init(ID:ID , title:title , authors:authors , publisher:publisher , publishedDate:publishedDate , bookDescription:bookDescription , pageCount: pageCount , mainCategory:mainCategory , categories:categories , averageRating: averageRating , ratingsCount:ratingsCount, thumbnailLink: thumbnailLink, imageLink: imageLink , language:language, retailPrice: retailPrice, currencyCode: currencyCode, buyLink: buyLink, borrowID: borrowID)
    }
}
