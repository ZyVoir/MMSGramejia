import UIKit

class TransactionModel{
    var email : String = ""
    var UUID : UUID?
    var purchaseDate : Date = Date()
    var title : String = ""
    var image : String = ""
    var quantity : Int = 0
    var price : Double = 0.0
    
    init(email: String, UUID: UUID? = nil, purchaseDate: Date, title: String, image: String, quantity: Int, price: Double) {
        self.email = email
        self.UUID = UUID
        self.purchaseDate = purchaseDate
        self.title = title
        self.image = image
        self.quantity = quantity
        self.price = price
    }
}


