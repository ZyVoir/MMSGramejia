//
//  TransactionTableViewCell.swift
//  GramejiaBook
//
//  Created by prk on 10/10/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    

    @IBOutlet weak var LB_TransactionID: UILabel!
    
    @IBOutlet weak var LB_TransactionDate: UILabel!
    
    @IBOutlet weak var LB_TotalPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
