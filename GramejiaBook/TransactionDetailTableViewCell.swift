//
//  TransactionDetailTableViewCell.swift
//  GramejiaBook
//
//  Created by prk on 11/10/24.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var IV_BookCover: UIImageView!
    
    @IBOutlet weak var Lbl_BookTitle: UILabel!
    
    @IBOutlet weak var Lbl_QtyXPrice: UILabel!
    
    @IBOutlet weak var Lbl_Subtotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
