//
//  BorrowReturn_Helper.swift
//  bedrockbook
//
//  Created by QUANG on 7/27/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit

extension ViewController {
    func checkBorrowReturn() {
        //Check new borring and returning
        if newBorrow {
            newBorrow = !newBorrow
            for book in books {
                if book.ID == borrowID {
                    book.borrowID = userName
                }
            }
            for book in myCollection {
                if book.ID == borrowID {
                    book.borrowID = userName
                }
            }
        }
        
        if newReturn {
            newReturn = !newReturn
            for book in books {
                if book.ID == returnID {
                    book.borrowID = "0"
                }
            }
            for book in myCollection {
                if book.ID == returnID {
                    book.borrowID = "0"
                }
            }
        }
    }
}
