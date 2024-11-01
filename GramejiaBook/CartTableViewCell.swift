//
//  CartTableViewCell.swift
//  GramejiaBook
//
//  Created by prk on 01/10/24.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Lbl_CartBookTitle: UILabel!
    
    
    @IBOutlet weak var Lbl_CartBookPrice: UILabel!
    
    
    @IBOutlet weak var IV_CartBookCover: UIImageView!
    
    
    @IBOutlet weak var TF_CartBookQuantity: UITextField!
    
    
    @IBOutlet weak var Btn_DecreaseQuantity: UIButton!
    
    
    @IBOutlet weak var Btn_IncreaseQuantity: UIButton!
    
    
    @IBOutlet weak var Btn_RadioButton: UIButton!
    
    var onCartDelete : (() -> Void)?
    
    @IBAction func DeleteButton(_ sender: Any) {
        print("masuk dlete")
        onCartDelete?()
    }
    
    
    var quantityChanged: ((Int) -> Void)?
    
    var isSelectedRadio: Bool = true {
        didSet {
            updateRadioButton()
        }
    }
        
    private func updateRadioButton() {
        let imageName = isSelectedRadio ? "radio button checked" : "radio button uncheckked"
        let image = UIImage(named: imageName)
        Btn_RadioButton.setImage(image, for: .normal)
    }
    
    
    @IBAction func DecreaseQuantity(_ sender: UIButton) {
        if let quantityText = TF_CartBookQuantity.text,
            let quantity = Int(quantityText), quantity > 1 {
            TF_CartBookQuantity.text = "\(quantity - 1)"
            quantityChanged?(quantity-1)
        }
    }
    
    
    @IBAction func IncreaseQuantity(_ sender: UIButton) {
        if let quantityText = TF_CartBookQuantity.text, let quantity = Int(quantityText){
            TF_CartBookQuantity.text = "\(quantity + 1)"
            quantityChanged?(quantity + 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
