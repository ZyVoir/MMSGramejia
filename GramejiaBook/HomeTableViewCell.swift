//
//  HomeTableViewCell.swift
//  GramejiaBook
//
//  Created by prk on 25/09/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var IV_BookCover: UIImageView!
    
    @IBOutlet weak var Lbl_BookTitle: UILabel!
    
    @IBOutlet weak var Lbl_BookAuthor: UILabel!
    
    @IBOutlet weak var Lbl_BookRating: UILabel!
    
    @IBOutlet weak var Lbl_BookPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
