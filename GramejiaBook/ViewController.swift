//
//  ViewController.swift
//  GramejiaBook
//
//  Created by prk on 9/17/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context : NSManagedObjectContext!
    
    
    @IBAction func btn_SignUp(_ sender: Any) {
        performSegue(withIdentifier: "Segue_SignUp", sender: self)
    }
    
    func loginSuccess(loginReq : NSManagedObject){
        let email = loginReq.value(forKey: "email") as! String
        let password = loginReq.value(forKey: "password") as! String
        let username = loginReq.value(forKey: "username") as! String
        let balance = loginReq.value(forKey: "balance") as! Double
        
        let role = loginReq.value(forKey: "role") as! String
        
        if role == "user"{
            SharedValue.shared.signInUser(email: email, username: username, password: password, balance: balance)
            performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        else {
            SharedValue.shared.signInAdmin(email: "admin@gmail.com", username: "Administrator", password: "admin123")
            performSegue(withIdentifier: "LoginAdmin", sender: self)
        }
    }
    
    @IBOutlet var LoginUnderline: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO : Instantly add 1 admin account
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        initializeAdmin()
        initializeBook()
    }
        
    @IBOutlet weak var LoginBorder: UIView!
    
    @IBOutlet weak var TF_email: UITextField!
    
    @IBOutlet weak var TF_password: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        TF_email.text = ""
        TF_password.text = ""
    }
    
    func showAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
       
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    
    @IBAction func Btn_Login(_ sender: Any) {
        let email : String = TF_email.text ?? ""
        let password : String = TF_password.text ?? ""
        
        if email == "" || password == "" {
            showAlert(title: "Error", msg: "All Field must be Filled!")
        }
        else if !email.hasSuffix("@gmail.com"){
            showAlert(title: "Error", msg: "Email must ends with @gmail.com")
        }
        else if email.count <= 10 {
            showAlert(title: "Error", msg: "Email must has a prefix")
        }
        else if password.count < 7 {
            showAlert(title: "Error", msg: "Password must be at least 7 characters long")
        }
        else {
            // TODO : Check if exist email and password
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            req.predicate = NSPredicate(format: "email == %@ AND password == %@", email,password)
            do{
                let res = try context.fetch(req) as! [NSManagedObject]
                
                if res.first != nil {
                    if let user = res.first {
                        loginSuccess(loginReq: user)
                    }
                }else {
                    showAlert(title: "ERROR", msg: "Wrong Credential!")
                }
            } catch {
             print("Login Failed!")
            }
        }
        
    }
    
    func cornerLoginUnderline(){
        LoginUnderline.layer.cornerRadius = LoginUnderline.frame.height/2
        LoginUnderline.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func initLoginBorder(){
        LoginBorder.layer.cornerRadius = 7
        LoginBorder.translatesAutoresizingMaskIntoConstraints = true
        LoginBorder.applyGradient()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cornerLoginUnderline()
        initLoginBorder()
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func initializeBook(){
        let bookTest : bookModel = bookModel(imgLInk: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1598823299i/42844155.jpg", title: "Harry Potter", author: "J.K Rowling", publisher: "GrameJia", language: "English", numPages: 500, synopsis: "Harry Potter has never even heard of Hogwarts when the letters start dropping on the doormat at number four, Privet Drive. Addressed in green ink on yellowish parchment with a purple seal, they are swiftly confiscated by his grisly aunt and uncle. Then, on Harry's eleventh birthday, a great beetle-eyed giant of a man called Rubeus Hagrid bursts in with some astonishing news: Harry Potter is a wizard, and he has a place at Hogwarts School of Witchcraft and Wizardry. An incredible adventure is about to begin!", price: 30.20, rating: 4.98)
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        req.predicate = NSPredicate(format: "title == %@ AND author == %@", bookTest.title,bookTest.author)
        
        do{
            let res = try context.fetch(req) as! [NSManagedObject]
            
            if res.first == nil {
                
                let entity = NSEntityDescription.entity(forEntityName: "Book", in: context)
                let initBook = NSManagedObject(entity: entity!, insertInto: context)
                
                
                initBook.setValue(bookTest.author, forKey: "author")
                initBook.setValue(bookTest.imgLInk, forKey: "imgLink")
                initBook.setValue(bookTest.language, forKey: "language")
                initBook.setValue(bookTest.numPages, forKey: "numberPages")
                initBook.setValue(bookTest.price, forKey: "price")
                initBook.setValue(bookTest.publisher, forKey: "publisher")
                initBook.setValue(bookTest.rating, forKey: "rating")
                initBook.setValue(bookTest.synopsis, forKey: "synopsis")
                initBook.setValue(bookTest.title, forKey: "title")
                
                do{
                    try context.save()
                }catch{
                    print("addding admin failed")
                }
            }
            
        }catch {
            print("Error initializing a book")
        }
    }
    
    func initializeAdmin(){
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        req.predicate = NSPredicate(format: "role == %@", "admin")
        
        let email = "admin@gmail.com"
        let password = "admin123"
        let username = "Administrator"
        let role = "admin"
        let balance : Double = 0.0
        
        
        do{
            let res = try context.fetch(req) as! [NSManagedObject]
            
            if res.first == nil {
                
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                let admin = NSManagedObject(entity: entity!, insertInto: context)
                
                
                admin.setValue(email, forKey: "email")
                admin.setValue(password, forKey: "password")
                admin.setValue(username, forKey: "username")
                admin.setValue(role, forKey: "role")
                admin.setValue(balance, forKey: "balance")
                
                do{
                    try context.save()
                }catch{
                    print("addding admin failed")
                }
            }
            
        }catch {
            print("Error initializing admin account")
        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        //        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if let src = unwindSegue.source as? SignUpVIewController {
            
        }
        else if let src = unwindSegue.source as? AdminHomeViewController{
            
        }
    }
}



extension UIView {
    func applyGradient(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0.56, green: 0.86, blue: 0.76, alpha: 1), UIColor(red: 0.26, green: 0.49, blue: 0.56, alpha: 1)]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
}

extension UIImageView{
    func loadImage(from url: URL){
        URLSession.shared.dataTask(with: url) {data,res,err in
            if let err = err {
                print("Error loading image: \(err)")
                return
            }
            
            
            guard let data = data, let image = UIImage(data: data) else {
                print("could not convert data into image")
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
