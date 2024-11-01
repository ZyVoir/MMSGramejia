class CartModel {
    var title : String = ""
    var author : String = ""
    var price : Double = 0.0
    var quantity : Int = 0
    var image : String = ""
    var email : String = ""
    var isSelected : Bool = true
    
    init(title: String, author: String, price: Double, quantity: Int, image: String, email: String, isSelected: Bool) {
        self.title = title
        self.author = author
        self.price = price
        self.quantity = quantity
        self.image = image
        self.email = email
        self.isSelected = isSelected
    }
}
