class bookModel {
    var imgLInk : String = ""
    var title : String = ""
    var author : String = ""
    var publisher : String = ""
    var language : String = ""
    var numPages : Int  = 0
    var synopsis : String = ""
    var price : Double = 0.0
    var rating : Double = 0.0
    
    init(imgLInk: String, title: String, author: String, publisher: String, language: String, numPages: Int, synopsis: String, price: Double, rating : Double) {
        self.imgLInk = imgLInk
        self.title = title
        self.author = author
        self.publisher = publisher
        self.language = language
        self.numPages = numPages
        self.synopsis = synopsis
        self.price = price
        self.rating = rating
    }
    
   
}
