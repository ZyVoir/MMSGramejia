import UIKit
class SharedValue{
    static let shared = SharedValue()
    
    var signedInEmail : String = ""
    var signedInPassword : String = ""
    var signedInRole : String = ""
    var signedInBalance : Double = 0.0
    var signedInUsername : String = ""
    
    func signInUser(email : String, username : String, password : String, balance : Double){
        self.signedInRole = "user"
        self.signedInBalance = balance
        self.signedInEmail = email
        self.signedInPassword = password
        self.signedInUsername = username
    }
    
    func signInAdmin(email : String, username : String, password : String){
        self.signedInRole = "admin"
        self.signedInBalance = 0.0
        self.signedInEmail = email
        self.signedInPassword = password
        self.signedInUsername = username
    }
    
    func logOut(){
        self.signedInRole = ""
        self.signedInBalance = 0.0
        self.signedInEmail = ""
        self.signedInPassword = ""
        self.signedInUsername = ""
    }
    
    func randomRating() -> Double {
        let range = Array(stride(from: 2.5, to: 5, by: 0.1))
        let randomIndex = Int.random(in: 0..<range.count)
        return range[randomIndex]
    }
    
    func formatDateToString(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: date)
    
        
        return dateString
    }
    
    private init(){}
}
