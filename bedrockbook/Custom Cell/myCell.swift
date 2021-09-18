//
//  myCell.swift
//  bedrockbook
//
//  Created by Nguyenxloc on 6/30/18.
//  Copyright © 2018 Nguyenxloc. All rights reserved.
//

import UIKit

protocol BookCellDelegate: class {
    
    func delete(cell : myCell)
}

class myCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButtonBackgroundView: UIVisualEffectView!
    @IBOutlet weak var myImageView: UIImageView!
    
    weak var delegate: BookCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        deleteButtonBackgroundView.layer.cornerRadius = deleteButtonBackgroundView.bounds.width / 2.0
        
        deleteButtonBackgroundView.layer.masksToBounds = true
    }
    
    var isEditing: Bool = false {
        didSet{
            deleteButtonBackgroundView.isHidden = !isEditing
        }
    }
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        delegate?.delete(cell: self)
    }
}
