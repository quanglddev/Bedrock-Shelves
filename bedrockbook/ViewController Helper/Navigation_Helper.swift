//
//  Navigation_Helper.swift
//  bedrockbook
//
//  Created by QUANG on 7/27/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "ShowDetail":
            guard let detailCardTVC = segue.destination as? BookDetailVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBoxCell = sender as? myCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = booksCollectionView.indexPath(for: selectedBoxCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            if isFiltering() {
                let selectedBook = searchedBooks[indexPath.row]
                detailCardTVC.book = selectedBook
            }
            else {
                if isMyCollection {
                    let selectedBook = myCollection[indexPath.row]
                    detailCardTVC.book = selectedBook
                }
                else {
                    let selectedBook = books[indexPath.row]
                    detailCardTVC.book = selectedBook
                }
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

