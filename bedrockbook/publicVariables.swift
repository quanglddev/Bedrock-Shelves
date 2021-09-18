//
//  publicVariables.swift
//  bedrockbook
//
//  Created by Nguyenxloc on 7/6/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import FirebaseDatabase

let customColorWeb = "<font face='Avenir Next' size='4''>%@"


let apiKey = "AIzaSyDP2zX2okXCxN88zHtKlYceLFho3DjwpGY"
var inputBookID = ""
var ref: DatabaseReference!
var booksFromFirebase: [DataSnapshot]! = []




var userName: String!
var userUid: String!

let userDefaults = UserDefaults.standard

struct defaultsKeys {
    static let userName = "userName"
    static let userUid = "userUid"
}

